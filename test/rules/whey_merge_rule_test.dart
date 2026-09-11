import 'package:cheese_trace/core/models/process_version.dart';
import 'package:cheese_trace/core/models/whey.dart';
import 'package:cheese_trace/core/rules/rule.dart';
import 'package:cheese_trace/core/rules/whey_merge_rule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WheyMergeRule — 乳清罐混批', () {
    ProcessVersion version({bool allowMixing = false}) => ProcessVersion(
          id: 'PV-1',
          name: '冻结版本A',
          frozenBy: 'cheesemaker-01',
          frozenAt: DateTime(2026, 9, 1),
          stepOrder: ProcessVersion.canonicalOrder,
          tolerances: QaTolerances(allowWheyTankMixing: allowMixing),
        );

    WheyTransfer transfer(String id, String vat, String tank) => WheyTransfer(
          id: id,
          vatId: vat,
          tankId: tank,
          transferredAt: DateTime(2026, 9, 11, 9),
          amountL: 120,
        );

    test('两个奶槽汇入同一乳清罐 → 混批警告', () {
      final ctx = TraceContext(version: version(), transfers: [
        transfer('t1', 'VAT-1', 'TANK-A'),
        transfer('t2', 'VAT-2', 'TANK-A'),
      ]);
      final findings = const WheyMergeRule().check(ctx);
      expect(findings, hasLength(1));
      expect(findings.single.code, 'WHEY_TANK_MIXED');
      expect(findings.single.relatedIds, containsAll({'TANK-A', 'VAT-1', 'VAT-2'}));
    });

    test('一槽一罐 → 无发现', () {
      final ctx = TraceContext(version: version(), transfers: [
        transfer('t1', 'VAT-1', 'TANK-A'),
        transfer('t2', 'VAT-2', 'TANK-B'),
      ]);
      expect(const WheyMergeRule().check(ctx), isEmpty);
    });

    test('同槽多次入同一罐 → 不算混批', () {
      final ctx = TraceContext(version: version(), transfers: [
        transfer('t1', 'VAT-1', 'TANK-A'),
        transfer('t2', 'VAT-1', 'TANK-A'),
      ]);
      expect(const WheyMergeRule().check(ctx), isEmpty);
    });

    test('冻结版本允许混批 → 不检查', () {
      final ctx = TraceContext(version: version(allowMixing: true), transfers: [
        transfer('t1', 'VAT-1', 'TANK-A'),
        transfer('t2', 'VAT-2', 'TANK-A'),
      ]);
      expect(const WheyMergeRule().check(ctx), isEmpty);
    });
  });
}
