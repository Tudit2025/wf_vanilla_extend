# wf_vanilla_extend：第二阵营资产

`StageFactionVariant` 在同一个阵营上切换固定武器池和载具池。阵营文件、兵力、模型和外交关系仍由原 stage 定义。

四个基础阵营的武器和载具替换表已配置，单机战役按固定的“地图 × 战役阵营角色”表一起启用换装。三个主要敌军合计一半的战斗出场使用替换资产；玩家阵营接近一半。

| 阵营文件 | 武器替换（均为 `.weapon`） |
| --- | --- |
| `green.xml` | `m16a4` → `c7a1`；`mossberg` → `model_870`；`m240` → `c9a1` |
| `grey.xml`（Gray） | `g36` → `fn_scar`；`imi_negev` → `fn_minimi`；`psg90` → `sr25` |
| `brown.xml` | `qbs-09` → `rmb_93`；`pkm` → `rpk_74`；`dragunov_svd` → `ksvk` |
| `blue.xml` | `nr97a` → `sar_21`；`civet_12` → `usas_12`；`type_97` → `m1500` |

每一对武器只作用于原武器已启用的兵种组，按现有阵营文件及资源继承链明确列出。例如灰军普通 AI 原本禁用 `psg90`，因此不会获得 `sr25`；灰军狙击兵只把 `psg90` 换成 `sr25`，不会额外获得 `fn_scar`、`fn_minimi`。`default`、医护兵、囚犯和 `mrap` 等资源组按同样规则处理。以后若修改基础阵营的武器分配，需要同步检查此处的兵种列表。

`sniper` 是独立兵种，狙击枪替换会显式指定 `soldier_group_name="sniper"`，不依赖普通步兵组传播。绿军狙击手的 M24 A2 没有配置替换，继续使用原枪。`lonewolf` 虽然 `copy_from="sniper"`，但随后加载的 `lonewolf_sniper_*.resources` 使用 `clear_weapons="1"` 重建专用武器池，所以不列入狙击枪替换名单。检查继承链时必须同时处理资源清空标记。

资源沿用目标包已有的 `wf_base` 依赖，其中已注册全部 12 把目标武器，Model 870、FN Minimi 也采用正常默认配装属性。本包的 `weapons/invasion_all_weapons.xml` 先加载原武器总表，再将 C9A1、SR-25 的等级门槛分别设为 0.025、0.2，与被替换的 M240、PSG-90 一致；其余十把沿用依赖中的对应门槛。资源注册和等级覆盖本身不会向阵营授予武器。

| 阵营 | 原载具 | 替换载具 | 出生点 tag |
| --- | --- | --- | --- |
| 绿军 | `apc.vehicle` | ACV 指挥车：`secondary_acv.vehicle` | `apc` |
| 蓝军 | `apc_3.vehicle` | VN：`secondary_vn.vehicle` | `apc` |
| 棕军 | `apc_2.vehicle` | BMP-3：`secondary_bmp3.vehicle` | `apc` |
| 灰军 | `tank_1.vehicle` | 勒克莱尔：`secondary_leclerc.vehicle` | `tank` |
| 灰军 | `tank_1_alt.vehicle` | 勒克莱尔支援版：`secondary_leclerc_alt.vehicle` | `tank_alt` |
| 灰军 | `tank_1_denied_player.vehicle` | 勒克莱尔限制玩家版：`secondary_leclerc_denied_player.vehicle` | `tank_denied_player`、`tank` |

本包的 `vehicles/invasion_all_vehicles.xml` 保留 `all_vehicles.xml` 的原注册，再加载六个专用变体。变体继承 `wf_base` 的模型、武器和属性，并使用独立 key；APC 变体补充 `apc` 标签，普通勒克莱尔补充 `tank` 标签。原 VN 等资源不会被全局添加出生标签，因此未换装阵营的原出生池不受影响。ACV 替换变体显式设置 `allow_ai_to_use="1"`，供 AI 驾驶和操作。

