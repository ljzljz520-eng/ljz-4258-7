import 'package:cheese_trace/app_scope.dart';
import 'package:cheese_trace/data/db/database.dart'
    show CheeseTraceDatabase;
import 'package:cheese_trace/data/demo_seed.dart';
import 'package:cheese_trace/data/trace_repository.dart';
import 'package:cheese_trace/ui/home_page.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('主页展示奶槽列表与工位入口', (tester) async {
    final db = CheeseTraceDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = TraceRepository(db);
    // Drift 的真实异步操作放在 runAsync 中，避免 FakeAsync 区内挂起。
    await tester.runAsync(() => seedDemoIfEmpty(repo));

    await tester.pumpWidget(AppScope(
      repository: repo,
      child: const MaterialApp(home: HomePage()),
    ));
    await tester.pump();
    await tester.pump();

    expect(find.text('奶酪制作追溯'), findsOneWidget);
    expect(find.textContaining('1号凝乳槽'), findsOneWidget);
    expect(find.text('扫码绑定'), findsOneWidget);
    expect(find.text('模具拆分'), findsOneWidget);
    expect(find.text('凝乳拍照'), findsOneWidget);

    // 卸载树并触发 Drift 流关闭时排队的零时长定时器
    // （pump 需带时长才会推进 FakeAsync 时钟）。
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
  });
}
