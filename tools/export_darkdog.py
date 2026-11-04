"""Export Darkdog evaluated geometry to OGRE without modifying the source blend.

Blender --background --disable-autoexec --python tools/export_darkdog.py -- SOURCE CONVERTER
CONVERTER is the directory containing ogre_obj_converter.py and tools/OgreXMLConverter.exe.
"""
import bpy
import hashlib
import json
import math
from pathlib import Path
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET
from mathutils import Matrix, Vector

ROOT = Path(__file__).resolve().parents[1]
args = sys.argv[sys.argv.index('--') + 1:]
SOURCE, CONVERTER = map(Path, args[:2])
sys.dont_write_bytecode = True
sys.path.insert(0, str(CONVERTER))
import ogre_obj_converter as ogre

digest = hashlib.sha256(SOURCE.read_bytes()).hexdigest()
bpy.ops.wm.open_mainfile(filepath=str(SOURCE))
AXIS = Matrix(((1, 0, 0, 0), (0, 0, 1, 0), (0, -1, 0, 0), (0, 0, 0, 1)))
REFLECT = Matrix.Diagonal(Vector((-1, 1, 1, 1)))
depsgraph = bpy.context.evaluated_depsgraph_get()
models = ROOT / 'models'
models.mkdir(exist_ok=True)
report = {'source': str(SOURCE), 'source_sha256': digest, 'blender': bpy.app.version_string,
          'axis_mapping': '(x,y,z) -> (x,z,-y)', 'uv_mapping': '(u,v) -> (u,1-v)',
          'scale': 1, 'components': [], 'mounts': {}}

# The supplied origins define the horizontal turntable centres. Put the vertical
# reference at the bottom of each turret; yaw is unchanged by this Y choice.
mounts = {}
for name, rotation in [('turret1', 0), ('turret2', math.pi)]:
    obj = bpy.data.objects[name]
    origin = AXIS @ obj.matrix_world.translation
    origin.y = min((AXIS @ obj.matrix_world @ v.co).y for v in obj.data.vertices)
    mounts[name] = (origin, rotation)
    report['mounts'][name] = {'offset': list(origin), 'rotation': rotation, 'total_range_degrees': 140}

specs = [('body', 'body', Vector((0, 0, 0)), 0, False, 'UV_WF')]
for name, (offset, rotation) in mounts.items():
    specs.append((name, name, offset, rotation, False, 'UV_WF'))
for name in ('track', 'wheel'):
    for side, mirror in [('left', True), ('right', False)]:
        specs.append((name, name + '_' + side, Vector((0, 0, 0)), 0, mirror, 'UVMap'))

