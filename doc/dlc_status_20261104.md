# Whitefang DLC 完成度盘点（2026-11-04）

- **范围**：wf_base、wf_campaign、wf_vanilla_extend、wf_survival、wf_mww、rwrme。
- **方法**：只读代码、文档和 git 历史，以 2026-11-04 fetch 到的各仓库远端默认分支为准；wf_campaign 额外看了 `level-select` 分支。**没有运行游戏**，百分比都是估计。
- **wf_mww 未覆盖**：本地没有克隆，TerranConfederacy 账号在 GitHub 上也看不到这个仓库。wf_base 的 map27（提交信息写着 "mvw"）应该就是它的地图。
- 文中路径都相对于 `media/packages/`。

## 总览

| 包 | 内容 | 估计 | 主要缺口 |
|---|---|---|---|
| wf_base | 共享地图、阵营、武器载具、tracker | ~85% | map27 还在 WIP；map25/26/27 缺地图名；有占位表和杂文件 |
| wf_campaign | 白牙战役 6 关 | ~65%（按两条线合并后算） | **main 和 level-select 已分叉**；多项待实测 |
| wf_survival | 生存模式 | ~80–85% | 美术、部分翻译、刷兵点和部署高度；分支没合 |
| wf_vanilla_extend | Vanilla 2025 战役 | ~65% | 从没编译或实测过；路线 bug；品牌是占位 |
| wf_mww | man vs world | — | 无法访问 |
| rwrme | 地图编辑器 | 基本完成 | 只支持单模式地图 |

**整体约 70%。** 内容基本做出来了，剩下的主要是三件事：分支合并、实机验证、发布前收尾。

---

## 1. wf_campaign

### 1.1 分支分叉（最优先）

两条线的共同祖先是 `d6c4629`（09-06），之后各自开发：

| 分支 | 作者 / 最后提交 | 只有这条线有的内容 |
|---|---|---|
| `origin/main` | squ4re / 10-30 | Exoranger 关、Landship boss、对白重写（cn 约 330 行，偏讽刺风格；en 没改）、中文字体 |
| `origin/level-select`（`test-dist` 与它相同） | TerranConfederacy / 10-03 | CBRN corps、Brown Fire（TroX-80 喷火坦克）、存档、选关菜单 |

两边各有 120 多个文件是对方没有的。**两边都改过的文件有 15 个**：

- `languages/{cn,en}/default_shared.character`、`languages/{cn,en}/journal.xml`、`languages/{cn,en}/package_ui.xml`（en 两边都是新增，属于 add/add）、`languages/cn/misc_text_wf.xml`
- `package_config.xml`、`wf_corps_intros.xml`
- `scripts/gamemode_invasion.as`、`scripts/map_rotator_invasion.as`、`scripts/stage_configurator_invasion.as`、`scripts/start_campaign.as`
- `vehicles/invasion_all_vehicles.xml`、`weapons/all_weapons.xml`

文本冲突最大的是 cn `default_shared.character`（main +321/−371，level-select +48/−1）和 `stage_configurator_invasion.as`。

**合并时要重点盯的语义冲突**：这几处 git 可能合得进去，但合完行为是错的。

1. **阵营配置索引 `[16]`**：level-select 放的是 `brown_fire.xml`，main 放的是 `white_exoranger.xml`。
2. **选关做了两套**：
   - level-select：`UserSettingsWf` + `applyStartStage`，index 5 是 "Level XX: CBRN test"。
   - main：`start_campaign` 把 index 传给 `GameModeInvasion(settings, idx)` → `setStartingStage`，index 5 是 Exoranger，但菜单文字还写着 "Specialist – Lotus Harbor"。
3. **Darkcat 跳过逻辑**：level-select 用 `m_noDarkcatMaps`，main 判断 `m_id != "exoranger"`。
4. **Specialist 关**：地图和敌方阵营两边不一样，见 1.2。
5. **存档只在 level-select 上有**：
   - main 的 `save()`/`load()` 是空函数（`scripts/gamemode_invasion.as:644-650`）。
   - main 没有 `scripts/start_local_tester.as`，但 `package_config.xml` 的 `quick_match_entry_script` 引用了它。
   - main 的 Exoranger 用普通 `addTracker` 注册 `StageCorpsJournal`，合并后这一关不会被存档。
6. **字体**：main 的字体覆盖（9 个 fontdef，2134 个字形）里，没有 level-select 中文文本用到的 15 个字：傻割含呜嗬噜屡患晃曲灯牧瘤腿赔，大多出现在 `default_shared.character`。另外，本地 vanilla 的 fontdef 约有 2.46 万字形，main 的覆盖会让可显示的字少很多。

