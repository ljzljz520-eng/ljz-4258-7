import '../models/enums.dart';
import '../models/finding.dart';
import '../models/mold.dart';
import 'rule.dart';

/// 模具拆分规则：同一模具批内单模重量应均衡。
///
/// 覆盖场景：「多个模具重量不平」——同一批模具重量相对均值的离散
/// 超过冻结版本容差时报警；重量不平会导致压制后水分不一致。
class MoldSplitRule extends StationRule {
  const MoldSplitRule();

  @override
  String get prefix => 'MOLD';

  @override
  List<Finding> check(TraceContext ctx) {
    final findings = <Finding>[];
    final tolerancePct = ctx.version.tolerances.maxMoldWeightSpreadPct;
    if (tolerancePct == null) return findings;

    final byBatch = <String, List<MoldRecord>>{};
    for (final m in ctx.molds) {
      if (m.weightG != null) {
        byBatch.putIfAbsent(m.batchId, () => []).add(m);
      }
    }
    byBatch.forEach((batchId, molds) {
      if (molds.length < 2) return;
      final weights = molds.map((m) => m.weightG!).toList();
      final mean = weights.reduce((a, b) => a + b) / weights.length;
      if (mean <= 0) return;
      for (var i = 0; i < molds.length; i++) {
        final spreadPct = (weights[i] - mean).abs() / mean * 100;
        if (spreadPct > tolerancePct) {
          findings.add(Finding(
            code: 'MOLD_WEIGHT_UNEVEN',
            severity: Severity.warning,
            vatId: molds[i].vatId,
            relatedIds: {batchId, molds[i].id},
            message: '模具批 $batchId：模具 ${molds[i].id} 重 '
                '${weights[i].toStringAsFixed(0)}g，偏离批均值 '
                '${mean.toStringAsFixed(0)}g 达 ${spreadPct.toStringAsFixed(1)}%，'
                '超过容差 ${tolerancePct.toStringAsFixed(1)}%。',
          ));
        }
      }
    });
    return findings;
  }
}
