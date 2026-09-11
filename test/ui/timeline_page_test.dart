import 'package:cheese_trace/app_scope.dart';
import 'package:cheese_trace/core/models/action_event.dart';
import 'package:cheese_trace/core/models/enums.dart';
import 'package:cheese_trace/data/db/database.dart'
    show CheeseTraceDatabase;
import 'package:cheese_trace/data/demo_seed.dart';
import 'package:cheese_trace/data/trace_repository.dart';
import 'package:cheese_trace/ui/timeline/curd_timeline_page.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CheeseTraceDatabase db;
  late TraceRepository repo;

  setUp(() {
    db = CheeseTraceDatabase.forTesting(NativeDatabase.memory());
    repo = TraceRepository(db);
  });
  tearDown(() => db.close());

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.runAsync(() => seedDemoIfEmpty(repo));
    await tester.pumpWidget(AppScope(
      repository: repo,
      child: const MaterialApp(
          home: CurdTimelinePage(vatId: 'VAT-1', vatCode: '1号凝乳槽')),
    ));
    await tester.pump();
  }

  Future<void> teardownPage(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
  }

  /// 工步按钮先经真实异步读取冻结版本再弹观测对话框，
  /// 需 runAsync 让 Drift 操作完成（FakeAsync 区限制）。
  Future<void> tapStepAndWaitDialog(WidgetTester tester, String label) async {
    await tester.tap(find.text(label));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('时间轴渲染已实施动作（时点/温度/目视状态）', (tester) async {
    await tester.runAsync(() async {
      await seedDemoIfEmpty(repo);
      await repo.recordAction(ActionEvent(
        id: 'EV-1',
        vatId: 'VAT-1',
        step: StepKind.curdling,
        performedAt: DateTime(2026, 9, 11, 7, 40),
        operatorId: 'op-1',
        processVersionId: 'PV-DEMO',
        temperatureC: 32.5,
        visualState: VisualState.normal,
      ));
    });
    await tester.pumpWidget(AppScope(
      repository: repo,
      child: const MaterialApp(
          home: CurdTimelinePage(vatId: 'VAT-1', vatCode: '1号凝乳槽')),
    ));
    await tester.pump();
    await tester.pump();

    // 初始流发射后渲染出动作条目。
    expect(find.text('凝乳'), findsWidgets);
    expect(find.textContaining('07:40:00'), findsOneWidget);
    expect(find.textContaining('32.5℃'), findsOneWidget);
    expect(find.textContaining('正常'), findsOneWidget);

    await teardownPage(tester);
  });

  testWidgets('按下工步按钮弹出观测对话框，「直接记录」落库一条可追溯动作',
      (tester) async {
    await pumpPage(tester);
    expect(find.text('尚无动作记录，请从上方工步开始'), findsOneWidget);

    await tapStepAndWaitDialog(tester, '凝乳');
    expect(find.text('记录 · 凝乳'), findsOneWidget);

    await tester.tap(find.text('直接记录'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)));

    // 注：Drift 流更新在 testWidgets 的 FakeAsync 区内投递不可靠
    // （drift 官方建议见 StreamQueryStore.markAsClosed 注释），
    // 因此这里直接验证落库结果而非界面刷新。
    final events =
        (await tester.runAsync(() => repo.eventsForVat('VAT-1')))!;
    expect(events, hasLength(1));
    expect(events.single.step, StepKind.curdling);
    expect(events.single.vatId, 'VAT-1');
    expect(events.single.processVersionId, 'PV-DEMO');

    await teardownPage(tester);
  });

  testWidgets('工步按钮可录入操作员工艺观测（温度/目视/位置/切块/备注）', (tester) async {
    await pumpPage(tester);

    await tapStepAndWaitDialog(tester, '切割');
    expect(find.text('记录 · 切割'), findsOneWidget);

    // 温度与切块尺寸（切块尺寸为切割工步专属字段）。
    await tester.enterText(
        find.widgetWithText(TextField, '实测温度 (℃)'), '31.5');
    await tester.enterText(
        find.widgetWithText(TextField, '切块尺寸 (mm)'), '25');
    await tester.enterText(find.widgetWithText(TextField, '备注'), '粒偏硬');

    // 目视状态。
    await tester.tap(find.byType(DropdownButtonFormField<VisualState>));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('粒度不均').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // 槽内位置。
    await tester.tap(find.byType(DropdownButtonFormField<VatZone>));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('槽底').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('记录观测'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)));

    final events =
        (await tester.runAsync(() => repo.eventsForVat('VAT-1')))!;
    expect(events, hasLength(1));
    final e = events.single;
    expect(e.step, StepKind.cutting);
    expect(e.temperatureC, 31.5);
    expect(e.cutSizeMm, 25);
    expect(e.visualState, VisualState.grainsUneven);
    expect(e.zone, VatZone.bottom);
    expect(e.note, '粒偏硬');

    await teardownPage(tester);
  });

  testWidgets('观测对话框「取消」不落库', (tester) async {
    await pumpPage(tester);

    await tapStepAndWaitDialog(tester, '搅拌');
    await tester.tap(find.text('取消'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)));

    final events =
        (await tester.runAsync(() => repo.eventsForVat('VAT-1')))!;
    expect(events, isEmpty);

    await teardownPage(tester);
  });
}