**TerranConfederacy 本地还有未提交的改动**：13 个修改 + 5 个未跟踪文件。

- `start_campaign.as`：initialRp 从 10000 改成 30000。
- `map_rotator_invasion.as` include 了还没被跟踪的 `scripts/trackers/loss_restart_rp_topup.as`，**这两个文件必须一起提交**。
- `bio_beacon_drop.call`、`flare_bio_drop.projectile` 还没被跟踪。
- Specialist 人数倍率：友军 1.0→1.3，Brown Fire 1.4→1.2；旁边的注释还写着 +15%。
- 另有 TroX-80 喷火器军衔门槛修复、控制装置模型、注射枪 HUD 贴图。

### 1.2 各关

关卡顺序以 `scripts/stage_configurator_invasion.as` 里的 `setupNormalStages()` 为准。

| 关 | 地图 | 在哪条线 | 估计 | 未完成 |
|---|---|---|---|---|
| Lonewolf | map20 Elk Island | 两边都有 | ~85% | 旧打磨记录里有"异常过图事件"，没看到修复记录 |
| Guardian | map10 Railroad Gap | 两边都有 | ~75% | 能玩，但没有这个 corps 的专属脚本，内容偏薄 |
| Specialist / CBRN | level-select：map19 Swan River，敌方 Brown Fire `[16]`；main：map26 Lotus Harbor，敌方 blue_fire `[15]` | 两边不同 | level-select ~75% / main ~45% | 见下 |
| Operator | map21 Road 666 | 两边都有 | ~75% | 见下 |
| Commander | map13 Iron Enclave | 两边都有 | ~85% | 旧记录"小队护甲包 奇异BUG"还没解决 |
| Exoranger | map18（`m_id="exoranger"`，敌方强制 Blue） | 只在 main | ~50% | 见下 |

**Specialist / CBRN 未完成项：**

- `factions/cbrn_gunner.resources:4` 里 `hk21e` 被注释掉了。
- `cbrn_horde.call` 标着 "NOT YET WIRED"。
- 地面生成的弹体把 faction_id 写死成 0。
- `/cbrn` 调试命令还在（`scripts/trackers/basic_command_handler.as:179`）。
- 控制装置和注射枪都标着"尚未实测"。
- `doc/cbrn_units_status.md` 过时了：精英兵现在用 `cbrn_elite_sabre`，不是 g41。

**Operator 未完成项：**

- `doc/operator_corps_status.md` 里有 4 项"待实测"。
- 4 个 call 用的是占位 HUD 图标：`wf_01_drop.call`、`meerkat_drop.call`、`boxer_missile_drop.call`、`pika_minig_drop.call`。
- `soldier_operator_white(_alt).xml` 还没接上。
- 设计备忘里的短枪、加快复活、Union 敌方都没做。

**Exoranger 未完成项：**

- 阵营和装备（`white_exoranger.xml`、`player_exoranger.resources`）是从 Ranger 复制来的占位。
- Landship 的生成、AI 乘员、音效、图标、残骸都是"待验证"（main 上的 `doc/exoranger_landship_spawn.md`、`doc/landship_*.md`）。
- 胜利条件还是占领。中英文对白也对不上：cn 第三段说"摧毁特种车辆"，en 说 "Clear the sector"。

### 1.3 其他

- **本地化**：两条线上的 en/cn key 集合基本一致，只差几个 vanilla 遗留 key。level-select 的 en `package_ui.xml` 缺 "Whitefang campaign description"。
- **成就**：`achievements.xml` 没改过。`wf_corps_intros.xml` 两边各加了一条：`wf_cbrn_undead_control`（level-select）和 `wf_corps_exoranger`（main）。

---

## 2. wf_base

origin/master 在 `f32c320`（10-30）。

**地图**（`maps/` 下 21 个）
- 每张图都有 `objects.svg`、`map_config.xml`、heightmap、splat 和 `map.png`。
- 没有 `terrain.cfg` 的：DLC_lobby、MapForTest、map11、map23、map24、map25、map26。老图也有缺这个文件、用引擎默认值的先例，需要确认这几张是不是有意为之。
- 09-06 导入之后只有 map22、map23、map27、DLC_lobby 改过。
- **map27 是 WIP**：版本号到 v0.99.2 → "mvw update"。bat 是从 map6 复制来的（`process_map6.bat`），svg 导出路径指向 vanilla map10。本地任何包都没引用它，估计是 wf_mww 在用。
- `languages/cn/map_names.txt` 只写到 map24，**map25 Tortuous Cross、map26 Lotus Harbor、map27 都缺名字**。另外这个文件不是标准 XML，部分 key 和脚本里的大小写、写法对不上（如 "Flooded town"、"White Shore"）。
- `maps/map13_campaign` 的 `map.png` 和 heightmap 与 map13 完全相同。

