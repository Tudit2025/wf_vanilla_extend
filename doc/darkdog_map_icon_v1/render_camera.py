"""Render Darkdog using Landship v2 camera framing and the shipped game assembly.

Run with Blender --background --disable-autoexec --python THIS_SCRIPT.
Reads the local OGRE converter; writes only this directory.
"""

import hashlib
import json
import math
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

import bpy
from bpy_extras.object_utils import world_to_camera_view
from mathutils import Matrix, Vector

sys.dont_write_bytecode = True
CONVERTER = Path(r"C:\Users\11447\Desktop\wkp\sizeref")
sys.path.insert(0, str(CONVERTER))
import ogre_obj_converter as ogre

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PACKAGES = [ROOT, ROOT.parent / "wf_base", ROOT.parent / "vanilla"]
vehicle_path = ROOT / "vehicles/darkdog.vehicle"
vehicle = ET.parse(vehicle_path).getroot()
turrets = vehicle.findall("turret")
sources = {str(vehicle_path): hashlib.sha256(vehicle_path.read_bytes()).hexdigest()}


def resolve(folder, name):
    path = next(p / folder / name for p in PACKAGES if (p / folder / name).is_file())
    sources[str(path)] = hashlib.sha256(path.read_bytes()).hexdigest()
    return path


def vec(text):
    return Vector(tuple(float(v) for v in text.split()))


def to_blender(v):
    return Vector((v.x, -v.z, v.y))


bpy.ops.wm.read_factory_settings(use_empty=True)
materials = {}
points = []
visual_offset = vec(vehicle.find("physics").get("visual_offset", "0 0 0"))
for visual in vehicle.findall("visual"):
    if visual.get("key") == "broken":
        continue
    name = visual.get("mesh_filename")
    texture = visual.get("texture_filename") or visual.find("part").get("texture_filename")
    offset = vec(visual.get("offset", "0 0 0"))
    rotation = 0.0
    if visual.get("class") == "turret":
        turret = turrets[int(visual.get("turret_index", "0"))]
        offset = vec(turret.get("offset"))
        rotation = float(turret.get("rotation", "0"))
    rotation_matrix = Matrix.Rotation(rotation, 3, "Y")
    if texture not in materials:
        material = bpy.data.materials.new(texture)
        material.use_nodes = True
        bsdf = material.node_tree.nodes.get("Principled BSDF")
        bsdf.inputs["Roughness"].default_value = 0.85
        tex = material.node_tree.nodes.new("ShaderNodeTexImage")
        tex.image = bpy.data.images.load(str(resolve("textures", texture)), check_existing=True)
        material.node_tree.links.new(tex.outputs["Color"], bsdf.inputs["Base Color"])
        materials[texture] = material
    source = ogre.read_mesh(resolve("models", name).read_bytes())
    assert not source.warnings, source.warnings
    for part in source.parts:
        geometry = part.geometry
        vertices = [to_blender(rotation_matrix @ Vector(v) + offset + visual_offset) for v in geometry.positions]
        points.extend(vertices)
        faces = [part.indices[i:i + 3] for i in range(0, len(part.indices), 3)]
        data = bpy.data.meshes.new(name)
        data.from_pydata(vertices, [], faces)
        data.update()
        if geometry.uvs is not None:
            uv_layer = data.uv_layers.new(name="UVMap")
            for loop in data.loops:
                u, v = geometry.uvs[loop.vertex_index][:2]
                uv_layer.data[loop.index].uv = (u, 1 - v)
        if geometry.normals is not None:
            data.normals_split_custom_set_from_vertices([to_blender(rotation_matrix @ Vector(n)) for n in geometry.normals])
        obj = bpy.data.objects.new(name, data)
        bpy.context.collection.objects.link(obj)
        data.materials.append(materials[texture])

scene = bpy.context.scene
scene.render.engine = "CYCLES"
scene.cycles.device = "CPU"
scene.cycles.samples = 24
scene.cycles.use_denoising = True
scene.render.resolution_x = 1024
scene.render.resolution_y = 1024
scene.render.resolution_percentage = 100
scene.render.image_settings.file_format = "PNG"
scene.render.image_settings.color_mode = "RGBA"
scene.render.film_transparent = True
scene.world = bpy.data.worlds.new("Reference lighting")
scene.world.use_nodes = True
scene.world.node_tree.nodes["Background"].inputs[0].default_value = (0.65, 0.70, 0.78, 1)
scene.world.node_tree.nodes["Background"].inputs[1].default_value = 0.7
scene.view_settings.view_transform = "Standard"

