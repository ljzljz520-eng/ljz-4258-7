import 'package:cheese_trace/app_scope.dart';
import 'package:cheese_trace/core/models/enums.dart';
import 'package:cheese_trace/core/models/mold.dart';
import 'package:cheese_trace/core/models/mold_turn.dart';
import 'package:cheese_trace/data/db/database.dart'
    show CheeseTraceDatabase;
import 'package:cheese_trace/data/demo_seed.dart';
import 'package:cheese_trace/data/trace_repository.dart';
import 'package:cheese_trace/ui/home_page.dart';
import 'package:cheese_trace/ui/turn/mold_turn_page.dart';
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

  Future<void> seedMolds(WidgetTester tester) => tester.runAsync(() async {
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
            MoldRecord(
                id: 'M2',
                batchId: 'B1',
                vatId: 'VAT-1',
                qrCode: 'QR-M2',
                weightG: 990,
                moldedAt: DateTime(2026, 9, 11, 10)),
          ],
        );
      });

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(AppScope(
      repository: repo,
      child: const MaterialApp(home: MoldTurnPage()),
    ));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump();
  }

  Future<void> teardownPage(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
  }

  testWidgets('主页提供翻模记录入口', (tester) async {
    await seed(tester);
    await tester.pumpWidget(AppScope(
      repository: repo,
      child: const MaterialApp(home: HomePage()),
    ));
    await tester.pump();

    expect(find.text('翻模记录'), findsOneWidget);
    await teardownPage(tester);
  });

  testWidgets('翻模落库：模具、位置、实际时刻、压板', (tester) async {
    await seed(tester);
    await seedMolds(tester);
    await pumpPage(tester);

    expect(find.text('记录第 1 轮翻模'), findsOneWidget);
    await tester.enterText(
        find.widgetWithText(TextField, '翻模后位置（架位/层位）'), 'RACK-3-层2');
    await tester.enterText(find.widgetWithText(TextField, '压板编号'), 'PL-1');
    await tester.tap(find.text('记录第 1 轮翻模'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump();

    final turns = await tester.runAsync(() => repo.turnsForMold('M1'));
    expect(turns, hasLength(1));
    expect(turns!.single.round, 1);
    expect(turns.single.position, 'RACK-3-层2');
    expect(turns.single.pressPlateId, 'PL-1');
    expect(turns.single.damage, TurnDamage.none);
    // 实际时刻与落库时刻接近（非补录）。
    expect(
        turns.single.recordedAt.difference(turns.single.turnedAt).inMinutes, 0);

    // 保存后留在本页，轮次递增为第 2 轮。
    expect(find.text('记录第 2 轮翻模'), findsOneWidget);
    await teardownPage(tester);
  });

  testWidgets('夜班补录：实际时刻按回填分钟前移', (tester) async {
    await seed(tester);
    await seedMolds(tester);
    await pumpPage(tester);

    await tester.enterText(
        find.widgetWithText(TextField, '翻模后位置（架位/层位）'), 'RACK-1');
    await tester.enterText(
        find.widgetWithText(TextField, '实际发生在多少分钟前（补录用，0 为此刻）'),
        '90');
    await tester.tap(find.text('记录第 1 轮翻模'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)));

    final turn = (await tester.runAsync(() => repo.turnsForMold('M1')))!.single;
    final delayMin =
        turn.recordedAt.difference(turn.turnedAt).inMinutes;
    expect(delayMin, greaterThanOrEqualTo(89));
    expect(delayMin, lessThanOrEqualTo(91));
    await teardownPage(tester);
  });

  testWidgets('裂成两件：翻模与第二件模具同事务落库', (tester) async {
    await seed(tester);
    await seedMolds(tester);
    await pumpPage(tester);

    await tester.enterText(
        find.widgetWithText(TextField, '翻模后位置（架位/层位）'), 'RACK-2');
    // 选择破损观察「裂成两件」。
    await tester.tap(find.text('无破损'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('裂成两件').last);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.enterText(
        find.widgetWithText(TextField, '第二件模具编号（裂件登记，可稍后补登）'),
        'M1-B');
    await tester.scrollUntilVisible(
      find.text('记录第 1 轮翻模'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('记录第 1 轮翻模'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)));

    final turns = await tester.runAsync(() => repo.turnsForMold('M1'));
    expect(turns!.single.damage, TurnDamage.splitInTwo);
    final piece = await tester.runAsync(() => repo.findMoldById('M1-B'));
    expect(piece, isNotNull);
    expect(piece!.splitFromMoldId, 'M1');
    expect(piece.splitAt, turns.single.turnedAt);
    expect(piece.isSplitPiece, isTrue);
    await teardownPage(tester);
  });

  testWidgets('漏翻模具在页面「人工处置」区可见', (tester) async {
    await seed(tester);
    await seedMolds(tester);
    // M1 翻到第 2 轮，M2 只翻第 1 轮 → M2 漏翻进入人工处置。
    await tester.runAsync(() async {
      await repo.recordTurn(_turn('T1', 'M1', 1));
      await repo.recordTurn(_turn('T2', 'M1', 2));
      await repo.recordTurn(_turn('T3', 'M2', 1));
    });
    await pumpPage(tester);

    await tester.scrollUntilVisible(
      find.text('本槽翻模检查发现（人工处置）'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    expect(find.text('本槽翻模检查发现（人工处置）'), findsOneWidget);
    expect(find.text('TURN_MISSED'), findsOneWidget);
    await teardownPage(tester);
  });
}

MoldTurn _turn(String id, String moldId, int round) => MoldTurn(
      id: id,
      moldId: moldId,
      vatId: 'VAT-1',
      round: round,
      position: 'RACK-$round',
      turnedAt: DateTime(2026, 9, 11, 11).add(Duration(hours: round)),
      recordedAt: DateTime(2026, 9, 11, 11).add(Duration(hours: round)),
    );