**资产**
- 阵营：Greenbelts、Graycollars、Brownpants、Blueboots、Whitefangs，以及 blue_boss、white_boss、infected、partisans、insurgents。`all_factions.xml` 只列了前四个，没有 white。
- 数量：164 个 `.weapon`、87 个 `.projectile`、96 个 `.vehicle`、18 个 `.call`、27 个 carry item。注册表里的每一项都能找到对应文件。
- 占位或 TODO：
  - `vehicles/airdrop_supply_crates.xml` 有 5 处 "TODO(balance)"。
  - `scripts/trackers/faction_requisition.as` 的卡牌表是 "TEST placeholders for the MVP trial"，只在 map22 注册。
  - `agent_manager_campaign.as:26`：按阵营区分 VIP 还没做。
  - `phase_controller_map24.as:19`：指挥官台词还没加。
- 杂文件：`textures/hud_flare_lavender - 副本.png`、`maps/map22/log.xml`（ImageMagick 配置）、`factions/steyr_tmp_ai.weapon`（和 `weapons/` 下那份内容不同）、`vehicles/leclerc_mg.weapon`、`weapons/weather_storm_spawn.vehicle`。MapForTest 也被打包了。

**本地化**
- `default_shared.character`：en 有、cn 缺的 key 有 2 个，其中 "map5_2, suffering too many casualties" 被 `target_manager_map5_2.as:182` 用到。
- `misc_text_bb.xml`：cn 有 51 个 key，en 只有 9 个，英文会直接显示 key。cn 第 238–240 行有空的 `key=""`。

**分支**：`pick/balancebundle-map24`（KF redfox 副阵营武器和载具贴图，5 个提交）和 master 没有改到同一个文件，可以干净合并。合并前先修一处：`weapons/rpk_74.weapon` 引用的 `rpk_74_shot.wav` 被提交到了 `models/`，没放进 `sounds/`。

---

## 3. wf_vanilla_extend

**战役结构**（`scripts/gamemodes/campaign/stage_configurator_campaign.as`）
- 普通关：map15_campaign、map14、map8（和平 hub）、map21、map16、map18、map13_campaign、map22、map17。
- 终局链：map23 → map13_2 → map8_2 → map5_2 → map24。map8_2 和 map5_2 来自 vanilla.winter。
- 没用到的地图：map25/26/27。

**路线 bug**
- `world_init.as:22` 和 `stage_configurator_campaign.as:1421` 把 region 1 写成了 `map22`，按坐标应该是 map23。结果 map22 有两个 region，map23 一个都没有。
- 撤离 hitbox 缺失：`map15_campaign`、`map8` 没有 `hitbox_extraction23`；`vanilla.winter/maps/map8_2` 没有 `hitbox_extraction52`，所以 map8_2 → map5_2 走不通。
- `setupTransportsTo23()` 是空函数。
- `commitToMapChange` 把关卡索引 7、9 写死了。
- 代码里还有 `//UNDONE`、`//checkHere`、"we ll do this latter" 等标记。

**没验证过的内容**
- secondary factions：`doc/secondary_factions.md:104` 写着"本次未运行 AngelScript 编译或游戏实测"。
- darkdog：
  - `doc/darkdog.md` 只做了导出和静态检查，"本轮尚未在 RWR 中复测"，地图图标也还待游戏内确认。
  - 只能通过 `/darkdog` 命令生成（`scripts/trackers/darkdog_command_handler.as`），这个命令**没有任何权限检查**。
  - map24 给 Whitefang 开了这个资源，但图上没有对应的出生 tag。
  - 文档和工具里写死了其他机器的路径（`C:\Users\11447`、`D:\PLAY`）。
- map22 上挂着 `TRIAL` 版的 commander、agent、requisition tracker，以及上面提到的 TEST 卡牌表。

**`TODO.txt` 各项**

| 项 | 状态 |
|---|---|
| 字库缺字情况 | 未开始，本包没有字体相关工作 |
| 加载信息提示 | 未开始 |
| 3图进路线 | 大部分完成（`freemodeMapCount=3` 会解锁 map23 出口），但卡在上面说的缺失 hitbox |
| 指示板轴向 | 没找到相关改动 |
| 地图资产杂化 | 本包没有相关改动，如果有应该在 wf_base 里 |

