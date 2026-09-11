import 'package:cheese_trace/core/models/enums.dart';
import 'package:cheese_trace/core/models/mold.dart';
import 'package:cheese_trace/core/models/process_version.dart';
import 'package:cheese_trace/core/rules/remold_rule.dart';
import 'package:cheese_trace/core/rules/rule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoldRule — 压制后产品换模', () {
    final version = ProcessVersion(
      id: 'PV-1',
      name: '冻结版本A',
      frozenBy: 'cheesemaker-01',
      frozenAt: DateTime(2026, 9, 1),
      stepOrder: ProcessVersion.canonicalOrder,
    );

    test('压制完成后换模 → 违规', () {
      final pressed = DateTime(2026, 9, 11, 14, 0);
      final ctx = TraceContext(version: version, molds: [
        MoldRecord(
          id: 'M1',
          batchId: 'B1',
          vatId: 'VAT-1',
          qrCode: 'QR-M1',
          weightG: 1000,
          moldedAt: DateTime(2026, 9, 11, 10),
          pressedAt: pressed,
        ),
        MoldRecord(
          id: 'M2',
          batchId: 'B1',
          vatId: 'VAT-1',
          qrCode: 'QR-M2',
          remoldedFromId: 'M1',
          remoldedAt: pressed.add(const Duration(hours: 1)), // 压制后换模
        ),
      ]);
      final findings = const RemoldRule().check(ctx);
      expect(findings, hasLength(1));
      expect(findings.single.code, 'REMOLD_AFTER_PRESS');
      expect(findings.single.severity, Severity.violation);
      expect(findings.single.relatedIds, containsAll({'M1', 'M2'}));
    });

    test('压制前换模 → 仅信息记录', () {
      final ctx = TraceContext(version: version, molds: [
        MoldRecord(
          id: 'M1',
          batchId: 'B1',
          vatId: 'VAT-1',
          qrCode: 'QR-M1',
          moldedAt: DateTime(2026, 9, 11, 10),
        ),
        MoldRecord(
          id: 'M2',
          batchId: 'B1',
          vatId: 'VAT-1',
          qrCode: 'QR-M2',
          remoldedFromId: 'M1',
          remoldedAt: DateTime(2026, 9, 11, 11),
        ),
      ]);
      final findings = const RemoldRule().check(ctx);
      expect(findings, hasLength(1));
      expect(findings.single.code, 'REMOLD_BEFORE_PRESS');
      expect(findings.single.severity, Severity.info);
    });

    test('无换模 → 无发现', () {
      final ctx = TraceContext(version: version, molds: [
        const MoldRecord(
            id: 'M1', batchId: 'B1', vatId: 'VAT-1', qrCode: 'QR-M1'),
      ]);
      expect(const RemoldRule().check(ctx), isEmpty);
    });
  });
}
