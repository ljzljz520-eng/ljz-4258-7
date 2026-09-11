import 'package:cheese_trace/core/models/curd_photo.dart';
import 'package:cheese_trace/core/models/enums.dart';
import 'package:cheese_trace/core/models/process_version.dart';
import 'package:cheese_trace/core/rules/grain_zone_rule.dart';
import 'package:cheese_trace/core/rules/rule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GrainZoneRule — 槽底凝乳粒较大', () {
    final version = ProcessVersion(
      id: 'PV-1',
      name: '冻结版本A',
      frozenBy: 'cheesemaker-01',
      frozenAt: DateTime(2026, 9, 1),
      stepOrder: ProcessVersion.canonicalOrder,
      tolerances: const QaTolerances(maxGrainSizeDiffMm: 2.0),
    );

    CurdPhoto photo(String id, VatZone zone, double grainMm) => CurdPhoto(
          id: id,
          vatId: 'VAT-1',
          zone: zone,
          takenAt: DateTime(2026, 9, 11, 8, 25),
          filePath: '/photos/$id.jpg',
          standardBackground: true,
          grainSizeMm: grainMm,
        );

    test('槽底粒径超出表层 2mm 容差 → 警告', () {
      final ctx = TraceContext(version: version, photos: [
        photo('p1', VatZone.top, 8.0),
        photo('p2', VatZone.top, 8.4),
        photo('p3', VatZone.bottom, 11.5), // 槽底明显偏大
        photo('p4', VatZone.bottom, 11.0),
      ]);
      final findings = const GrainZoneRule().check(ctx);
      expect(findings, hasLength(1));
      expect(findings.single.code, 'GRAIN_ZONE_UNEVEN');
      expect(findings.single.message, contains('槽底'));
    });

    test('各位置粒径接近 → 无发现', () {
      final ctx = TraceContext(version: version, photos: [
        photo('p1', VatZone.top, 8.0),
        photo('p2', VatZone.bottom, 8.8),
      ]);
      expect(const GrainZoneRule().check(ctx), isEmpty);
    });

    test('未录入容差 → 不检查', () {
      final v = ProcessVersion(
        id: 'PV-2',
        name: '无容差版本',
        frozenBy: 'c',
        frozenAt: DateTime(2026, 9, 1),
        stepOrder: ProcessVersion.canonicalOrder,
      );
      final ctx = TraceContext(version: v, photos: [
        photo('p1', VatZone.top, 8.0),
        photo('p2', VatZone.bottom, 20.0),
      ]);
      expect(const GrainZoneRule().check(ctx), isEmpty);
    });
  });
}