替换车的刷新时间对齐被替换的原车型：ACV、BMP-3、VN 变体显式设置 `respawn_time="80"`、`time_to_live_unsteerable="75"`，分别覆盖原资源的 180／175、180／175、100／56 秒配置。ACV、BMP-3 变体另设 `existence="unlimited"`、`reserves_spawn_point="0"`，解除继承的单阵营一辆限制及出生点预留，按普通 APC 出生规则处理。三个勒克莱尔变体沿用继承的 100／95 秒配置，与原灰军坦克一致。其他车型属性和支援版访问限制沿用原资源。

载具只在原型号实际启用的资源组中替换：绿军为 `default`、`default_ai`、`prisoner`、`mrap`；棕军、蓝军额外包含 `officer`；灰军为 `default`、`default_ai`、`medic`、`prisoner`、`mrap`。独立狙击手等没有这些载具的兵种不获授新车。灰军限制玩家版旧坦克同时带有 `tank` 标签，因此使用 `m_extraSpawnTags` 覆盖普通坦克出生点的首批实例替换。

## 填写固定替换表

在 `scripts/gamemodes/invasion/secondary_faction_profiles.as` 的 `createSecondaryFactionProfile()` 中，为原阵营文件返回一个 profile。一个阵营只维护一套第二形态。逐对替换使用 `m_weaponSwaps`，例如：

```angelscript
profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap(
    "psg90.weapon", "sr25.weapon",
    array<string> = {"default", "medic", "sniper", "prisoner", "mrap"}));
```

载具规则使用 `m_vehicleSwaps`，例如绿军的配置：

```angelscript
profile.m_vehicleGroups = array<string> = {"default", "default_ai", "prisoner", "mrap"};
profile.m_vehicleSwaps.insertLast(FactionVariantVehicleSwap(
    "apc", array<string> = {"apc.vehicle"}, "secondary_acv.vehicle"));
```

- `FactionVariantWeaponSwap` 明确原武器、新武器和作用兵种。`default_ai` 是普通 AI，`default` 通常是玩家组；静态继承了资源的其他兵种也要逐一列出，运行期修改不会由这段脚本自动传播。其余武器和解锁项保留。
- 如果需要统一批量增删，也可使用 `m_weaponGroups` 配合 `m_removeWeapons`、`m_addWeapons`，但同一个 profile 不能再混用 `m_weaponSwaps`。
- `m_vehicleGroups` 指定要调整的载具资源组，默认只有 `default`。
- 每条载具规则写一个主要出生点 tag、一组旧型号和一个新型号。整套规则应覆盖目标出生池中的全部旧型号，新型号必须已经注册并携带对应 tag。脚本按明确的旧 key 列表禁用资源，不会自动发现遗漏型号，也不会动态给新车添加 tag。不同车型和特殊版本分别配置；同一旧车型带多个出生标签时，可填写 `m_extraSpawnTags` 扩展首批实例的出生点检查，资源增删仍只执行该车型的同一条规则。
- 同一兵种的武器替换冲突、同一 tag 重复、旧载具 key 重复，以及替换链／环都会使整个 profile 校验失败。未知资源或不存在的兵种组同样使该阵营整套变更跳过，并写入日志。

## 单机战役的固定分配

`StageConfiguratorCampaign.configureSecondaryFactions()` 管理以下分配：

| 战役配置索引 | 固定换装地图 | 换装次数／战斗出场次数 |
| --- | --- | --- |
| `0`（玩家阵营） | `map14`、`map16`、`map13`、`map17`、`map13_2`、`map5_2` | 6／13 |
| `1`（主要敌军） | `map15`、`map16`、`map8_2` | 3／5 |
| `2`（主要敌军） | `map21`、`map23` | 2／4 |
| `3`（主要敌军） | `map18`、`map22` | 2／5 |

主要敌军合计 7／14（50%），包含玩家阵营后为 13／27（约 48.1%）。统计以当前完整战役中不同战斗地图的阵营出场为单位；重复游玩不计数。奇数次出场的单个阵营只能接近一半。`map8` 和通关后返回的和平场景不换装，也不参与统计。白军、中立和感染者不参与此分配。

表中的索引是 `FactionConfig.m_index`，不是本关槽位，也不固定对应某个颜色。配置器遍历当前关卡，将符合条件的战役角色转换成本关槽位，再按该阵营实际使用的文件选择武器表。例如 `map16` 换装槽位为 `{0, 1}`，`map23` 为 `{2}`。

