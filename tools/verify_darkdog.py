"""Validate the shipped configuration and render its actual OGRE assembly.

Blender --background --disable-autoexec --python tools/verify_darkdog.py -- CONVERTER
"""
import bpy
import hashlib
import json
import math
from pathlib import Path
import sys
import xml.etree.ElementTree as ET
from mathutils import Matrix, Vector

ROOT = Path(__file__).resolve().parents[1]
sys.dont_write_bytecode = True
sys.path.insert(0, sys.argv[sys.argv.index('--')+1])
import ogre_obj_converter as ogre

PACKAGES = [ROOT, ROOT.parent/'wf_base', ROOT.parent/'vanilla']
references = {}
def resolve(folder, name):
    for package in PACKAGES:
        p = package/folder/name
        if p.is_file():
            references[folder+'/'+name] = str(p.relative_to(ROOT.parent))
            return p
    raise AssertionError('Missing resource: '+folder+'/'+name)

def vector(text):
    return Vector(tuple(map(float, text.split())))

def transform(node):
    return Matrix.Translation(vector(node.get('offset', '0 0 0'))) @ Matrix.Rotation(float(node.get('rotation', '0')), 4, 'Y')

vehicle = ET.parse(ROOT/'vehicles/darkdog.vehicle').getroot()
export = json.loads((ROOT/'doc/darkdog_export_report.json').read_text())
turrets = vehicle.findall('turret')
assert len(turrets) == 6
assert [int(n.get('turret_index')) for n in vehicle.findall("visual[@class='turret']") if not n.get('key')] == [0, 1]
assert [int(n.get('turret_index')) for n in vehicle.findall("visual[@class='turret'][@key='broken']")] == [0, 1]
assert len(vehicle.findall('character_slot')) == 3
assert [[int(t.get('index')) for t in s.findall('turret')] for s in vehicle.findall('character_slot')] == [[], [0,2,3,4], [1,5]]
assert not any(t.get('name') == 'tank' for t in vehicle.findall('tag'))
for i in (0,1):
    assert abs(float(turrets[i].get('rotation_range'))-math.radians(140)) < 1e-6
assert abs(float(turrets[1].get('rotation'))-math.pi) < 1e-6
for i, parent in [(2,0),(3,0),(4,0),(5,1)]:
    assert int(turrets[i].get('parent_turret_index')) == parent
    assert float(turrets[i].get('rotation_range')) == 0
    assert float(turrets[i].get('rotation')) == 0

def turret_transform(index, yaw=None):
    node = turrets[index]
    matrix = transform(node)
    if yaw and index in yaw:
        matrix = matrix @ Matrix.Rotation(yaw[index], 4, 'Y')
    if node.get('parent_turret_index') is not None:
        matrix = turret_transform(int(node.get('parent_turret_index')), yaw) @ matrix
    return matrix

weapon_files = set()
checked_xml = set()
def check_xml(path, category):
    if path in checked_xml:
        return
    checked_xml.add(path)
    root = ET.parse(path).getroot()
    for node in root.iter():
        if node.get('file'):
            check_xml(resolve(category, node.get('file')), category)
        for attr in ('mesh_filename','texture_filename','filename','fileref'):
            name = node.get(attr)
            if not name:
                continue
            ext = Path(name).suffix.lower()
            folder = {'.mesh':'models','.png':'textures','.dds':'textures','.wav':'sounds','.ogg':'sounds', '.xml':'models'}.get(ext)
            if folder:
                p = resolve(folder, name)
                if ext == '.xml':
                    check_xml(p, folder)
    return root

