import 'enums.dart';

/// 一条一致性检查发现（顺序、拆分合并、样品时延等）。
class Finding {
  const Finding({
    required this.code,
    required this.severity,
    required this.message,
    this.vatId,
    this.relatedIds = const {},
  });

  /// 稳定的机器可读码，如 `SEQ_OUT_OF_ORDER`。
  final String code;
  final Severity severity;
  final String message;

  /// 主要关联奶槽。
  final String? vatId;

  /// 关联实体 id（事件、模具、样品等），便于界面跳转。
  final Set<String> relatedIds;

  bool get isViolation => severity == Severity.violation;

  @override
  String toString() => '[${severity.label}] $code: $message';
}
