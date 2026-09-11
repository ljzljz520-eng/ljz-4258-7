import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/models/action_event.dart';
import '../../core/models/curd_photo.dart';
import '../../core/models/enums.dart';
import '../../core/models/lab_sample.dart';
import '../../core/models/mold.dart';
import '../../core/models/process_version.dart';
import '../../core/models/whey.dart' as core;
import 'database.dart' as db;

/// Drift 行 ↔ 核心领域模型 的相互转换。
/// 数据库行类统一以 `db.` 前缀引用，避免与领域模型同名冲突。

// ---------- 工艺版本 ----------

db.ProcessVersionsCompanion processVersionToCompanion(ProcessVersion v) =>
    db.ProcessVersionsCompanion(
      id: Value(v.id),
      name: Value(v.name),
      frozenBy: Value(v.frozenBy),
      frozenAt: Value(v.frozenAt),
      stepOrderJson: Value(jsonEncode(v.stepOrder.map((s) => s.name).toList())),
      tolerancesJson: Value(jsonEncode({
        'maxGrainSizeDiffMm': v.tolerances.maxGrainSizeDiffMm,
        'maxMoldWeightSpreadPct': v.tolerances.maxMoldWeightSpreadPct,
        'maxSampleDelayMinutes': v.tolerances.maxSampleDelay?.inMinutes,
        'allowWheyTankMixing': v.tolerances.allowWheyTankMixing,
      })),
    );

ProcessVersion processVersionFromRow(db.ProcessVersion row) => ProcessVersion(
      id: row.id,
      name: row.name,
      frozenBy: row.frozenBy,
      frozenAt: row.frozenAt,
      stepOrder: [
        for (final name in (jsonDecode(row.stepOrderJson) as List).cast<String>())
          StepKind.values.byName(name),
      ],
      tolerances: _tolerancesFromJson(row.tolerancesJson),
    );

QaTolerances _tolerancesFromJson(String jsonStr) {
  final m = jsonDecode(jsonStr) as Map<String, dynamic>;
  final delayMin = m['maxSampleDelayMinutes'] as int?;
  return QaTolerances(
    maxGrainSizeDiffMm: (m['maxGrainSizeDiffMm'] as num?)?.toDouble(),
    maxMoldWeightSpreadPct: (m['maxMoldWeightSpreadPct'] as num?)?.toDouble(),
    maxSampleDelay: delayMin == null ? null : Duration(minutes: delayMin),
    allowWheyTankMixing: m['allowWheyTankMixing'] as bool? ?? false,
  );
}

// ---------- 动作事件 ----------

db.ActionEventsCompanion actionEventToCompanion(ActionEvent e) =>
    db.ActionEventsCompanion(
      id: Value(e.id),
      vatId: Value(e.vatId),
      step: Value(e.step),
      performedAt: Value(e.performedAt),
      operatorId: Value(e.operatorId),
      processVersionId: Value(e.processVersionId),
      temperatureC: Value(e.temperatureC),
      visualState: Value(e.visualState),
      cutSizeMm: Value(e.cutSizeMm),
      zone: Value(e.zone),
      note: Value(e.note),
    );

ActionEvent actionEventFromRow(db.ActionEvent row) => ActionEvent(
      id: row.id,
      vatId: row.vatId,
      step: row.step,
      performedAt: row.performedAt,
      operatorId: row.operatorId,
      processVersionId: row.processVersionId,
      temperatureC: row.temperatureC,
      visualState: row.visualState,
      cutSizeMm: row.cutSizeMm,
      zone: row.zone,
      note: row.note,
    );

// ---------- 乳清 ----------

db.WheyTransfersCompanion transferToCompanion(core.WheyTransfer t) =>
    db.WheyTransfersCompanion(
      id: Value(t.id),
      vatId: Value(t.vatId),
      tankId: Value(t.tankId),
      transferredAt: Value(t.transferredAt),
      amountL: Value(t.amountL),
    );

core.WheyTransfer transferFromRow(db.WheyTransfer row) => core.WheyTransfer(
      id: row.id,
      vatId: row.vatId,
      tankId: row.tankId,
      transferredAt: row.transferredAt,
      amountL: row.amountL,
    );

// ---------- 模具 ----------

db.MoldsCompanion moldToCompanion(MoldRecord m) => db.MoldsCompanion(
      id: Value(m.id),
      batchId: Value(m.batchId),
      vatId: Value(m.vatId),
      qrCode: Value(m.qrCode),
      weightG: Value(m.weightG),
      moldedAt: Value(m.moldedAt),
      pressedAt: Value(m.pressedAt),
      remoldedFromId: Value(m.remoldedFromId),
      remoldedAt: Value(m.remoldedAt),
    );

MoldRecord moldFromRow(db.Mold row) => MoldRecord(
      id: row.id,
      batchId: row.batchId,
      vatId: row.vatId,
      qrCode: row.qrCode,
      weightG: row.weightG,
      moldedAt: row.moldedAt,
      pressedAt: row.pressedAt,
      remoldedFromId: row.remoldedFromId,
      remoldedAt: row.remoldedAt,
    );

// ---------- 实验室样品 ----------

db.LabSamplesCompanion sampleToCompanion(LabSample s) =>
    db.LabSamplesCompanion(
      id: Value(s.id),
      vatId: Value(s.vatId),
      moldId: Value(s.moldId),
      step: Value(s.step),
      sampledAt: Value(s.sampledAt),
      receivedAt: Value(s.receivedAt),
      moisturePct: Value(s.moisturePct),
      acidityPh: Value(s.acidityPh),
      labId: Value(s.labId),
    );

LabSample sampleFromRow(db.LabSample row) => LabSample(
      id: row.id,
      vatId: row.vatId,
      moldId: row.moldId,
      step: row.step,
      sampledAt: row.sampledAt,
      receivedAt: row.receivedAt,
      moisturePct: row.moisturePct,
      acidityPh: row.acidityPh,
      labId: row.labId,
    );

// ---------- 凝乳照片 ----------

db.CurdPhotosCompanion photoToCompanion(CurdPhoto p) =>
    db.CurdPhotosCompanion(
      id: Value(p.id),
      vatId: Value(p.vatId),
      zone: Value(p.zone),
      takenAt: Value(p.takenAt),
      filePath: Value(p.filePath),
      standardBackground: Value(p.standardBackground),
      grainSizeMm: Value(p.grainSizeMm),
    );

CurdPhoto photoFromRow(db.CurdPhoto row) => CurdPhoto(
      id: row.id,
      vatId: row.vatId,
      zone: row.zone,
      takenAt: row.takenAt,
      filePath: row.filePath,
      standardBackground: row.standardBackground,
      grainSizeMm: row.grainSizeMm,
    );
