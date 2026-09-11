/// 乳清去向：某奶槽向某乳清罐的一次转移。
class WheyTransfer {
  const WheyTransfer({
    required this.id,
    required this.vatId,
    required this.tankId,
    required this.transferredAt,
    this.amountL,
  });

  final String id;
  final String vatId;
  final String tankId;
  final DateTime transferredAt;
  final double? amountL;
}

/// 乳清罐（二维码绑定）。
class WheyTank {
  const WheyTank({required this.id, required this.code, required this.qrCode});

  final String id;
  final String code;
  final String qrCode;
}
