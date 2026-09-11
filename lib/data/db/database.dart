import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../core/models/enums.dart';
import 'tables.dart';

part 'database.g.dart';

/// 离线追溯数据库（Drift / SQLite）。
@DriftDatabase(tables: [
  Vats,
  ProcessVersions,
  ActionEvents,
  WheyTanks,
  WheyTransfers,
  MoldBatches,
  Molds,
  MoldTurns,
  LabSamples,
  CurdPhotos,
])
class CheeseTraceDatabase extends _$CheeseTraceDatabase {
  /// 生产入口：应用文档目录下的 SQLite 文件。
  CheeseTraceDatabase()
      : super(driftDatabase(
          name: 'cheese_trace',
          native: const DriftNativeOptions(),
        ));

  /// 测试入口：内存数据库。
  CheeseTraceDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v2：翻模轮次表 + 模具裂件分件链。
            await m.createTable(moldTurns);
            await m.addColumn(molds, molds.splitFromMoldId);
            await m.addColumn(molds, molds.splitAt);
          }
        },
      );
}
