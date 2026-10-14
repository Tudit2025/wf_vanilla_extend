# wf_vanilla_extend：第二阵营资产

`StageFactionVariant` 在同一个阵营上切换固定武器池和载具池。阵营文件、兵力、模型和外交关系仍由原 stage 定义。

四个基础阵营的武器替换表已配置。载具替换和目标关卡尚未指定，现有关卡均未启用换装。“一半阵营换装”仍是待实现的战役分配方案，本次迁移只包含已有机制。

| 阵营文件 | 武器替换（均为 `.weapon`） |
| --- | --- |
| `green.xml` | `m16a4` → `c7a1`；`mossberg` → `model_870`；`m240` → `c9a1` |
| `grey.xml`（Gray） | `g36` → `fn_scar`；`imi_negev` → `fn_minimi`；`psg90` → `sr25` |
| `brown.xml` | `qbs-09` → `rmb_93`；`pkm` → `rpk_74`；`dragunov_svd` → `ksvk` |
| `blue.xml` | `nr97a` → `sar_21`；`civet_12` → `usas_12`；`type_97` → `m1500` |

每一对武器只作用于原武器已启用的兵种组，按现有阵营文件及资源继承链明确列出。例如灰军普通 AI 原本禁用 `psg90`，因此不会获得 `sr25`；灰军狙击兵只把 `psg90` 换成 `sr25`，不会额外获得 `fn_scar`、`fn_minimi`。`default`、医护兵、囚犯和 `mrap` 等资源组按同样规则处理。以后若修改基础阵营的武器分配，需要同步检查此处的兵种列表。

资源沿用目标包已有的 `wf_base` 依赖，其中已注册全部 12 把目标武器，Model 870、FN Minimi 也采用正常默认配装属性。本包的 `weapons/invasion_all_weapons.xml` 先加载原武器总表，再将 C9A1、SR-25 的等级门槛分别设为 0.025、0.2，与被替换的 M240、PSG-90 一致；其余十把沿用依赖中的对应门槛。资源注册和等级覆盖本身不会向阵营授予武器。

## 填写固定替换表

在 `scripts/gamemodes/invasion/secondary_faction_profiles.as` 的 `createSecondaryFactionProfile()` 中，为原阵营文件返回一个 profile。一个阵营只维护一套第二形态。逐对替换使用 `m_weaponSwaps`，例如：

```angelscript
profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap(
    "psg90.weapon", "sr25.weapon",
    array<string> = {"default", "medic", "sniper", "prisoner", "lonewolf", "mrap"}));
```

载具规则可以另外追加，以下只演示格式，未写入四个阵营的正式配置：

```angelscript
profile.m_vehicleGroups = array<string> = {"default", "default_ai"};
profile.m_vehicleSwaps.insertLast(FactionVariantVehicleSwap(
    "tank", array<string> = {"tank_3.vehicle"}, "tank_2.vehicle"));
```

- `FactionVariantWeaponSwap` 明确原武器、新武器和作用兵种。`default_ai` 是普通 AI，`default` 通常是玩家组；静态继承了资源的其他兵种也要逐一列出，运行期修改不会由这段脚本自动传播。其余武器和解锁项保留。
- 如果需要统一批量增删，也可使用 `m_weaponGroups` 配合 `m_removeWeapons`、`m_addWeapons`，但同一个 profile 不能再混用 `m_weaponSwaps`。
- `m_vehicleGroups` 指定要调整的载具资源组，默认只有 `default`。
- 每条载具规则写一个出生点 tag、该槽位全部旧型号和一个新型号。新型号必须已经注册，并携带同一 tag。脚本按明确的旧 key 列表禁用资源，不会自动发现遗漏的同 tag 型号，也不会动态给新车添加 tag。`tank_denied_player` 等不同 tag 需要单独配置。
- 同一兵种的武器替换冲突、同一 tag 重复、旧载具 key 重复，以及替换链／环都会使整个 profile 校验失败。未知资源或不存在的兵种组同样使该阵营整套变更跳过，并写入日志。

## 在 stage 中启用

单机战役入口是 `scripts/gamemodes/campaign/stage_configurator_campaign.as`，它继承了 invasion 配置器中的 `addSecondaryFactions()`。在目标 `setupStagewf*()` 或其他 `setupStage*()` 中，完成 `stage.m_factions` 后调用：

```angelscript
addSecondaryFactions(stage, array<int> = {1, 2});
```

这里的数字是 `stage.m_factions` 的本局槽位，从 0 开始。辅助函数读取该槽位实际加载的阵营文件，再查固定替换表；基础阵营随机排序不会串用配置。重复选择同一槽位只注册一次。越界槽位、缺失或无效 profile 会单独报错，其余槽位继续处理。最终战按实际加载的阵营文件查表。本包 campaign 模式的最终战仍使用基础阵营文件，因此可以复用对应配置；invasion 模式若改用 boss 文件，则需要另行配置。

## 执行时序与边界

新地图和重开都经过 `getFactionResourceConfigChangeCommands()`：通用设置 → 战役进度设置 → stage 特例 → 第二阵营配置 → `start_game`。第二阵营对自己列出的资源 key 拥有最终优先级；如果地图要求禁用同一资源，应在确定替换表时解决冲突。

tracker 注册在开赛后，首次 `start()` 再应用相同增删命令，以覆盖继续存档的路径。`onAdd()` 重置临时状态，`gameContinuePreStart()` 标记读档；无需另存“已经执行”标志。旧存档按当前 stage 配置恢复资源池，但不会强制改写已出生士兵的背包。

`m_replaceInitialVehicles` 默认开启：新开局或重开时核对首批旧车，只替换距离目标 tag 出生点不超过 3 米、满血、空载、未锁定、归属及持有关系符合目标阵营的车辆。位置沿用旧车，朝向优先沿用查询结果，缺失时使用出生点朝向。读档跳过全部实例替换，保留战损和乘员。实例替换通过 `remove_vehicle`、`create_instance` 完成。

此 tracker 执行一次即退出，不监听后续载具出生，也不自行安排补车。后续刷新依赖调整后的引擎资源池。首批实例替换后的出生点关联和刷新行为仍需实机验证；可将 `m_replaceInitialVehicles` 设为 `false`，只调整资源池。没有匹配出生点、车辆已受损或有人乘坐时，首批旧车会保留。

## 验证

使用 AngelScript 2.30.2 编译新 tracker、配置表和注册辅助函数，并模拟命令生成、新开局、读档、重开、资源缺失和配置冲突。模拟测试不启动游戏，不能验证引擎的实际载具刷新行为。

实机验收应检查：首批 AI 和后续增援的武器；目标 tag 首批与被毁后刷新的车型和数量；同时启用多个阵营；重开；中途保存再读档；切换到未启用变体的关卡。
