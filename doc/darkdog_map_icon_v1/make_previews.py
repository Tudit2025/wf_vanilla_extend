"""Resize the generated artwork, preserve alpha and prepare the game icon.

Run: python -B doc/darkdog_map_icon_v1/make_previews.py
Requires Pillow. Matches Landship v2's 88-percent fit and 128px game cell.
"""

import hashlib
import json
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SOURCE = HERE / "darkdog_map_icon_v1.png"


def fitted(source, size):
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    reduced = source.copy()
    reduced.thumbnail((round(size * 0.88), round(size * 0.88)), Image.Resampling.LANCZOS)
    canvas.alpha_composite(reduced, ((size - reduced.width) // 2, (size - reduced.height) // 2))
    return canvas


def main():
    with Image.open(SOURCE) as source:
        assert source.mode == "RGBA", "Expected generated alpha, not a flattened image."
        icon = source.copy()
    histogram = icon.getchannel("A").histogram()
    assert histogram[0] > icon.width * icon.height * 0.1, "Expected transparent background."
    assert sum(histogram[240:]) > icon.width * icon.height * 0.1, "Expected opaque vehicle surfaces."

    for size in (512, 128, 64):
        fitted(icon, size).save(HERE / f"darkdog_map_icon_v1_{size}.png")
    game_icon = ROOT / "textures/mapview_darkdog.png"
    game_icon.write_bytes((HERE / "darkdog_map_icon_v1_128.png").read_bytes())
    bbox = Image.open(game_icon).getchannel("A").getbbox()
    assert all(0 < edge < 128 for edge in bbox), "Icon must leave padding on every edge."

    board = Image.new("RGBA", (1040, 800), "#edf0ed")
    draw = ImageDraw.Draw(board)
    font_path = Path("C:/Windows/Fonts/arial.ttf")

    def font(size):
        return ImageFont.truetype(str(font_path), size) if font_path.exists() else ImageFont.load_default()

    draw.text((28, 20), "DARKDOG / MAP ICON", fill="#18231f", font=font(28))
    draw.text((28, 60), "Landship v2 camera and style / offline asset preview", fill="#59645f", font=font(18))
    for x, background in ((24, "#ffffff"), (536, "#303b36")):
        draw.rounded_rectangle((x, 104, x + 480, 770), radius=14, fill=background)
        foreground = "#59645f" if x == 24 else "#dce4df"
        board.alpha_composite(fitted(icon, 480), (x, 120))
        draw.line((x + 20, 608, x + 460, 608), fill=foreground, width=1)
        board.alpha_composite(fitted(icon, 128), (x + 20, 624))
        draw.text((x + 154, 679), "128 px", fill=foreground, font=font(18))
        board.alpha_composite(fitted(icon, 64), (x + 268, 656))
        draw.text((x + 340, 679), "64 px", fill=foreground, font=font(18))
    board.convert("RGB").save(HERE / "darkdog_map_icon_v1_preview.png")

    camera = json.loads((HERE / "camera.json").read_text(encoding="utf-8"))
    changed = [path for path, digest in camera["source_hashes"].items()
               if not Path(path).is_file() or hashlib.sha256(Path(path).read_bytes()).hexdigest() != digest]
    report = {
        "status": "offline artwork validation; in-game verification pending",
        "integration_report": "../darkdog_map_icon_integration.json",
        "generator": "built-in image_gen, transparent_background=true",
        "prompt": "prompt.txt",
        "refinement_prompt": "refinement_prompt.txt",
        "refinement_input": "darkdog_map_icon_initial.png",
        "camera_reference": "camera.json",
        "render_script": "render_camera.py",
        "reference_images": ["darkdog_perspective_reference.png",
                             "../../../wf_campaign/doc/landship_map_icon_v2/landship_map_icon_v2.png"],
        "source_size": list(icon.size),
        "source_sha256": hashlib.sha256(SOURCE.read_bytes()).hexdigest(),
        "preview_sizes": [512, 128, 64],
        "standalone_icon": "../../textures/mapview_darkdog.png",
        "alpha_preserved": True,
        "transparent_pixel_count": histogram[0],
        "alpha_240_to_255_pixel_count": sum(histogram[240:]),
        "game_icon_alpha_bbox": list(bbox),
        "reference_model_and_configuration_hashes_unchanged": not changed,
        "reference_inputs_changed_since_render": changed,
        "notes": "Camera parameters describe the Blender render. The final icon is a generated style transfer, not a pixel-exact projection. Resampling preserves generated alpha with the same 88-percent fit as Landship v2.",
    }
    (HERE / "report.json").write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