check_xml(ROOT/'vehicles/darkdog.vehicle', 'vehicles')
muzzle_checks = []
registered = {n.get('file') for n in ET.parse(ROOT/'weapons/invasion_all_weapons.xml').getroot()}
for i, (node, marker) in enumerate(zip(turrets, export['weapons'])):
    key = node.get('weapon_key')
    assert key in registered
    weapon_files.add(key)
    check_xml(resolve('weapons', key), 'weapons')
    weapon = ET.parse(resolve('weapons', key)).getroot()
    spec = weapon.find('specification')
    assert float(spec.get('barrel_offset')) == 0
    barrel_offset = vector(spec.get('barrel_offset_3d', '0 0 0'))
    assert not any(weapon.find('model').attrib.values())
    effective_muzzle = vector(node.get('weapon_offset')) + barrel_offset
    actual = turret_transform(i) @ effective_muzzle
    error = (actual-Vector(marker['world'])).length
    assert error < 3e-6, (marker['marker'], error)
    # Check rigidity at both limits and intermediate yaw: an emitter uses the
    # same transform as the visible geometry of its source mount.
    root_index = int(node.get('parent_turret_index', i))
    maximum_rigid_error = 0
    for degrees in [-70, -35, 0, 35, 70]:
        yaw = {root_index: math.radians(degrees)}
        expected = turret_transform(root_index, yaw) @ Vector(marker['weapon_offset'])
        measured = turret_transform(i, yaw) @ effective_muzzle
        maximum_rigid_error = max(maximum_rigid_error, (expected-measured).length)
    assert maximum_rigid_error < 2e-6
    muzzle_checks.append({'index':i,'marker':marker['marker'],'source_position_error':error,'rigidity_error':maximum_rigid_error})
assert 'darkdog.vehicle' in {n.get('file') for n in ET.parse(ROOT/'vehicles/invasion_all_vehicles.xml').getroot()}
physics = vehicle.find('physics')
for attr, field in [('collision_model_pos','center'),('collision_model_extent','extent')]:
    assert (vector(physics.get(attr))-Vector(export['collision'][field])).length < 2e-6

# Actual visual transforms must match the export mapping, including the rear
# turret's local-space conversion and the reflected left running gear.
assembly_errors = {}
for visual in vehicle.findall('visual'):
    if visual.get('key'):
        continue
    path = resolve('models', visual.get('mesh_filename'))
    mesh = ogre.read_mesh(path.read_bytes())
    component = next(c for c in export['components'] if c['mesh'] == path.name)
    assert hashlib.sha256(path.read_bytes()).hexdigest() == component['sha256']
    actual_matrix = transform(visual)
    if visual.get('class') == 'turret':
        actual_matrix = turret_transform(int(visual.get('turret_index'))) @ actual_matrix
    source_matrix = Matrix.Translation(Vector(component['offset'])) @ Matrix.Rotation(component['rotation'], 4, 'Y')
    error = max((actual_matrix @ Vector(p)-source_matrix @ Vector(p)).length for part in mesh.parts for p in part.geometry.positions)
    assert error < 3e-6
    assembly_errors[path.name] = error

for entry in ['scripts/gamemodes/invasion/gamemode_invasion.as']:
    content = (ROOT/entry).read_text(encoding='utf-8')
    assert '#include "darkdog_command_handler.as"' in content
    assert 'addTracker(DarkdogCommandHandler(this));' in content
handler = (ROOT/'scripts/trackers/darkdog_command_handler.as').read_text()
assert 'BasicCommandHandler::handleChatEvent(event);' in handler
assert '"/darkdog"' in handler

