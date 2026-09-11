# 奶酪制作追溯系统（cheese_trace）

覆盖凝乳 → 切割 → 搅拌 → 排乳清 → 入模 → 压制全过程的**追溯与一致性检查**系统。
系统只记录与校验，**不产出任何制作配方或设备参数**；所有阈值均由制酪师在
冻结工艺版本时录入，系统仅据此比对。

## 架构

```
lib/
├── core/                     # 纯 Dart 领域层（无 Flutter 依赖，可独立测试）
│   ├── models/               # 动作事件、冻结版本、乳清去向、模具、样品、照片、检查发现
│   └── rules/                # 工位规则引擎（纯函数：TraceContext → List<Finding>）
│       ├── sequence_rule.dart    # 顺序：切割晚按 / 跳步 / 重复
│       ├── grain_zone_rule.dart  # 槽内位置粒度差（槽底凝乳粒较大）
│       ├── whey_merge_rule.dart  # 乳清罐混批
│       ├── mold_split_rule.dart  # 模具批内重量不平
│       ├── remold_rule.dart      # 压制后换模
│       ├── sample_delay_rule.dart# 实验室样品时延与工步关联
│       └── turn_rule.dart        # 翻模轮次：漏翻/补录/交换/标签/裂件/压板
├── data/
│   ├── db/                   # Drift 离线库：奶槽/工步/模具/乳清罐/样品/照片（SQLite）
│   └── trace_repository.dart # 读写 + 规则检查入口
└── ui/                       # Flutter 界面
    ├── timeline/             # 凝乳时间轴（工步按钮弹观测录入：温度/目视/位置/切块/备注）
    ├── split/                # 模具拆分（逐模称重、实时离散度对照容差）
    ├── scan/                 # 二维码扫描（凝乳槽 / 乳清罐 / 模具，扫码后形成实际关联）
    ├── whey/                 # 乳清转移记录（奶槽 → 乳清罐去向）
    ├── lab/                  # 实验室样品录入（水分/酸度，按工步关联）
    ├── mold/                 # 换模记录（新模具挂接原模具链）
    ├── turn/                 # 翻模记录（轮次/位置/实际时刻/破损观察/压板）
    └── photo/                # 相机拍照（标准背景参考框 + 槽内位置）
```

## 关键设计

- **可追溯时点**：操作员按下工步按钮的时刻即 `performedAt`，落库不可改；
  所有动作挂在制酪师冻结的工艺版本之下，事后按当时版本复核。
- **二维码关联**：`Vats.qrCode` / `WheyTanks.qrCode` / `Molds.qrCode` 唯一，
  扫码页依次解析三类对象；扫码结果在主页形成实际关联——
  奶槽 → 打开其时间轴，乳清罐 → 记录乳清去向（预选该罐），
  模具 → 展示详情并可跳转换模。
- **离线优先**：Drift(SQLite) 本地存储，无网络依赖。
- **翻模轮次**：每次翻面记录模具、位置、实际时刻（`turnedAt`）与落库时刻
  （`recordedAt`），两者分离使夜班补录可识别；破损观察含「标签被遮住」
  与「裂成两件」——裂件可在保存翻模的同事务中登记第二件模具
  （`Molds.splitFromMoldId` 挂接原模）。漏翻只标记该单模进入人工处置，
  不影响其他模具的记录与判定。
- **影响水分的因素全部留痕**：切块尺寸（`cutSizeMm`）、槽内位置（`VatZone`）、
  乳清去向（`WheyTransfers`）、模具批（`MoldBatches`/`Molds`），
  实验室水分/酸度（`LabSamples`）按工步关联回动作记录。

## 规则与测试场景对应

| 场景 | 规则 | 发现码 | 级别 |
|---|---|---|---|
| 切割按钮晚按 | SequenceRule | `SEQ_OUT_OF_ORDER` | 违规 |
| 槽底凝乳粒较大 | GrainZoneRule | `GRAIN_ZONE_UNEVEN` | 警告 |
| 乳清罐混批 | WheyMergeRule | `WHEY_TANK_MIXED` | 警告 |
| 多个模具重量不平 | MoldSplitRule | `MOLD_WEIGHT_UNEVEN` | 警告 |
| 压制后产品换模 | RemoldRule | `REMOLD_AFTER_PRESS` | 违规 |
| 样品时延/孤儿样品 | SampleDelayRule | `LAB_SAMPLE_DELAYED` / `LAB_SAMPLE_ORPHAN` | 警告 |
| 漏翻（单模独立人工处置） | TurnRule | `TURN_MISSED` | 警告 |
| 夜班补录 | TurnRule | `TURN_LATE_RECORD` | 警告 |
| 两模内容交换 | TurnRule | `TURN_CONTENT_SWAP` | 警告 |
| 翻模时标签遮住 | TurnRule | `TURN_LABEL_COVERED` | 警告 |
| 裂成两件未登记/已登记 | TurnRule | `TURN_SPLIT_PENDING` / `TURN_SPLIT_REGISTERED` | 警告/提示 |
| 翻模后改用不同压板 | TurnRule | `TURN_PLATE_CHANGED` | 提示 |

## 开发

```bash
flutter pub get
dart run build_runner build   # 重新生成 Drift 代码
flutter analyze
flutter test                  # 50 项测试：规则 29 + 数据库 4 + UI 17
```

注：`test/` 中 Drift 使用 `NativeDatabase.memory()`；widget 测试里
Drift 的真实异步操作需包在 `tester.runAsync` 中（FakeAsync 区限制）。
