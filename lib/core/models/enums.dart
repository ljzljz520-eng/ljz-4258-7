/// 奶酪制作追溯 —— 领域枚举。
///
/// 注意：本系统只做「追溯与一致性检查」，不产出任何制作配方或设备参数。
/// 所有阈值均来自制酪师冻结的工艺版本（[ProcessVersion]），由系统校验而非建议。
library;

/// 工步类型（手工动作，均需可追溯时点）。
enum StepKind {
  curdling('凝乳'),
  cutting('切割'),
  stirring('搅拌'),
  wheyDrain('排乳清'),
  molding('入模'),
  pressing('压制');

  const StepKind(this.label);
  final String label;
}

/// 槽内取样/观察位置。槽底凝乳粒往往与表层不同，需分区记录。
enum VatZone {
  top('表层'),
  middle('中层'),
  bottom('槽底');

  const VatZone(this.label);
  final String label;
}

/// 操作员记录的目视状态（自由观察，不含工艺建议）。
enum VisualState {
  normal('正常'),
  grainsLarge('凝乳粒偏大'),
  grainsSmall('凝乳粒偏小'),
  grainsUneven('粒度不均'),
  wheyCloudy('乳清浑浊'),
  wheyClear('乳清清亮');

  const VisualState(this.label);
  final String label;
}

/// 检查结果严重度。
enum Severity {
  info('提示'),
  warning('警告'),
  violation('违规');

  const Severity(this.label);
  final String label;
}
