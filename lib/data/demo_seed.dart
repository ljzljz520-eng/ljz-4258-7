import '../core/models/process_version.dart';
import 'trace_repository.dart';

/// 首次启动时写入最小演示数据：一个冻结版本、一口奶槽、两个乳清罐。
/// 仅用于让界面立即可用；不含任何配方或设备参数。
Future<void> seedDemoIfEmpty(TraceRepository repo) async {
  const versionId = 'PV-DEMO';
  final existing = await repo.findVersion(versionId);
  if (existing != null) return;

  await repo.freezeVersion(ProcessVersion(
    id: versionId,
    name: '演示冻结版本',
    frozenBy: 'cheesemaker-demo',
    frozenAt: DateTime(2026, 9, 1, 9),
    stepOrder: ProcessVersion.canonicalOrder,
    tolerances: const QaTolerances(
      maxGrainSizeDiffMm: 2.0,
      maxMoldWeightSpreadPct: 5.0,
      maxSampleDelay: Duration(minutes: 30),
    ),
  ));
  await repo.addVat('VAT-1', '1号凝乳槽', 'QR-VAT-1',
      milkBatch: 'MILK-20260911-A', startedAt: DateTime(2026, 9, 11, 7, 30));
  await repo.addWheyTank('TANK-A', '乳清罐A', 'QR-TANK-A');
  await repo.addWheyTank('TANK-B', '乳清罐B', 'QR-TANK-B');
}
