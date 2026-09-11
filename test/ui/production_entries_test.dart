import 'package:cheese_trace/app_scope.dart';
import 'package:cheese_trace/core/models/enums.dart';
import 'package:cheese_trace/core/models/mold.dart';
import 'package:cheese_trace/data/db/database.dart'
    show CheeseTraceDatabase;
import 'package:cheese_trace/data/demo_seed.dart';
import 'package:cheese_trace/data/trace_repository.dart';
import 'package:cheese_trace/ui/home_page.dart';
import 'package:cheese_trace/ui/lab/lab_sample_page.dart';
import 'package:cheese_trace/ui/mold/remold_page.dart';
import 'package:cheese_trace/ui/scan/qr_scan_page.dart';
import 'package:cheese_trace/ui/whey/whey_transfer_page.dart';
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

  Future<void> seed(WidgetTester tester) =>
      tester.runAsync(() => seedDemoIfEmpty(repo));

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  Future<void> teardownPage(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
  }

  testWidgets('主页提供实验室/乳清/换模生产入口', (tester) async {
    await seed(tester);
    await tester.pumpWidget(AppScope(
      repository: repo,
      child: const MaterialApp(home: HomePage()),
    ));
    await tester.pump();

    expect(find.text('乳清转移'), findsOneWidget);
    expect(find.text('实验室样品'), findsOneWidget);
    expect(find.text('换模记录'), findsOneWidget);

    // 入口可进入对应页面。
    await tester.tap(find.text('乳清转移'));
    await settle(tester);
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump();
    expect(find.text('乳清转移记录'), findsOneWidget);

    await teardownPage(tester);
  });

  testWidgets('乳清转移页落库 奶槽→乳清罐 去向记录', (tester) async {
    await seed(tester);
    await tester.pumpWidget(AppScope(
      repository: repo,
      child: const MaterialApp(home: WheyTransferPage()),
    ));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump();

    await tester.enterText(find.widgetWithText(TextField, '转移量 (L)'), '120');
    await tester.tap(find.text('记录乳清去向'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)));

    final rows =
        (await tester.runAsync(() => db.select(db.wheyTransfers).get()))!;
    expect(rows, hasLength(1));
    expect(rows.single.vatId, 'VAT-1');
    expect(rows.single.tankId, 'TANK-A');
    expect(rows.single.amountL, 120);

    await teardownPage(tester);
  });

  testWidgets('实验室样品页落库水分/酸度并关联工步', (tester) async {
    await seed(tester);
    await tester.pumpWidget(AppScope(
      repository: repo,
      child: const MaterialApp(home: LabSamplePage()),
    ));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump();

    // 选择关联工步「搅拌」。
    await tester.tap(find.byType(DropdownButtonFormField<StepKind>));
    await settle(tester);
    await tester.tap(find.text('搅拌').last);
    await settle(tester);

    await tester.enterText(find.widgetWithText(TextField, '水分 (%)'), '46.1');
    await tester.enterText(find.widgetWithText(TextField, '酸度 (pH)'), '5.2');
    await tester.tap(find.text('已送检（记录送检时点）'));
    await tester.pump();
    await tester.tap(find.text('记录样品'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)));

    final rows =
        (await tester.runAsync(() => db.select(db.labSamples).get()))!;
    expect(rows, hasLength(1));
    final s = rows.single;
    expect(s.vatId, 'VAT-1');
    expect(s.step, StepKind.stirring);
    expect(s.moisturePct, 46.1);
    expect(s.acidityPh, 5.2);
    expect(s.receivedAt, isNotNull);

    await teardownPage(tester);
  });

  testWidgets('换模页落库新模具并挂接换模链', (tester) async {
    await tester.runAsync(() async {
      await seedDemoIfEmpty(repo);
      await repo.splitIntoMolds(
        batchId: 'B1',
        batchCode: '批B1',
        vatId: 'VAT-1',
        createdAt: DateTime(2026, 9, 11, 10),
        molds: [
          MoldRecord(
              id: 'M1',
              batchId: 'B1',
              vatId: 'VAT-1',
              qrCode: 'QR-M1',
              weightG: 1000,
              moldedAt: DateTime(2026, 9, 11, 10)),
        ],
      );
    });
    await tester.pumpWidget(AppScope(
      repository: repo,
      child: const MaterialApp(home: RemoldPage()),
    ));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump();

    await tester.enterText(find.widgetWithText(TextField, '新模具编号'), 'M1-R');
    await tester.tap(find.text('记录换模'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)));

    final mold = (await tester.runAsync(() => repo.findMoldById('M1-R')))!;
    expect(mold.remoldedFromId, 'M1');
    expect(mold.remoldedAt, isNotNull);
    expect(mold.batchId, 'B1'); // 换模不换批
    expect(mold.vatId, 'VAT-1');
    expect(mold.qrCode, 'QR-M1-R'); // 留空自动生成

    await teardownPage(tester);
  });

  testWidgets('扫码识别乳清罐后形成 奶槽→罐 实际关联', (tester) async {
    await seed(tester);
    await tester.pumpWidget(AppScope(
      repository: repo,
      child: const MaterialApp(home: HomePage()),
    ));
    await tester.pump();

    // 模拟扫码页返回「乳清罐B」。
    final context = tester.element(find.byType(HomePage));
    await tester.runAsync(() => handleScanResult(
        context,
        const QrScanResult(
            code: 'QR-TANK-B',
            kind: QrTargetKind.wheyTank,
            targetId: 'TANK-B',
            label: '乳清罐B')));
    await settle(tester);
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump();

    // 进入乳清转移页且预选被扫的罐 B。
    expect(find.text('乳清转移记录'), findsOneWidget);
    await tester.tap(find.text('记录乳清去向'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)));

    final rows =
        (await tester.runAsync(() => db.select(db.wheyTransfers).get()))!;
    expect(rows, hasLength(1));
    expect(rows.single.vatId, 'VAT-1');
    expect(rows.single.tankId, 'TANK-B');

    await teardownPage(tester);
  });

  testWidgets('扫码识别奶槽后打开其凝乳时间轴', (tester) async {
    await seed(tester);
    await tester.pumpWidget(AppScope(
      repository: repo,
      child: const MaterialApp(home: HomePage()),
    ));
    await tester.pump();

    final context = tester.element(find.byType(HomePage));
    await tester.runAsync(() => handleScanResult(
        context,
        const QrScanResult(
            code: 'QR-VAT-1',
            kind: QrTargetKind.vat,
            targetId: 'VAT-1',
            label: '1号凝乳槽')));
    await settle(tester);
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump();

    expect(find.text('1号凝乳槽 · 凝乳时间轴'), findsOneWidget);

    await teardownPage(tester);
  });

  testWidgets('扫码识别模具后展示详情并可跳转换模', (tester) async {
    await tester.runAsync(() async {
      await seedDemoIfEmpty(repo);
      await repo.splitIntoMolds(
        batchId: 'B1',
        batchCode: '批B1',
        vatId: 'VAT-1',
        createdAt: DateTime(2026, 9, 11, 10),
        molds: [
          MoldRecord(
              id: 'M1',
              batchId: 'B1',
              vatId: 'VAT-1',
              qrCode: 'QR-M1',
              weightG: 1000,
              moldedAt: DateTime(2026, 9, 11, 10)),
        ],
      );
    });
    await tester.pumpWidget(AppScope(
      repository: repo,
      child: const MaterialApp(home: HomePage()),
    ));
    await tester.pump();

    final context = tester.element(find.byType(HomePage));
    await tester.runAsync(() => handleScanResult(
        context,
        const QrScanResult(
            code: 'QR-M1',
            kind: QrTargetKind.mold,
            targetId: 'M1',
            label: 'M1')));
    await settle(tester);

    // 模具详情底部表单。
    expect(find.text('模具 M1'), findsOneWidget);
    expect(find.textContaining('模具批 B1'), findsOneWidget);

    // 跳转换模页并预选原模具（主页按钮同名，故按页面类型断言）。
    await tester.tap(find.text('记录换模'));
    await settle(tester);
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump();
    expect(find.byType(RemoldPage), findsOneWidget);

    await teardownPage(tester);
  });
}
