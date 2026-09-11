import '../models/enums.dart';
import '../models/finding.dart';
import 'rule.dart';

/// 乳清去向规则：乳清罐默认不允许混批。
///
/// 覆盖场景：「乳清罐混批」——同一乳清罐收到来自多个奶槽/批次的转移，
/// 除非冻结版本明确允许，否则报警并列出全部来源。
class WheyMergeRule extends StationRule {
  const WheyMergeRule();

  @override
  String get prefix => 'WHEY';

  @override
  List<Finding> check(TraceContext ctx) {
    final findings = <Finding>[];
    if (ctx.version.tolerances.allowWheyTankMixing) return findings;

    final byTank = <String, List<String>>{};
    for (final t in ctx.transfers) {
      byTank.putIfAbsent(t.tankId, () => []).add(t.vatId);
    }
    byTank.forEach((tankId, vatIds) {
      final distinct = vatIds.toSet();
      if (distinct.length > 1) {
        findings.add(Finding(
          code: 'WHEY_TANK_MIXED',
          severity: Severity.warning,
          relatedIds: {tankId, ...distinct},
          message: '乳清罐 $tankId 收到 ${distinct.length} 个奶槽'
              '（${distinct.join('、')}）的乳清，构成混批；'
              '冻结版本 ${ctx.version.name} 未允许混批。',
        ));
      }
    });
    return findings;
  }
}
