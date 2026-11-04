"""Pack Darkdog's generated icon into the campaign override of the WF atlas.

Run from any directory: python -B tools/prepare_darkdog_map_icon.py
Requires Pillow. Reads sibling package resources; writes only this package's
textures/mapview_vehicle.png and doc/darkdog_map_icon_integration.json.
"""

import hashlib
import json
import re
import xml.etree.ElementTree as ET
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
PACKAGES = [ROOT, ROOT.parent / "wf_base", ROOT.parent / "vanilla"]
BASE = ROOT.parent / "wf_base/textures/mapview_vehicle.png"
ICON = ROOT / "textures/mapview_darkdog.png"
OUTPUT = ROOT / "textures/mapview_vehicle.png"
VEHICLE = ROOT / "vehicles/darkdog.vehicle"
INDEX = 82
GRID = 10
CELL = 128
BOX = (256, 1024, 384, 1152)


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def cell_box(index):
    x, y = index % GRID * CELL, index // GRID * CELL
    return x, y, x + CELL, y + CELL


def main():
    hud_path = next(p / "hud.xml" for p in PACKAGES if (p / "hud.xml").is_file())
    hud = ET.parse(hud_path).getroot()
    assert int(hud.get("vehicle_marker_atlas_size")) == GRID, "HUD atlas grid changed."
    vehicle = ET.parse(VEHICLE).getroot()
    assert int(vehicle.get("map_view_atlas_index")) == INDEX
    registry = ET.parse(ROOT / "vehicles/invasion_all_vehicles.xml").getroot()
    assert any(v.get("file") == "darkdog.vehicle" for v in registry.findall("vehicle"))

    # Reject a conflicting explicit assignment anywhere in the loaded packages.
    assignments = []
    pattern = re.compile(r'map_view_atlas_index\s*=\s*["\x27]82["\x27]')
    for package in PACKAGES:
        for path in package.rglob("*"):
            if path.is_file() and path.suffix.lower() in {".vehicle", ".xml", ".as", ".resources", ".cfg"}:
                if pattern.search(path.read_text(encoding="utf-8-sig", errors="replace")):
                    assignments.append(path.resolve())
    assert assignments == [VEHICLE.resolve()], f"Atlas slot {INDEX} conflict: {assignments}"

    base = Image.open(BASE).convert("RGBA")
    icon = Image.open(ICON).convert("RGBA")
    assert base.size == (GRID * CELL, GRID * CELL)
    assert icon.size == (CELL, CELL)
    assert cell_box(INDEX) == BOX
    assert base.crop(BOX).getchannel("A").getbbox() is None, "Base atlas slot is occupied."
    assert icon.getchannel("A").getbbox() is not None

    # Do not overwrite later campaign changes in other cells during a rebuild.
    if OUTPUT.exists():
        existing = Image.open(OUTPUT).convert("RGBA")
        assert existing.size == base.size
        for index in range(GRID * GRID):
            if index != INDEX:
                box = cell_box(index)
                assert existing.crop(box).tobytes() == base.crop(box).tobytes(), f"Existing campaign atlas has a separate change in cell {index}."

    atlas = base.copy()
    # Paste RGBA directly: alpha-compositing would alter the generated edge alpha.
    atlas.paste(icon, BOX[:2])
    atlas.save(OUTPUT)
    with Image.open(OUTPUT) as saved:
        saved = saved.convert("RGBA")
        assert saved.crop(BOX).tobytes() == icon.tobytes()
        for index in range(GRID * GRID):
            if index != INDEX:
                box = cell_box(index)
                assert saved.crop(box).tobytes() == base.crop(box).tobytes()

    report = {
        "status": "installed in wf_vanilla_extend assets; static validation passed; in-game verification pending",
        "vehicle": "vehicles/darkdog.vehicle",
        "map_view_atlas_index": INDEX,
        "atlas_grid": [GRID, GRID],
        "cell_size": [CELL, CELL],
        "cell_pixel_box": list(BOX),
        "standalone_icon": "textures/mapview_darkdog.png",
        "artwork_source": "doc/darkdog_map_icon_v1/darkdog_map_icon_v1_128.png",
        "base_atlas": "../wf_base/textures/mapview_vehicle.png",
        "campaign_atlas": "textures/mapview_vehicle.png",
        "resolved_hud": str(hud_path),
        "base_sha256": digest(BASE),
        "icon_sha256": digest(ICON),
        "campaign_atlas_sha256": digest(OUTPUT),
        "static_checks": {
            "vehicle_xml_parsed": True,
            "vehicle_registered": True,
            "hud_grid_matches": True,
            "base_slot_transparent": True,
            "slot_used_only_by_darkdog": True,
            "inserted_cell_rgba_matches_icon": True,
            "other_99_cells_rgba_unchanged": True,
        },
        "rebuild": "python -B tools/prepare_darkdog_map_icon.py",
        "in_game": "pending: restart the game, spawn /darkdog, check map/hover icon and other vehicles",
    }
    (ROOT / "doc/darkdog_map_icon_integration.json").write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
