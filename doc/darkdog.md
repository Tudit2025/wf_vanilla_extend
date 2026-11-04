# Darkdog 接入说明

本包 `wf_vanilla_extend` 已注册 `darkdog.vehicle`。重启 RWR、进入本包战役，在聊天框输入 `/darkdog`，在输入者附近生成同阵营 Darkdog。载具设为阵营专用，可由同阵营 AI 使用。当前为指令生成，未设置普通阵营刷车或支援呼叫。

## 炮塔与乘员

两座可见炮塔的**总射界均为 140°，即中线左右各 70°**。1 号中线朝车头，2 号中线朝车尾。六个武器位置全部取当前 Blender 工程的空物体，炮管和发射器保持源模型的刚性装配。

| 可见炮塔 | 游戏 turret 索引 | 武器 | 源空物体 |
| --- | --- | --- | --- |
| 1 号，前向 | 0 | 主炮 | `maincannon` |
| 1 号，前向 | 2 | 20 mm 炮 | `20mm` |
| 1 号，前向 | 3、4 | 两侧导弹发射器 | `missile`、`missile.001` |
| 2 号，后向 | 1 | Minigun | `minigun` |
| 2 号，后向 | 5 | Hive 火箭巢 | `hive` |

驾驶员、1 号炮手、2 号炮手共三个隐藏席位。驾驶员可独自驾驶；每名炮手控制所属炮塔的整组武器，分别按各自射速触发。武器不是自动无人炮塔，也没有新增切换武器的操作键。

可见炮塔占据连续索引 0、1。其余发射位使用 `parent_turret_index`、零局部转角/转速，固定在所属炮塔上，避免各自转动后脱离模型。2 号模型先转回前向局部坐标，再由配置旋转 180°；子武器使用同一局部空间。

## 机动 Boss 调校

根据初版实机反馈调整底盘和火力，以 vanilla `darkcat.vehicle` 的 40 血量为耐久基准，增强机动和单主炮火力。所有调整只作用于 Darkdog 的独立配置。

| 项目 | 当前配置 |
| --- | --- |
| 车体 | 40 血量，前进上限 16、加速度 15、倒车 10，正血量可驾驶 |
| 主炮 | 2.5 秒/发，弹速 80，精度 0.85、视距系数 1.2；沿用 `wf_base/tank_cannon_3.projectile` |
| 20 mm | 0.25 秒/发；APC 弹体，局部覆盖爆炸半径 1.2、伤害 0.30 |
| 左右导弹 | 每侧 1.6 秒/发，弹速 28；`bmp3_missile.projectile` 的局部重力改为 0.4 |
| Minigun | 0.04 秒/发；沿用现有 Vulcan 弹体和过热配置 |
| Hive | 每 0.6 秒双发曲射，参考 Patrol ship 的过热/冷却节奏；弹速参数 32，弹道速度上限 40，曲线高度参数 6；`rocket2.projectile` 的局部重力 12、爆炸半径 3、单发伤害 0.6 |

侧导弹原弹速为 55、周期与主炮同为 4 秒；现在弹速约减半，以 1.6 秒节奏穿插主炮的 2.5 秒节奏。重力由父弹体的 1.5 降为 0.4，按速度平方比例补偿，保持相同距离上的弹道下坠量接近初版。

Hive 参考的是 vanilla `patrol_ship_mortar.weapon`：采用 `mortar` 标签、`ballistics`、`rocket2.projectile` 和发射音效。原参考的速度上限为 80、火箭重力为 20；Darkdog 降为 40 / 12，并显式设置较低的 `curve_height=6`，形成低弧度、慢速双发火箭雨。参考文件的当前生效弹道未显式指定高度，注释里的 15 只是示例，不作为当前默认高度。Hive 的 0.6 秒周期受过热冷却限制，不代表无限持续齐射；实际飞行速度和弹道受目标距离与引擎解算影响。

全部武器使用现有音效和粒子。损毁时保留同一装配模型/贴图并显示烟火粒子，目前没有独立焦黑贴图或变形残骸。

### 底盘参考与改动

vanilla `legion.vehicle` 的碰撞尺寸为 `4.4 × 2.5 × 9.2`，接近 Darkdog 的 `4.817 × 2.418 × 9.018`；因此选它作为悬挂布局和物理框参考。初版 `physics.extent` 近似用了整车外形尺寸，且只有前后两组轮组。这是本轮优先调整的配置差异，尚不能仅凭静态文件认定为抖动的唯一原因。

| 参数 | 初版 | 本轮 |
| --- | --- | --- |
| `tire_set` 的 Z 位置 | 3.1、−3.7 | 3.0、−0.18、−3.36，前中后三组 |
| `physics.extent` | `4.86 0 9.34` | `3.8 0 6.8`，围绕履带支撑布局 |
| `physics.offset` | `0 0 0` | `0 0 -0.18`，对齐轮组中点 |
| `top_offset` | `0 3.52 0` | `0 2.0 0`，采用 Legion 的顶部物理参考高度 |
| 质量 | 500 | 1200，与 Legion 一致 |
| `simulated_speed_factor` | 未显式设置 | 0.5，沿用 Legion 的配置 |
| `steer_smoothening` | 0.99 | 0.98，与 vanilla 常见履带车一致 |
| 前进 / 加速度 / 倒车 | 12 / 12 / 8 | 16 / 15 / 10 |