`MapRotatorCampaign` 在进入地图（含读档）和重开之前重建此关的换装 tracker。读档先恢复阵营配置，再进行绑定，避免使用初始化时临时随机排列所对应的武器表；重建只移除旧的 `StageFactionVariant`，保留其他 tracker。分配无随机抽取、运行期计数或额外存档字段。上述比例针对正常关卡配置；调试命令或旧档若重新分配最终战阵营，则按恢复后的实际角色匹配。

单机战役的自动表统一管理换装，调整时修改此函数；进入地图时会替换手工注册的 `StageFactionVariant`。其他模式仍可通过下面的接口逐关启用。

## 手工在 stage 中启用

invasion 配置器提供 `addSecondaryFactions()`，单机战役的自动表也复用此接口。在其他模式的目标 `setupStage*()` 中，完成 `stage.m_factions` 后可调用：

```angelscript
addSecondaryFactions(stage, array<int> = {1, 2});
```

这里的数字是 `stage.m_factions` 的本局槽位，从 0 开始。辅助函数读取该槽位实际加载的阵营文件，再查固定替换表；基础阵营随机排序不会串用配置。重复选择同一槽位只注册一次。越界槽位、缺失或无效 profile 会单独报错，其余槽位继续处理。最终战按实际加载的阵营文件查表。本包 campaign 模式的最终战仍使用基础阵营文件，因此可以复用对应配置；invasion 模式若改用 boss 文件，则需要另行配置。

## 执行时序与边界

新地图和重开都经过 `getFactionResourceConfigChangeCommands()`：通用设置 → 战役进度设置 → stage 特例 → 第二阵营配置 → `start_game`。第二阵营对自己列出的资源 key 拥有最终优先级；如果地图要求禁用同一资源，应在确定替换表时解决冲突。

切图命令设置 `suppress_default_match="1"`，用于抑制默认对局的提前生成；替换命令在正式 `start_game` 前发送，设计上首批正常出生单位就使用调整后的资源池。tracker 的 `start()` 是补用路径，不是唯一执行入口。若开赛前资源校验失败、仅开赛后补用成功，首批单位仍可能携带旧装备；实际首次生成时序需结合游戏日志验证。

tracker 注册在开赛后，首次 `start()` 再应用相同增删命令，以覆盖继续存档的路径。`onAdd()` 重置临时状态，`gameContinuePreStart()` 标记读档；无需另存“已经执行”标志。旧存档按当前 stage 配置恢复资源池，但不会强制改写已出生士兵的背包。

`m_replaceInitialVehicles` 默认开启：新开局或重开时核对首批旧车，只替换距离目标 tag 出生点不超过 3 米、满血、空载、未锁定、归属及持有关系符合目标阵营的车辆。位置沿用旧车，朝向优先沿用查询结果，缺失时使用出生点朝向。读档跳过全部实例替换，保留战损和乘员。实例替换通过 `remove_vehicle`、`create_instance` 完成。

此 tracker 执行一次即退出，不监听后续载具出生，也不自行安排补车。后续刷新依赖调整后的引擎资源池。首批实例替换后的出生点关联和刷新行为仍需实机验证；可将 `m_replaceInitialVehicles` 设为 `false`，只调整资源池。没有匹配出生点、车辆已受损或有人乘坐时，首批旧车会保留。

## 验证

本次已完成静态校验：六个载具变体的 XML、注册和继承链；替换前后的出生标签候选池；包含 `copy_from`、资源引用和 `clear_vehicles` 的兵种资源池；重复 key 和替换冲突；ACV 的 AI 使用设置；灰军特殊坦克的标签和访问限制；额外出生标签仅参与首批实例修复，以及读档跳过实例替换的调用路径。

本次未运行 AngelScript 编译或游戏实测。静态校验不能验证引擎的实际出生时序、载具数量限制和被毁后的刷新行为。

实机验收应检查：首批 AI 和后续增援的武器；目标 tag 首批与被毁后刷新的车型和数量；同时启用多个阵营；重开；中途保存再读档；切换到未启用变体的关卡。
