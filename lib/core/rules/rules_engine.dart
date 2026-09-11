import '../models/finding.dart';
import 'grain_zone_rule.dart';
import 'mold_split_rule.dart';
import 'remold_rule.dart';
import 'rule.dart';
import 'sample_delay_rule.dart';
import 'sequence_rule.dart';
import 'turn_rule.dart';
import 'whey_merge_rule.dart';

/// 规则引擎：对追溯上下文执行全部工位规则，汇总检查发现。
///
/// 引擎只做检查与标记，不输出任何制作配方或设备参数。
class RulesEngine {
  RulesEngine({List<StationRule>? rules})
      : rules = rules ??
            const [
              SequenceRule(),
              GrainZoneRule(),
              WheyMergeRule(),
              MoldSplitRule(),
              RemoldRule(),
              SampleDelayRule(),
              TurnRule(),
            ];

  final List<StationRule> rules;

  List<Finding> runAll(TraceContext ctx) =>
      [for (final rule in rules) ...rule.check(ctx)];

  /// 仅返回违规级发现（用于放行判断）。
  List<Finding> violations(TraceContext ctx) =>
      runAll(ctx).where((f) => f.isViolation).toList();
}
