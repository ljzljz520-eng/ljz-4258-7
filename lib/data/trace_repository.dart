import 'package:drift/drift.dart' show Value, OrderingTerm;

import '../core/models/action_event.dart';
import '../core/models/curd_photo.dart';
import '../core/models/finding.dart';
import '../core/models/lab_sample.dart';
import '../core/models/mold.dart';
import '../core/models/process_version.dart';
import '../core/models/whey.dart' as core;
import '../core/rules/rule.dart';
import '../core/rules/rules_engine.dart';
import 'db/database.dart' as db;
import 'db/mappers.dart';

/// 追溯仓库：离线读写 + 规则检查的唯一入口。
class TraceRepository {
  TraceRepository(this._db, {RulesEngine? engine})
      : _engine = engine ?? RulesEngine();

  final db.CheeseTraceDatabase _db;
  final RulesEngine _engine;

  // ---------- 写入 ----------

  Future<void> freezeVersion(ProcessVersion version) =>
      _db.into(_db.processVersions).insert(processVersionToCompanion(version));

  Future<ProcessVersion?> findVersion(String id) async {
    final row = await (_db.select(_db.processVersions)
          ..where((v) => v.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : processVersionFromRow(row);
  }

  Future<List<ProcessVersion>> listVersions() async {
    final rows = await (_db.select(_db.processVersions)
          ..orderBy([(v) => OrderingTerm.desc(v.frozenAt)]))
        .get();
    return rows.map(processVersionFromRow).toList();
  }

  Future<List<db.Vat>> listVats() => _db.select(_db.vats).get();

  Stream<List<db.Vat>> watchVats() => _db.select(_db.vats).watch();

  Future<List<db.WheyTank>> listWheyTanks() => _db.select(_db.wheyTanks).get();

  Future<db.Vat?> findVatByQr(String qrCode) => (_db.select(_db.vats)
        ..where((v) => v.qrCode.equals(qrCode)))
      .getSingleOrNull();

  Future<db.WheyTank?> findTankByQr(String qrCode) =>
      (_db.select(_db.wheyTanks)..where((t) => t.qrCode.equals(qrCode)))
          .getSingleOrNull();

  Future<db.Mold?> findMoldByQr(String qrCode) =>
      (_db.select(_db.molds)..where((m) => m.qrCode.equals(qrCode)))
          .getSingleOrNull();

  Future<void> addVat(String id, String code, String qrCode,
          {String? milkBatch, DateTime? startedAt}) =>
      _db.into(_db.vats).insert(db.VatsCompanion(
            id: Value(id),
            code: Value(code),
            qrCode: Value(qrCode),
            milkBatch: Value(milkBatch),
            startedAt: Value(startedAt),
          ));

  Future<void> addWheyTank(String id, String code, String qrCode) =>
      _db.into(_db.wheyTanks).insert(db.WheyTanksCompanion(
          id: Value(id), code: Value(code), qrCode: Value(qrCode)));

  Future<void> recordAction(ActionEvent event) =>
      _db.into(_db.actionEvents).insert(actionEventToCompanion(event));

  Future<void> recordTransfer(core.WheyTransfer transfer) =>
      _db.into(_db.wheyTransfers).insert(transferToCompanion(transfer));

  Future<void> createMoldBatch(
          String id, String code, String vatId, DateTime createdAt) =>
      _db.into(_db.moldBatches).insert(db.MoldBatchesCompanion(
          id: Value(id),
          code: Value(code),
          vatId: Value(vatId),
          createdAt: Value(createdAt)));

  Future<void> recordMold(MoldRecord mold) =>
      _db.into(_db.molds).insert(moldToCompanion(mold));

  /// 模具拆分事务：创建模具批并一次性写入全部模具。
  Future<void> splitIntoMolds({
    required String batchId,
    required String batchCode,
    required String vatId,
    required DateTime createdAt,
    required List<MoldRecord> molds,
  }) =>
      _db.transaction(() async {
        await createMoldBatch(batchId, batchCode, vatId, createdAt);
        for (final m in molds) {
          await recordMold(m);
        }
      });

  /// 换模：写入新模具并挂接原模具链。
  Future<void> remold(MoldRecord newMold) => recordMold(newMold);

  Future<void> recordSample(LabSample sample) =>
      _db.into(_db.labSamples).insert(sampleToCompanion(sample));

  Future<void> recordPhoto(CurdPhoto photo) =>
      _db.into(_db.curdPhotos).insert(photoToCompanion(photo));

  // ---------- 读取 ----------

  Future<List<ActionEvent>> eventsForVat(String vatId) async {
    final rows = await (_db.select(_db.actionEvents)
          ..where((e) => e.vatId.equals(vatId))
          ..orderBy([(e) => OrderingTerm.asc(e.performedAt)]))
        .get();
    return rows.map(actionEventFromRow).toList();
  }

  Stream<List<ActionEvent>> watchEventsForVat(String vatId) =>
      (_db.select(_db.actionEvents)
            ..where((e) => e.vatId.equals(vatId))
            ..orderBy([(e) => OrderingTerm.asc(e.performedAt)]))
          .watch()
          .map((rows) => rows.map(actionEventFromRow).toList());

  Future<List<MoldRecord>> moldsForVat(String vatId) async {
    final rows = await (_db.select(_db.molds)
          ..where((m) => m.vatId.equals(vatId)))
        .get();
    return rows.map(moldFromRow).toList();
  }

  // ---------- 规则检查 ----------

  /// 汇总某工艺版本下全部追溯数据并运行所有工位规则。
  Future<List<Finding>> checkVersion(String processVersionId) async {
    final ctx = await loadContext(processVersionId);
    return _engine.runAll(ctx);
  }

  /// 对单个奶槽运行全部规则（使用其动作所挂的冻结版本）。
  Future<List<Finding>> checkVat(String vatId) async {
    final ctx = await contextForVat(vatId);
    return ctx == null ? const [] : _engine.runAll(ctx);
  }

  /// 组装单槽追溯上下文；无冻结版本时返回 null。
  Future<TraceContext?> contextForVat(String vatId) async {
    final eventRows = await (_db.select(_db.actionEvents)
          ..where((e) => e.vatId.equals(vatId)))
        .get();
    final versionId = eventRows.isEmpty
        ? (await listVersions()).firstOrNull?.id
        : eventRows.first.processVersionId;
    if (versionId == null) return null;
    final version = await findVersion(versionId);
    if (version == null) return null;

    final allTransfers = await _db.select(_db.wheyTransfers).get();
    // 混批检查需看到本槽所用乳清罐的全部来源。
    final usedTanks =
        allTransfers.where((t) => t.vatId == vatId).map((t) => t.tankId).toSet();
    final transfers =
        allTransfers.where((t) => usedTanks.contains(t.tankId)).toList();
    final molds = await (_db.select(_db.molds)
          ..where((m) => m.vatId.equals(vatId)))
        .get();
    final samples = await (_db.select(_db.labSamples)
          ..where((s) => s.vatId.equals(vatId)))
        .get();
    final photos = await (_db.select(_db.curdPhotos)
          ..where((p) => p.vatId.equals(vatId)))
        .get();

    return TraceContext(
      version: version,
      events: eventRows.map(actionEventFromRow).toList(),
      transfers: transfers.map(transferFromRow).toList(),
      molds: molds.map(moldFromRow).toList(),
      samples: samples.map(sampleFromRow).toList(),
      photos: photos.map(photoFromRow).toList(),
    );
  }

  Future<TraceContext> loadContext(String processVersionId) async {
    final versionRow = await (_db.select(_db.processVersions)
          ..where((v) => v.id.equals(processVersionId)))
        .getSingle();
    final version = processVersionFromRow(versionRow);

    final events = await (_db.select(_db.actionEvents)
          ..where((e) => e.processVersionId.equals(processVersionId)))
        .get();
    final vatIds = events.map((e) => e.vatId).toSet();

    final transfers = await _db.select(_db.wheyTransfers).get();
    final molds = await _db.select(_db.molds).get();
    final samples = await _db.select(_db.labSamples).get();
    final photos = await _db.select(_db.curdPhotos).get();

    return TraceContext(
      version: version,
      events: events.map(actionEventFromRow).toList(),
      // 乳清转移不做版本过滤：混批检查必须看到整库去向。
      transfers: transfers.map(transferFromRow).toList(),
      molds: molds
          .where((m) => vatIds.contains(m.vatId))
          .map(moldFromRow)
          .toList(),
      samples: samples
          .where((s) => vatIds.contains(s.vatId))
          .map(sampleFromRow)
          .toList(),
      photos: photos
          .where((p) => vatIds.contains(p.vatId))
          .map(photoFromRow)
          .toList(),
    );
  }
}
