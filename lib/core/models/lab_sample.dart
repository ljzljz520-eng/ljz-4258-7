import 'enums.dart';

/// 实验室样品：水分/酸度结果，关联到具体工步与奶槽/模具。
class LabSample {
  const LabSample({
    required this.id,
    required this.vatId,
    required this.step,
    required this.sampledAt,
    this.moldId,
    this.receivedAt,
    this.moisturePct,
    this.acidityPh,
    this.labId,
  });

  final String id;
  final String vatId;
  final String? moldId;

  /// 该样品所代表的工步。
  final StepKind step;

  /// 取样时点。
  final DateTime sampledAt;

  /// 实验室接收时点（用于时延检查）。
  final DateTime? receivedAt;

  /// 水分（%）与酸度（pH）——实验室录入的测量结果。
  final double? moisturePct;
  final double? acidityPh;
  final String? labId;
}