**品牌和本地化**
- 包名 "Vanilla 2025 campaign" 以及描述、预览图，都和 `balanceBundle/package_config.xml` 完全一样，战役菜单里会出现两个同名条目。
- `campaign_blue_preview.png` 是一张通用的 DLC 横幅，上面没有战役标题。
- `package_config.xml` 请求的描述 key 是 "Campaign description 2025"，en 文件里写的却是 "Campaign 2025 description"，所以英文会显示 key 原文。cn 是对的。
- "new weapon unlocked" 这条公告 en 和 cn 都没有。

---

## 4. wf_survival

**现状**
- 入口是 `scripts/start_survival.as`。有两个预设：任务模式（20 波）和无尽模式。
- 阵营：Union 守、Whitefang 攻。
- 地图池 8 张，按日期哈希选图，其中包括 wf_base 的 map25。
- 波次、Boss（第 10 波 DarkCat，最后一波 DarkCat II）、7 个修饰器、10 种奖励都已经做完。
- 19 个 tracker 里没有 TODO 或 FIXME。en 和 cn 的 key 完全一致。

**`TODOS.md` 各项**

| 项 | 状态 |
|---|---|
| 降低三甲权重 | `wave_rewards.as:147` 里 ArmorCacheReward 的权重已经是 1，是否还要再降待定 |
| 地图细化安排 | 本次没有评估 |
| 部署高度 | 未完成，目前只有固定偏移 `SPAWN_VEHICLE_HEIGHT_OFFSET = 10.0`（`spawn_vehicle_resolver.as:19`），不检测地形和屋顶 |
| 资产排除 | 未完成，`rwr_game (6).log`（2MB）被提交进了仓库 |
| 图片资产替换 / splash 图 | 未完成，`textures/splash.png` 和 wf_base 的 `splash_cd.png` 是同一张图，预览图也来自 wf_base |
| 白军刷兵位置 | 未完成，目前是基地中心 ±10m（`wave_manager.as:364-369`），没用 generic_node |

**其他问题**
- 菜单描述（`languages/en/package_ui.xml`）还写着 "Hold Iron Enclave"，已经和地图池对不上了。
- 这些名称没有任何翻译：hull down、restore tank、deploy tnt、Engineering 系列无线电文本、TNT、AI trauma plate、Hornet 360、field toolkit、bodyguard summoner、elf's gift grenade。

**分支**
- `vehicle_feat` 领先 main 4 个提交，可以快进合并。
- `map25_test` **不要合**：它把地图池锁成了只有 map25，测完删掉即可。
- `test_dist` 已经过时，还依赖 balanceBundle。
- `weapons/inf_tnt.projectile` 有一行改动没提交（`use_time_to_live="0"`）。

---

## 5. rwrme

- README 写的是："基本功能（被认为）全部完成，接下来做生活质量更新，等待 RWR2"。
- `origin/svglised-png-asset` 比 master 多 4 个提交，包括 10-29 加的 map CLI、协作流程和 Unity MCP 集成。
- 已知限制：layer 只认 `{default}`，所以**只能导入和编辑单模式地图**；按模式或按载具区分出生点 layer 的方案还没做。

---

## 6. 建议顺序

1. **合并 wf_campaign 的两条线**，其他工作都依赖它。合之前要先定下：
   - 阵营索引 `[16]` 给谁；
   - 选关用哪一套；
   - Specialist 用哪张地图、哪个敌方阵营。
   
   合完后把存档补到 Exoranger 上，并补齐字体缺的 15 个字。
2. **处理风险低的分支和未提交改动**：
   - wf_survival：`vehicle_feat` → main，`inf_tnt.projectile` 一起提交。
   - wf_base：先修 `rpk_74_shot.wav` 的位置，再把 `pick/balancebundle-map24` → master。
   - wf_campaign：本地改动提交时，`loss_restart_rp_topup.as` 要和 map_rotator 放在同一个提交里。
3. **修 wf_vanilla_extend 的路线**：region 1、三个缺失的 hitbox、`setupTransportsTo23()`。
4. **集中做一轮实机测试**，按本文所有"待实测 / 待验证"的项逐个过：secondary factions、CBRN 控制装置和注射枪、Operator 的 4 项、Landship、darkdog。
5. **发布前收尾**：
   - 包名、描述和预览图；
   - 地图名补到 map25–27；
   - 英文缺的 key；
   - 关掉 `/darkdog`、`/cbrn` 等调试命令，或加上权限检查；
   - 清理 MapForTest、`副本.png`、`log.xml` 和提交进仓库的日志；
   - map22 的 TEST/TRIAL 内容换成正式版本。