# Game +Z is the front; in Blender this is -Y. Move nearer the longitudinal axis.
azimuth = math.radians(18)
elevation = math.radians(24)
fov = math.radians(70)
back = Vector((math.sin(azimuth) * math.cos(elevation), -math.cos(azimuth) * math.cos(elevation), math.sin(elevation)))
low = Vector(tuple(min(p[i] for p in points) for i in range(3)))
high = Vector(tuple(max(p[i] for p in points) for i in range(3)))
target = (low + high) / 2
target.z = low.z + (high.z - low.z) * 0.35
rotation = (-back).to_track_quat("-Z", "Y")
right = rotation @ Vector((1, 0, 0))
up = rotation @ Vector((0, 1, 0))
relative = [p - target for p in points]


def projected(distance):
    return [(0.5 + p.dot(right) / (2 * (distance - p.dot(back)) * math.tan(fov / 2)),
             0.5 + p.dot(up) / (2 * (distance - p.dot(back)) * math.tan(fov / 2))) for p in relative]


# Widen the lens and dolly closer until the entire assembly fills 86% of frame.
near = max(p.dot(back) for p in relative) + 0.01
far = 100.0
for _ in range(60):
    distance = (near + far) / 2
    projected_points = projected(distance)
    spread = max(max(p[i] for p in projected_points) - min(p[i] for p in projected_points) for i in (0, 1))
    if spread > 0.86:
        near = distance
    else:
        far = distance
distance = far
projected_points = projected(distance)
center = [(min(p[i] for p in projected_points) + max(p[i] for p in projected_points)) / 2 for i in (0, 1)]
bpy.ops.object.camera_add(location=target + back * distance)
camera = bpy.context.object
camera.rotation_euler = rotation.to_euler()
camera.data.type = "PERSP"
camera.data.sensor_fit = "HORIZONTAL"
camera.data.sensor_width = 36
camera.data.angle = fov
camera.data.shift_x = center[0] - 0.5
camera.data.shift_y = center[1] - 0.5
camera.data.clip_start = 0.1
camera.data.clip_end = 200
scene.camera = camera
bpy.context.view_layer.update()
screen = [world_to_camera_view(scene, camera, p) for p in points]
frame_bounds = [[min(p[i] for p in screen), max(p[i] for p in screen)] for i in (0, 1)]
assert all(0.065 < edge < 0.935 for axis in frame_bounds for edge in axis), frame_bounds

for location, power, size in [((2, -8, 15), 1800, 8), ((-8, -2, 9), 1100, 7), ((4, 8, 10), 1500, 6)]:
    bpy.ops.object.light_add(type="AREA", location=location)
    light = bpy.context.object
    light.data.energy = power
    light.data.shape = "DISK"
    light.data.size = size
    light.rotation_euler = (target - light.location).to_track_quat("-Z", "Y").to_euler()

report = {
    "status": "offline render from game assets; camera changed only",
    "camera_type": "perspective, rectilinear",
    "horizontal_fov_degrees": math.degrees(camera.data.angle_x),
    "vertical_fov_degrees": math.degrees(2 * math.atan(math.tan(fov / 2) * scene.render.resolution_y / scene.render.resolution_x)),
    "lens_mm_36mm_sensor": camera.data.lens,
    "azimuth_degrees_from_front": 18,
    "elevation_degrees": 24,
    "distance_to_target_game_units": distance,
    "location_blender": list(camera.location),
    "target_blender": list(target),
    "shift": [camera.data.shift_x, camera.data.shift_y],
    "projected_frame_bounds": frame_bounds,
    "depth_range": [min(distance - p.dot(back) for p in relative), max(distance - p.dot(back) for p in relative)],
    "source_hashes": sources,
}
(HERE / "camera.json").write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
scene.render.filepath = str(HERE / "darkdog_perspective_reference.png")
bpy.ops.render.render(write_still=True)
print("CAMERA " + json.dumps({k: v for k, v in report.items() if k != "source_hashes"}))
