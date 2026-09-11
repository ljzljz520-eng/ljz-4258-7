/// 模具记录：一个奶槽拆分为若干模具（模具批）。
class MoldRecord {
  const MoldRecord({
    required this.id,
    required this.batchId,
    required this.vatId,
    required this.qrCode,
    this.weightG,
    this.moldedAt,
    this.pressedAt,
    this.remoldedFromId,
    this.remoldedAt,
  });

  final String id;
  final String batchId;
  final String vatId;
  final String qrCode;

  /// 入模时称得重量（g）。
  final double? weightG;
  final DateTime? moldedAt;
  final DateTime? pressedAt;

  /// 若本模具是「换模」而来，指向原模具。
  final String? remoldedFromId;
  final DateTime? remoldedAt;

  bool get isRemold => remoldedFromId != null;

  MoldRecord copyWith({
    double? weightG,
    DateTime? moldedAt,
    DateTime? pressedAt,
    String? remoldedFromId,
    DateTime? remoldedAt,
  }) =>
      MoldRecord(
        id: id,
        batchId: batchId,
        vatId: vatId,
        qrCode: qrCode,
        weightG: weightG ?? this.weightG,
        moldedAt: moldedAt ?? this.moldedAt,
        pressedAt: pressedAt ?? this.pressedAt,
        remoldedFromId: remoldedFromId ?? this.remoldedFromId,
        remoldedAt: remoldedAt ?? this.remoldedAt,
      );
}
