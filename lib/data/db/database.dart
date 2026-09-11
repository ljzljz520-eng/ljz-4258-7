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
  int get schemaVersion => 1;
}
