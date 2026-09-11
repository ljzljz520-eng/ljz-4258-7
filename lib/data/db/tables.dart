import 'package:drift/drift.dart';

import '../../core/models/enums.dart';

/// 奶槽（离线保存，二维码绑定）。
class Vats extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  TextColumn get qrCode => text().unique()();
  TextColumn get milkBatch => text().nullable()();
  DateTimeColumn get startedAt => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

/// 制酪师冻结的工艺版本（含工步顺序与容差快照，JSON 存储）。
class ProcessVersions extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get frozenBy => text()();
  DateTimeColumn get frozenAt => dateTime()();
  TextColumn get stepOrderJson => text()();
  TextColumn get tolerancesJson => text()();
  @override
  Set<Column> get primaryKey => {id};
}

/// 操作员已实施动作（手工动作的可追溯时点）。
class ActionEvents extends Table {
  TextColumn get id => text()();
  TextColumn get vatId => text().references(Vats, #id)();
  IntColumn get step => intEnum<StepKind>()();
  DateTimeColumn get performedAt => dateTime()();
  TextColumn get operatorId => text()();
  TextColumn get processVersionId =>
      text().references(ProcessVersions, #id)();
  RealColumn get temperatureC => real().nullable()();
  IntColumn get visualState => intEnum<VisualState>().nullable()();
  RealColumn get cutSizeMm => real().nullable()();
  IntColumn get zone => intEnum<VatZone>().nullable()();
  TextColumn get note => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

/// 乳清罐。
class WheyTanks extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  TextColumn get qrCode => text().unique()();
  @override
  Set<Column> get primaryKey => {id};
}

/// 乳清去向：奶槽 → 乳清罐。
class WheyTransfers extends Table {
  TextColumn get id => text()();
  TextColumn get vatId => text().references(Vats, #id)();
  TextColumn get tankId => text().references(WheyTanks, #id)();
  DateTimeColumn get transferredAt => dateTime()();
  RealColumn get amountL => real().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

/// 模具批。
class MoldBatches extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  TextColumn get vatId => text().references(Vats, #id)();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

/// 单个模具记录（含换模链）。
class Molds extends Table {
  TextColumn get id => text()();
  TextColumn get batchId => text().references(MoldBatches, #id)();
  TextColumn get vatId => text().references(Vats, #id)();
  TextColumn get qrCode => text().unique()();
  RealColumn get weightG => real().nullable()();
  DateTimeColumn get moldedAt => dateTime().nullable()();
  DateTimeColumn get pressedAt => dateTime().nullable()();
  TextColumn get remoldedFromId => text().nullable()();
  DateTimeColumn get remoldedAt => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

/// 实验室样品（水分/酸度）。
class LabSamples extends Table {
  TextColumn get id => text()();
  TextColumn get vatId => text().references(Vats, #id)();
  TextColumn get moldId => text().nullable()();
  IntColumn get step => intEnum<StepKind>()();
  DateTimeColumn get sampledAt => dateTime()();
  DateTimeColumn get receivedAt => dateTime().nullable()();
  RealColumn get moisturePct => real().nullable()();
  RealColumn get acidityPh => real().nullable()();
  TextColumn get labId => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

/// 标准背景下的凝乳粒照片。
class CurdPhotos extends Table {
  TextColumn get id => text()();
  TextColumn get vatId => text().references(Vats, #id)();
  IntColumn get zone => intEnum<VatZone>()();
  DateTimeColumn get takenAt => dateTime()();
  TextColumn get filePath => text()();
  BoolColumn get standardBackground => boolean()();
  RealColumn get grainSizeMm => real().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}
