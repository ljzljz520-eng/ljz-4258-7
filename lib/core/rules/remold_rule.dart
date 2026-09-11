import '../models/enums.dart';
import '../models/finding.dart';
import 'rule.dart';

/// 换模规则：压制完成后不得再换模。
///
/// 覆盖场景：「压制后产品换模」——换模时点晚于原模具压制时点，
/// 属于违规操作，必须显式标记；压制前换模仅作信息记录。
class RemoldRule extends StationRule {
  const RemoldRule();

  @override
  String get prefix => 'REMOLD';

  @override
  List<Finding> check(TraceContext ctx) {
    final findings = <Finding>[];
    final byId = {for (final m in ctx.molds) m.id: m};
    for (final m in ctx.molds) {
      final fromId = m.remoldedFromId;
      if (fromId == null) continue;
      final source = byId[fromId];
      final pressedAt = source?.pressedAt;
      if (pressedAt != null &&
          m.remoldedAt != null &&
          m.remoldedAt!.isAfter(pressedAt)) {
        findings.add(Finding(
          code: 'REMOLD_AFTER_PRESS',
          severity: Severity.violation,
          vatId: m.vatId,
          relatedIds: {m.id, fromId},
          message: '槽 ${m.vatId}：模具 $fromId 已于 '
              '${pressedAt.toIso8601String()} 完成压制，'
              '其后产品被换入模具 ${m.id}（${m.remoldedAt!.toIso8601String()}），'
              '压制后换模为违规操作。',
        ));
      } else {
        findings.add(Finding(
          code: 'REMOLD_BEFORE_PRESS',
          severity: Severity.info,
          vatId: m.vatId,
          relatedIds: {m.id, fromId},
          message: '槽 ${m.vatId}：模具 ${m.id} 由 $fromId 换模而来（压制前），已记录。',
        ));
      }
    }
    return findings;
  }
}