with tempfile.TemporaryDirectory(prefix='darkdog_ogre_') as check:
    for source_name, output_name, offset, angle, mirror, uv_name in specs:
        obj = bpy.data.objects[source_name]
        ev = obj.evaluated_get(depsgraph)
        mesh = ev.to_mesh(preserve_all_data_layers=True, depsgraph=depsgraph)
        mesh.calc_loop_triangles()
        uv = mesh.uv_layers[uv_name]
        source_transform = (REFLECT if mirror else Matrix.Identity(4)) @ AXIS @ obj.matrix_world
        mount_transform = Matrix.Translation(offset) @ Matrix.Rotation(angle, 4, 'Y')
        local_transform = mount_transform.inverted() @ source_transform
        normal_transform = local_transform.to_3x3().inverted().transposed()
        positions, normals, uvs, indices, source_corners = [], [], [], [], []
        removed = 0
        for tri in mesh.loop_triangles:
            loops = list(tri.loops)
            p = [local_transform @ mesh.vertices[mesh.loops[l].vertex_index].co for l in loops]
            if (p[1] - p[0]).cross(p[2] - p[0]).length < 1e-10:
                removed += 1
                continue
            if local_transform.to_3x3().determinant() < 0:
                loops.reverse()
            for l in loops:
                local = local_transform @ mesh.vertices[mesh.loops[l].vertex_index].co
                normal = (normal_transform @ mesh.corner_normals[l].vector).normalized()
                texcoord = (uv.data[l].uv.x, 1 - uv.data[l].uv.y)
                indices.append(len(positions))
                positions.append(tuple(local))
                normals.append(tuple(normal))
                uvs.append(texcoord)
                source_corners.append(source_transform @ mesh.vertices[mesh.loops[l].vertex_index].co)
        part = ogre.Part('darkdog_' + output_name, 'darkdog', ogre.Geometry(positions, normals, uvs), indices)
        binary = ogre.write_mesh(ogre.Mesh([part]))
        decoded = ogre.read_mesh(binary)
        assert not decoded.warnings, decoded.warnings
        output = models / ('darkdog_' + output_name + '.mesh')
        output.write_bytes(binary)
        actual = decoded.parts[0].geometry
        pos_error = max((mount_transform @ Vector(p) - q).length for p, q in zip(actual.positions, source_corners))
        normal_error = max((Vector(p) - Vector(q)).length for p, q in zip(actual.normals, normals))
        uv_error = max(max(abs(a-b) for a, b in zip(p, q)) for p, q in zip(actual.uvs, uvs))
        assert pos_error < 3e-6 and normal_error < 2e-6 and uv_error < 2e-6
        assert ogre.triangles(decoded.parts[0]) == ogre.triangles(part)
        xml_path = Path(check) / (output.stem + '.xml')
        result = subprocess.run([str(CONVERTER / 'tools/OgreXMLConverter.exe'), '-q', '-log',
                                 str(Path(check) / 'ogre.log'), str(output), str(xml_path)],
                                capture_output=True, timeout=45)
        assert result.returncode == 0 and xml_path.exists(), result.stderr
        xml = ET.parse(xml_path).getroot()
        vertices = xml.findall('./submeshes/submesh/geometry/vertexbuffer/vertex')
        assert len(vertices) == len(positions)
        faces = xml.findall('./submeshes/submesh/faces/face')
        assert [tuple(int(f.get(k)) for k in ('v1', 'v2', 'v3')) for f in faces] == ogre.triangles(part)
        for i, vertex in enumerate(vertices):
            for tag, axes, values in [('position', 'xyz', actual.positions[i]),
                                      ('normal', 'xyz', actual.normals[i]), ('texcoord', 'uv', actual.uvs[i])]:
                node = vertex.find(tag)
                assert all(math.isclose(float(node.get(a)), v, rel_tol=6e-6, abs_tol=6e-6) for a,v in zip(axes, values))
        item = {'mesh': output.name, 'source_object': source_name, 'mirrored_x': mirror,
                'offset': list(offset), 'rotation': angle, 'uv_layer': uv_name,
                'triangles': len(indices)//3, 'vertices': len(positions), 'removed_degenerate_triangles': removed,
                'max_assembled_position_error': pos_error, 'max_normal_error': normal_error,
                'max_uv_error': uv_error, 'independent_ogre_check': True,
                'sha256': hashlib.sha256(binary).hexdigest()}
        report['components'].append(item)
        ev.to_mesh_clear()
        print(output.name, item['triangles'], 'triangles; assembled error', pos_error, flush=True)

report['weapons'] = []
for marker, mount in [('maincannon','turret1'), ('minigun','turret2'), ('20mm','turret1'),
                      ('missile','turret1'), ('missile.001','turret1'), ('hive','turret2')]:
    world = AXIS @ bpy.data.objects[marker].matrix_world.translation
    origin, angle = mounts[mount]
    local = Matrix.Rotation(-angle, 3, 'Y') @ (world - origin)
    report['weapons'].append({'marker': marker, 'mount': mount, 'world': list(world), 'weapon_offset': list(local)})
collision = bpy.data.objects['collishion']
points = [AXIS @ collision.matrix_world @ Vector(p) for p in collision.bound_box]
lo = Vector([min(p[i] for p in points) for i in range(3)])
hi = Vector([max(p[i] for p in points) for i in range(3)])
report['collision'] = {'center': list((lo+hi)/2), 'extent': list(hi-lo)}
report['source_unchanged'] = digest == hashlib.sha256(SOURCE.read_bytes()).hexdigest()
assert report['source_unchanged']
(ROOT/'doc/darkdog_export_report.json').write_text(json.dumps(report, indent=2), encoding='utf-8')
print(json.dumps({'mounts': report['mounts'], 'weapons': report['weapons'], 'collision': report['collision']}))
