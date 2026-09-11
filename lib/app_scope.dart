import 'package:flutter/widgets.dart';

import 'data/trace_repository.dart';

/// 向全树提供 [TraceRepository] 的轻量作用域。
class AppScope extends InheritedWidget {
  const AppScope({super.key, required this.repository, required super.child});

  final TraceRepository repository;

  static TraceRepository repoOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<AppScope>()!
      .repository;

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      repository != oldWidget.repository;
}