轮组横向偏移 1.75、半径 0.63，原模型碰撞箱和 `visual_offset` 保持。`physics.extent`、`top_offset` 是物理配置，不能当作渲染包围盒或直接称为重心。没有添加未在本机配置中找到依据的弹簧/阻尼字段。

vanilla DarkCat 的前进 / 加速度 / 倒车为 10 / 12 / 8；`tank2.vehicle` 和 `wf_base/darkcat_2.vehicle` 的前进上限为 12。本轮 Darkdog 的速度上限 16 高于这些参考，耐久维持同级。

## 模型来源与导出

- 源文件：`C:\Users\11447\Desktop\wkp\darkdog_wf_v2_assets\darkdog_wf_textured_v2.blend`。
- 本次源 SHA-256：`390ab793fbf1a109eb3ab17f9b574effb7e1720e94e844f7691c0e3e5f136123`。资产包原 manifest 描述旧版本，当前添加挂点后的文件以此哈希为准。
- 保留源文件，未保存修改。忽略隐藏参考对象 `material`、`material.001`；`collishion` 仅用于碰撞箱。
- Blender `(x,y,z)` 转游戏 `(x,z,-y)`，比例 1:1。UV 转为 `(u,1-v)`。
- 车体、炮塔使用 `UV_WF` 和提供的 `darkdog_wf_v2.png`；履带、车轮使用 `UVMap` 和 vanilla 的 AAV7 纹理，分别绑定滚动与旋转动画。
- 源行走机构只有正 X 一侧，另一侧通过 X 镜像导出，修正法线和面绕序。
- 导出 7 个 OGRE v1.41 网格。清理车体 2 个、2 号炮塔 8 个零面积三角形；最终三角形数为 804 / 462 / 316 / 80 / 80 / 112 / 112。
- 碰撞箱中心 `0 1.143257 0.098557`，完整尺寸 `4.816670 2.418247 9.018196`。共同 `visual_offset` 为 `0 0.6 0`。

核心配置：[载具](../vehicles/darkdog.vehicle)、[武器注册](../weapons/invasion_all_weapons.xml)、[生成指令](../scripts/trackers/darkdog_command_handler.as)。指令通过本包 `GameModeInvasion` 注册，单机 `GameModeCampaign` 继承该入口，其余原有聊天指令交回基础处理器。

## 验证

已完成 XML、资源注册、父弹体、模型、纹理和声音引用检查；7 个 mesh 经独立 OgreXMLConverter 回读，核对顶点、三角形、法线与 UV。由实际 `.vehicle` / `.mesh` 重组后的最大位置误差约 `1.23e-6` 游戏单位，炮口与空物体最大误差约 `1.14e-6`。同时检查 ±70°、±35° 和 0° 的子发射位刚性跟随。

预览读取实际游戏文件生成：[前视](darkdog_assembled.png)、[后视](darkdog_rear.png)、[射界边缘](darkdog_arcs.png)。导出和校验详情见 [导出报告](darkdog_export_report.json)、[验证报告](darkdog_verification.json)、[源检查](darkdog_source_inspection.json)。

本轮尚未在 RWR 中复测；静态检查不能证明悬挂抖动已经消除。重启游戏后用 `/darkdog` 新生成载具，检查：

1. 平地启停、前进倒退、连续转弯和斜坡/路沿上的俯仰、侧倾、弹跳，以及两侧履带/车轮动画、上下车位置和碰撞。
2. 两个炮手席位分别控制对应武器组；1 号前向、2 号后向，左右各 70°。
3. 主炮 2.5 秒与侧导弹 1.6 秒的不同节奏、侧导弹降速后的命中；Hive 近中远距离的低弧度火箭雨、过热冷却、落点与 AI 操作。
4. 低血量操控、损毁粒子、同阵营使用限制。

## 重建

以下脚本仅写本包，读取源模型与本机既有转换器。导出会更新网格和导出报告；调整源模型的支点或空物体后，需要同步更新 `.vehicle`，验证脚本会检查两者一致性。

```powershell
$darkdogBlender = 'D:\PLAY\Steam\steamapps\common\Blender\blender.exe'
$darkdogSource = 'C:\Users\11447\Desktop\wkp\darkdog_wf_v2_assets\darkdog_wf_textured_v2.blend'
$darkdogConverter = 'C:\Users\11447\Desktop\wkp\sizeref'
& $darkdogBlender --background --disable-autoexec --python tools/inspect_darkdog.py -- $darkdogSource
& $darkdogBlender --background --disable-autoexec --python tools/export_darkdog.py -- $darkdogSource $darkdogConverter
& $darkdogBlender --background --disable-autoexec --python tools/verify_darkdog.py -- $darkdogConverter
# 仅检查配置与资源，不重新渲染：
& $darkdogBlender --background --disable-autoexec --python tools/verify_darkdog.py -- $darkdogConverter --skip-render
```
