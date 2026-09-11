import '../models/enums.dart';
import '../models/finding.dart';
import 'rule.dart';

/// 样品时延规则：实验室样品从取样到送检的时延不得超过冻结版本容差；
/// 样品必须能关联到对应工步的已实施动作。
class SampleDelayRule extends StationRule {
  const SampleDelayRule();

  @override
  String get prefix => 'LAB';

  @override
  List<Finding> check(TraceContext ctx) {
    final findings = <Finding>[];
    final maxDelay = ctx.version.tolerances.maxSampleDelay;

    for (final s in ctx.samples) {
      // 1) 时延检查。
      if (maxDelay != null && s.receivedAt != null) {
        final delay = s.receivedAt!.difference(s.sampledAt);
        if (delay > maxDelay) {
          findings.add(Finding(
            code: 'LAB_SAMPLE_DELAYED',
            severity: Severity.warning,
            vatId: s.vatId,
            relatedIds: {s.id},
            message: '样品 ${s.id}（${s.step.label}）时延 '
                '${delay.inMinutes} 分钟，超过容差 ${maxDelay.inMinutes} 分钟，'
                '水分/酸度结果代表性存疑。',
          ));
        }
      }
      // 2) 关联性：样品所代表的工步在该槽必须已有动作记录。
      final sub = ctx.forVat(s.vatId);
      final hasStep = sub.events.any((e) => e.step == s.step);
      if (!hasStep) {
        findings.add(Finding(
          code: 'LAB_SAMPLE_ORPHAN',
          severity: Severity.warning,
          vatId: s.vatId,
          relatedIds: {s.id},
          message: '样品 ${s.id} 关联工步「${s.step.label}」，'
              '但槽 ${s.vatId} 无该工步的动作记录，无法核对取样时点。',
        ));
      }
    }
    return findings;
  }
}
