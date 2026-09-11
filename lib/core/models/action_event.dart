import 'enums.dart';

/// 操作员已实施的手工动作，带可追溯时点。
class ActionEvent {
  const ActionEvent({
    required this.id,
    required this.vatId,
    required this.step,
    required this.performedAt,
    required this.operatorId,
    required this.processVersionId,
    this.temperatureC,
    this.visualState,
    this.cutSizeMm,
    this.zone,
    this.note,
  });

  final String id;
  final String vatId;
  final StepKind step;

  /// 动作实际发生的时点（手工按钮按下时刻，可追溯）。
  final DateTime performedAt;
  final String operatorId;

  /// 记录时冻结的工艺版本 id。
  final String processVersionId;

  /// 实测温度（记录值，非工艺参数）。
  final double? temperatureC;
  final VisualState? visualState;

  /// 切块尺寸（mm，记录值）。
  final double? cutSizeMm;

  /// 观察/取样所在槽内位置。
  final VatZone? zone;
  final String? note;

  ActionEvent copyWith({DateTime? performedAt}) => ActionEvent(
        id: id,
        vatId: vatId,
        step: step,
        performedAt: performedAt ?? this.performedAt,
        operatorId: operatorId,
        processVersionId: processVersionId,
        temperatureC: temperatureC,
        visualState: visualState,
        cutSizeMm: cutSizeMm,
        zone: zone,
        note: note,
      );
}
