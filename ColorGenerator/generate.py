import os
import json

# JSON 파일 읽기
with open("colors.json", "r") as file:
    colors = json.load(file)

# Assets.xcassets 디렉토리 생성
assets_dir = "Assets.xcassets"
os.makedirs(assets_dir, exist_ok=True)

# 각 색상을 Asset으로 추가
for color in colors:
    name = color["name"]
    r, g, b, a = color["color"].values()

    # 색상 디렉토리 생성
    color_dir = os.path.join(assets_dir, f"{name}.colorset")
    os.makedirs(color_dir, exist_ok=True)

    # Contents.json 생성
    contents = {
        "info": {
            "version": 1,
            "author": "xcode"
        },
        "colors": [
            {
                "idiom": "universal",
                "color": {
                    "color-space": "srgb",
                    "components": {
                        "red": f"{r / 255:.3f}",
                        "green": f"{g / 255:.3f}",
                        "blue": f"{b / 255:.3f}",
                        "alpha": f"{a:.1f}"
                    }
                }
            }
        ]
    }

    with open(os.path.join(color_dir, "Contents.json"), "w") as json_file:
        json.dump(contents, json_file, indent=2)

print("Colors have been successfully added to Assets.xcassets!")
