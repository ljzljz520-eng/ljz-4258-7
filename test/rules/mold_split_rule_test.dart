import 'package:cheese_trace/core/models/mold.dart';
import 'package:cheese_trace/core/models/process_version.dart';
import 'package:cheese_trace/core/rules/mold_split_rule.dart';
import 'package:cheese_trace/core/rules/rule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MoldSplitRule — 多个模具重量不平', () {
    final version = ProcessVersion(
      id: 'PV-1',
      name: '冻结版本A',
      frozenBy: 'cheesemaker-01',
      frozenAt: DateTime(2026, 9, 1),
      stepOrder: ProcessVersion.canonicalOrder,
      tolerances: const QaTolerances(maxMoldWeightSpreadPct: 5.0),
    );

    MoldRecord mold(String id, double weightG) => MoldRecord(
          id: id,
          batchId: 'BATCH-1',
          vatId: 'VAT-1',
          qrCode: 'QR-$id',
          weightG: weightG,
          moldedAt: DateTime(2026, 9, 11, 10),
        );

    test('某模重量偏离批均值超 5% → 警告并指出该模', () {
      final ctx = TraceContext(version: version, molds: [
        mold('M1', 1000),
        mold('M2', 1010),
        mold('M3', 990),
        mold('M4', 880), // 明显偏轻
      ]);
      final findings = const MoldSplitRule().check(ctx);
      expect(findings, hasLength(1));
      expect(findings.single.code, 'MOLD_WEIGHT_UNEVEN');
      expect(findings.single.relatedIds, contains('M4'));
    });

    test('重量均衡 → 无发现', () {
      final ctx = TraceContext(version: version, molds: [
        mold('M1', 1000),
        mold('M2', 1010),
        mold('M3', 995),
      ]);
      expect(const MoldSplitRule().check(ctx), isEmpty);
    });

    test('缺称重的模具不参与检查', () {
      final ctx = TraceContext(version: version, molds: [
        mold('M1', 1000),
        const MoldRecord(
            id: 'M2', batchId: 'BATCH-1', vatId: 'VAT-1', qrCode: 'QR-M2'),
      ]);
      expect(const MoldSplitRule().check(ctx), isEmpty);
    });
  });
}