def write_report(previews):
    source = Path(export['source'])
    assert hashlib.sha256(source.read_bytes()).hexdigest() == export['source_sha256']
    report = {'passed':True, 'source_sha256':export['source_sha256'], 'source_unchanged':True,
              'weapons':sorted(weapon_files), 'muzzles':muzzle_checks,'assembly_errors':assembly_errors,
              'resolved_resources':references, 'xml_files_checked':len(checked_xml),'previews':previews,
              'vehicle_tuning': {'control':vehicle.find('control').attrib, 'physics':physics.attrib,
                                 'tire_sets':[t.attrib for t in vehicle.findall('tire_set')]},
              'weapon_tuning': {key:{n.tag:n.attrib for n in ET.parse(resolve('weapons',key)).getroot()
                                    if n.tag in ('specification','ballistics','projectile')}
                               for key in sorted(weapon_files)},
              'not_run':['RWR runtime and AngelScript compilation','driving / crew / firing / sound / track animation in game']}
    (ROOT/'doc/darkdog_verification.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
    print('DARKDOG_VERIFIED', len(references), 'references;', len(checked_xml), 'XML resources', flush=True)

if '--skip-render' in sys.argv:
    previews = [p.name for p in sorted((ROOT/'doc').glob('darkdog_*.png'))]
    write_report(previews)
    sys.exit(0)

bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete(use_global=False)
material_cache = {}
def material(name):
    if name in material_cache:
        return material_cache[name]
    m = bpy.data.materials.new(name)
    m.use_nodes = True
    bsdf = m.node_tree.nodes.get('Principled BSDF')
    bsdf.inputs['Roughness'].default_value = 0.85
    tex = m.node_tree.nodes.new('ShaderNodeTexImage')
    tex.image = bpy.data.images.load(str(resolve('textures',name)), check_existing=True)
    m.node_tree.links.new(tex.outputs['Color'], bsdf.inputs['Base Color'])
    material_cache[name] = m
    return m

TO_BLENDER = Matrix(((1,0,0,0),(0,0,-1,0),(0,1,0,0),(0,0,0,1)))
visual_offset = Matrix.Translation(vector(physics.get('visual_offset')))
assembled = []
for visual in vehicle.findall('visual'):
    if visual.get('key'):
        continue
    path = resolve('models', visual.get('mesh_filename'))
    mesh = ogre.read_mesh(path.read_bytes())
    parts = visual.findall('part')
    for pi, part in enumerate(mesh.parts):
        data = bpy.data.meshes.new(path.stem)
        data.from_pydata(part.geometry.positions, [], ogre.triangles(part))
        data.update()
        uv = data.uv_layers.new(name='GameUV')
        for polygon in data.polygons:
            polygon.use_smooth = True
            for li in polygon.loop_indices:
                vi = data.loops[li].vertex_index
                u,v = part.geometry.uvs[vi]
                uv.data[li].uv = (u,1-v)
        data.normals_split_custom_set_from_vertices(part.geometry.normals)
        texture = parts[pi].get('texture_filename') if parts else visual.get('texture_filename')
        data.materials.append(material(texture))
        obj = bpy.data.objects.new(path.stem, data)
        bpy.context.collection.objects.link(obj)
        matrix = transform(visual)
        if visual.get('class') == 'turret':
            matrix = turret_transform(int(visual.get('turret_index'))) @ matrix
        obj.matrix_world = TO_BLENDER @ visual_offset @ matrix
        assembled.append((obj,visual))

bpy.ops.mesh.primitive_plane_add(size=200, location=(0,0,0.60))
floor = bpy.context.object
m = bpy.data.materials.new('Ground')
m.diffuse_color = (0.15,0.18,0.21,1)
floor.data.materials.append(m)
scene = bpy.context.scene
scene.render.engine = 'CYCLES'
scene.cycles.samples = 32
scene.cycles.use_denoising = True
scene.render.resolution_x = 1100
scene.render.resolution_y = 1100
scene.render.resolution_percentage = 100
scene.world.color = (0.3,0.3,0.3)
scene.view_settings.view_transform = 'AgX'
for position, energy, size in [((3,-5,12),1900,8),((-6,0,7),1200,7),((2,8,8),1500,6)]:
    bpy.ops.object.light_add(type='AREA', location=position)
    lamp = bpy.context.object
    lamp.data.energy = energy
    lamp.data.shape = 'DISK'
    lamp.data.size = size
    lamp.rotation_euler = (Vector((0,0,1.5))-lamp.location).to_track_quat('-Z','Y').to_euler()
bpy.ops.object.camera_add(location=(10,-13,14))
camera = bpy.context.object
camera.data.type = 'ORTHO'
camera.data.ortho_scale = 14
scene.camera = camera
preview_files = []
for name, location, yaw in [('assembled',(10,-13,14),{}),('rear',(-10,13,12),{}),
                             ('arcs',(0,-0.01,22),{0:math.radians(70),1:math.radians(-70)})]:
    camera.location = location
    camera.rotation_euler = (Vector((0,0,1.5))-camera.location).to_track_quat('-Z','Y').to_euler()
    for obj, visual in assembled:
        if visual.get('class') == 'turret':
            obj.matrix_world = TO_BLENDER @ visual_offset @ turret_transform(int(visual.get('turret_index')),yaw) @ transform(visual)
    path = ROOT/'doc'/('darkdog_'+name+'.png')
    scene.render.filepath = str(path)
    bpy.ops.render.render(write_still=True)
    preview_files.append(path.name)

write_report(preview_files)
