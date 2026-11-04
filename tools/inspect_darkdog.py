"""Read the source project without saving it; run with Blender --disable-autoexec."""
import bpy
import hashlib
import json
import sys
from pathlib import Path
from mathutils import Vector

root = Path(__file__).resolve().parents[1]
source = Path(sys.argv[sys.argv.index('--') + 1])
digest = hashlib.sha256(source.read_bytes()).hexdigest()
bpy.ops.wm.open_mainfile(filepath=str(source))
report = {'source': str(source), 'sha256': digest, 'objects': [], 'images': []}
depsgraph = bpy.context.evaluated_depsgraph_get()
for obj in bpy.data.objects:
    item = {'name': obj.name, 'type': obj.type, 'parent': obj.parent.name if obj.parent else None,
            'collections': [c.name for c in obj.users_collection], 'hidden': obj.hide_get(),
            'matrix_world': [list(row) for row in obj.matrix_world],
            'location_world': list(obj.matrix_world.translation), 'dimensions': list(obj.dimensions),
            'modifiers': [{'name': m.name, 'type': m.type} for m in obj.modifiers]}
    if obj.type == 'MESH':
        ev = obj.evaluated_get(depsgraph)
        mesh = ev.to_mesh()
        mesh.calc_loop_triangles()
        points = [obj.matrix_world @ v.co for v in mesh.vertices]
        item.update(vertices=len(mesh.vertices), triangles=len(mesh.loop_triangles),
                    bounds={'min': [min(p[i] for p in points) for i in range(3)],
                            'max': [max(p[i] for p in points) for i in range(3)]},
                    uv_layers=[u.name for u in mesh.uv_layers],
                    active_uv=mesh.uv_layers.active.name if mesh.uv_layers.active else None,
                    materials=[m.name if m else None for m in mesh.materials])
        ev.to_mesh_clear()
    report['objects'].append(item)
for im in bpy.data.images:
    report['images'].append({'name': im.name, 'path': im.filepath, 'packed': bool(im.packed_file), 'size': list(im.size)})
report['source_unchanged'] = digest == hashlib.sha256(source.read_bytes()).hexdigest()
(root / 'doc/darkdog_source_inspection.json').write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding='utf-8')
for o in report['objects']:
    print(json.dumps({k: v for k, v in o.items() if k != 'matrix_world'}, ensure_ascii=True))
print(json.dumps(report['images'], ensure_ascii=True))
