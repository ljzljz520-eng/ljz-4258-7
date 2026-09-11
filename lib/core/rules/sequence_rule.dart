import '../models/action_event.dart';
import '../models/enums.dart';
import '../models/finding.dart';
import 'rule.dart';

/// 顺序规则：已实施动作必须按冻结版本的工步顺序发生。
///
/// 覆盖场景：「切割按钮晚按」——切割记录的发生时点晚于搅拌开始时点，
/// 或动作顺序与冻结模板不一致（跳步、倒序、重复）。
class SequenceRule extends StationRule {
  const SequenceRule();

  @override
  String get prefix => 'SEQ';

  @override
  List<Finding> check(TraceContext ctx) {
    final findings = <Finding>[];
    for (final vatId in ctx.vatIds) {
      final events = ctx.forVat(vatId).events.toList()
        ..sort((a, b) => a.performedAt.compareTo(b.performedAt));
      findings.addAll(_checkVat(vatId, ctx, events));
    }
    return findings;
  }

  List<Finding> _checkVat(
      String vatId, TraceContext ctx, List<ActionEvent> events) {
    final findings = <Finding>[];
    final order = ctx.version.stepOrder;

    // 1) 时标单调性：同一工步模板中，后序工步不得早于前序工步。
    //    找出每个工步最早一次发生，验证其相对顺序与模板一致。
    final firstOccurrence = <StepKind, ActionEvent>{};
    for (final e in events) {
      firstOccurrence.putIfAbsent(e.step, () => e);
    }
    final present = order.where(firstOccurrence.containsKey).toList();
    for (var i = 0; i < present.length - 1; i++) {
      final earlier = firstOccurrence[present[i]]!;
      final later = firstOccurrence[present[i + 1]]!;
      if (!later.performedAt.isAfter(earlier.performedAt)) {
        findings.add(Finding(
          code: 'SEQ_OUT_OF_ORDER',
          severity: Severity.violation,
          vatId: vatId,
          relatedIds: {earlier.id, later.id},
          message: '槽 $vatId：「${later.step.label}」记录时点 '
              '${_fmt(later.performedAt)} 不晚于「${earlier.step.label}」'
              '${_fmt(earlier.performedAt)}，与冻结版本 ${ctx.version.name} 的顺序不符'
              '（疑似 ${earlier.step.label} 按钮晚按或补录）。',
        ));
      }
    }

    // 2) 跳步：已发生的最末工步之前的模板工步必须都有记录。
    if (events.isNotEmpty) {
      final maxIndex = events
          .map((e) => order.indexOf(e.step))
          .where((i) => i >= 0)
          .fold(-1, (a, b) => a > b ? a : b);
      for (var i = 0; i < maxIndex; i++) {
        if (!firstOccurrence.containsKey(order[i])) {
          findings.add(Finding(
            code: 'SEQ_STEP_MISSING',
            severity: Severity.warning,
            vatId: vatId,
            message: '槽 $vatId：工步「${order[i].label}」无任何记录，'
                '但后续工步已发生，存在跳步。',
          ));
        }
      }
    }

    // 3) 重复工步：同一工步多次按下需提示复核（允许换模等合法重复由各自规则判断）。
    final counts = <StepKind, int>{};
    for (final e in events) {
      counts[e.step] = (counts[e.step] ?? 0) + 1;
    }
    counts.forEach((step, n) {
      if (n > 1) {
        findings.add(Finding(
          code: 'SEQ_STEP_DUPLICATED',
          severity: Severity.info,
          vatId: vatId,
          message: '槽 $vatId：工步「${step.label}」记录了 $n 次，请确认是否为补录或误触。',
        ));
      }
    });
    return findings;
  }

  static String _fmt(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:${t.second.toString().padLeft(2, '0')}';
}
