import '../models/enums.dart';
import '../models/finding.dart';
import 'rule.dart';

/// 槽内位置粒度规则：同一槽不同位置（表层/中层/槽底）的凝乳粒径差异
/// 超过冻结版本容差时报警。
///
/// 覆盖场景：「槽底凝乳粒较大」——槽底照片/量测粒径显著大于表层，
/// 粒度不均会影响后续水分分布，需可追溯地标记。
class GrainZoneRule extends StationRule {
  const GrainZoneRule();

  @override
  String get prefix => 'GRAIN';

  @override
  List<Finding> check(TraceContext ctx) {
    final findings = <Finding>[];
    final tolerance = ctx.version.tolerances.maxGrainSizeDiffMm;
    if (tolerance == null) return findings; // 制酪师未录入容差则不检查。

    for (final vatId in ctx.vatIds) {
      final sub = ctx.forVat(vatId);
      // 汇总每个位置的粒径观测（照片量测 + 动作记录中的切块尺寸）。
      final byZone = <VatZone, List<double>>{};
      for (final p in sub.photos) {
        if (p.grainSizeMm != null) {
          byZone.putIfAbsent(p.zone, () => []).add(p.grainSizeMm!);
        }
      }
      for (final e in sub.events) {
        if (e.cutSizeMm != null && e.zone != null) {
          byZone.putIfAbsent(e.zone!, () => []).add(e.cutSizeMm!);
        }
      }
      if (byZone.length < 2) continue;

      final means = byZone.map((zone, sizes) => MapEntry(
          zone, sizes.reduce((a, b) => a + b) / sizes.length));
      final entries = means.entries.toList();
      for (var i = 0; i < entries.length; i++) {
        for (var j = i + 1; j < entries.length; j++) {
          final diff = (entries[i].value - entries[j].value).abs();
          if (diff > tolerance) {
            findings.add(Finding(
              code: 'GRAIN_ZONE_UNEVEN',
              severity: Severity.warning,
              vatId: vatId,
              message: '槽 $vatId：${entries[i].key.label}平均粒径 '
                  '${entries[i].value.toStringAsFixed(1)}mm 与 '
                  '${entries[j].key.label} ${entries[j].value.toStringAsFixed(1)}mm '
                  '相差 ${diff.toStringAsFixed(1)}mm，超过容差 '
                  '${tolerance.toStringAsFixed(1)}mm（粒度不均会影响水分分布）。',
            ));
          }
        }
      }
    }
    return findings;
  }
}
