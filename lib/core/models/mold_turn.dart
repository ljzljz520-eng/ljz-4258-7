import 'enums.dart';

/// 翻模记录：一轮一次翻面，记录模具、位置、实际时刻与破损观察。
///
/// [turnedAt] 是翻面实际发生的时刻（操作员可补录过去时刻）；
/// [recordedAt] 是记录落库时刻。两者之差用于识别夜班补录。
class MoldTurn {
  const MoldTurn({
    required this.id,
    required this.moldId,
    required this.vatId,
    required this.round,
    required this.position,
    required this.turnedAt,
    required this.recordedAt,
    this.damage = TurnDamage.none,
    this.pressPlateId,
    this.note,
  });

  final String id;
  final String moldId;
  final String vatId;

  /// 翻模轮次（从 1 开始，每模独立计数）。
  final int round;

  /// 翻模后所在位置（架位/层位，自由文本）。
  final String position;

  /// 翻面实际发生时刻。
  final DateTime turnedAt;

  /// 记录落库时刻（补录时晚于 [turnedAt]）。
  final DateTime recordedAt;

  /// 破损/异常观察。
  final TurnDamage damage;

  /// 本次翻面后使用的压板编号（可空；相邻轮次变化即留痕）。
  final String? pressPlateId;

  final String? note;
}
