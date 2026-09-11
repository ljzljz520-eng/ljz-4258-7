import 'enums.dart';

/// 制酪师冻结的工艺版本。
///
/// 冻结后不可更改；操作员的所有动作都挂在某个冻结版本之下，
/// 以便事后按当时版本复核。版本中的阈值由制酪师录入，
/// 系统仅据此校验，不生成或推荐任何数值。
class ProcessVersion {
  const ProcessVersion({
    required this.id,
    required this.name,
    required this.frozenBy,
    required this.frozenAt,
    required this.stepOrder,
    this.tolerances = const QaTolerances(),
  });

  final String id;
  final String name;

  /// 冻结人（制酪师）。
  final String frozenBy;
  final DateTime frozenAt;

  /// 冻结的工步顺序模板。
  final List<StepKind> stepOrder;

  /// 质检容差（制酪师录入，系统仅用于比对）。
  final QaTolerances tolerances;

  /// 标准六步顺序（仅为默认模板常量，不构成配方建议）。
  static const List<StepKind> canonicalOrder = [
    StepKind.curdling,
    StepKind.cutting,
    StepKind.stirring,
    StepKind.wheyDrain,
    StepKind.molding,
    StepKind.pressing,
  ];
}

/// 质检容差集合。全部可空：未录入即不检查。
class QaTolerances {
  const QaTolerances({
    this.maxGrainSizeDiffMm,
    this.maxMoldWeightSpreadPct,
    this.maxSampleDelay,
    this.allowWheyTankMixing = false,
    this.maxTurnRecordDelay,
  });

  /// 同一槽内不同位置凝乳粒径允许的最大差值（mm）。
  final double? maxGrainSizeDiffMm;

  /// 同一模具批内单模重量允许的最大离散（相对均值的百分比）。
  final double? maxMoldWeightSpreadPct;

  /// 实验室样品从取样到送检允许的最大时延。
  final Duration? maxSampleDelay;

  /// 是否允许多槽乳清汇入同一乳清罐（默认不允许，混入即报警）。
  final bool allowWheyTankMixing;

  /// 翻模记录允许的最大补录时延（实际翻面 → 落库）。
  /// 超过即视为夜班补录等延迟记录，需人工确认；未录入则不检查。
  final Duration? maxTurnRecordDelay;
}
