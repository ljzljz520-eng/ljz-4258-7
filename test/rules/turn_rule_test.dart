import 'package:cheese_trace/core/models/enums.dart';
import 'package:cheese_trace/core/models/mold.dart';
import 'package:cheese_trace/core/models/mold_turn.dart';
import 'package:cheese_trace/core/models/process_version.dart';
import 'package:cheese_trace/core/rules/rule.dart';
import 'package:cheese_trace/core/rules/turn_rule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TurnRule — 翻模轮次', () {
    final version = ProcessVersion(
      id: 'PV-1',
      name: '冻结版本A',
      frozenBy: 'cheesemaker-01',
      frozenAt: DateTime(2026, 9, 1),
      stepOrder: ProcessVersion.canonicalOrder,
      tolerances: const QaTolerances(
        maxTurnRecordDelay: Duration(minutes: 15),
      ),
    );

    MoldRecord mold(String id) => MoldRecord(
          id: id,
          batchId: 'B1',
          vatId: 'VAT-1',
          qrCode: 'QR-$id',
          moldedAt: DateTime(2026, 9, 11, 10),
        );

    MoldTurn turn(
      String id,
      String moldId,
      int round,
      String position,
      int hour,
      int minute, {
      int recordedDelayMin = 0,
      TurnDamage damage = TurnDamage.none,
      String? pressPlateId,
    }) =>
        MoldTurn(
          id: id,
          moldId: moldId,
          vatId: 'VAT-1',
          round: round,
          position: position,
          turnedAt: DateTime(2026, 9, 11, hour, minute),
          recordedAt: DateTime(2026, 9, 11, hour, minute)
              .add(Duration(minutes: recordedDelayMin)),
          damage: damage,
          pressPlateId: pressPlateId,
        );

    test('正常翻模 → 无发现', () {
      final ctx = TraceContext(version: version, molds: [mold('M1')], turns: [
        turn('T1', 'M1', 1, 'R1-A', 11, 0, pressPlateId: 'PL-1'),
        turn('T2', 'M1', 2, 'R1-B', 12, 0, pressPlateId: 'PL-1'),
      ]);
      expect(const TurnRule().check(ctx), isEmpty);
    });

    test('漏翻 → 单模独立进入人工处置，不影响其他模具', () {
      final ctx = TraceContext(
        version: version,
        molds: [mold('M1'), mold('M2'), mold('M3')],
        turns: [
          turn('T1', 'M1', 1, 'R1-A', 11, 0),
          turn('T2', 'M1', 2, 'R1-B', 12, 0),
          turn('T3', 'M2', 1, 'R2-A', 11, 2),
          turn('T4', 'M2', 2, 'R2-B', 12, 2),
          // M3 只翻了第 1 轮，漏翻第 2 轮。
          turn('T5', 'M3', 1, 'R3-A', 11, 5),
        ],
      );
      final findings = const TurnRule().check(ctx);
      final missed = findings.where((f) => f.code == 'TURN_MISSED').toList();
      expect(missed, hasLength(1));
      expect(missed.single.severity, Severity.warning);
      // 只关联漏翻的 M3，不波及其他模具。
      expect(missed.single.relatedIds, {'M3'});
      expect(missed.single.message, contains('人工处置'));
      expect(findings.where((f) => f.relatedIds.contains('M1')), isEmpty);
      expect(findings.where((f) => f.relatedIds.contains('M2')), isEmpty);
    });

    test('整轮未翻的原始模具同样进入人工处置；换模模具不追究进入前轮次', () {
      final ctx = TraceContext(
        version: version,
        molds: [
          mold('M1'),
          mold('M2'),
          MoldRecord(
            id: 'M9',
            batchId: 'B1',
            vatId: 'VAT-1',
            qrCode: 'QR-M9',
            remoldedFromId: 'M1',
            remoldedAt: DateTime(2026, 9, 11, 12, 30),
          ),
        ],
        turns: [
          turn('T1', 'M1', 1, 'R1-A', 11, 0),
          turn('T2', 'M1', 2, 'R1-B', 12, 0),
          // M2 从未翻模；M9 是换模新模，尚未进入翻模流程。
        ],
      );
      final findings = const TurnRule().check(ctx);
      final missed = findings.where((f) => f.code == 'TURN_MISSED').toList();
      // M2 缺第 1、2 轮 → 两条发现；M9 不被追究。
      expect(missed.map((f) => f.relatedIds.single).toSet(), {'M2'});
      expect(missed, hasLength(2));
    });

    test('夜班补录 → 落库晚于实际时刻超容差报警', () {
      final ctx = TraceContext(version: version, molds: [mold('M1')], turns: [
        // 23:40 实际翻面，次日 02:10 才补录（150 分钟 > 15 分钟容差）。
        MoldTurn(
          id: 'T1',
          moldId: 'M1',
          vatId: 'VAT-1',
          round: 1,
          position: 'R1-A',
          turnedAt: DateTime(2026, 9, 11, 23, 40),
          recordedAt: DateTime(2026, 9, 12, 2, 10),
        ),
      ]);
      final findings = const TurnRule().check(ctx);
      expect(findings, hasLength(1));
      expect(findings.single.code, 'TURN_LATE_RECORD');
      expect(findings.single.severity, Severity.warning);
      expect(findings.single.message, contains('150 分钟'));
    });

    test('容差未录入 → 补录不检查', () {
      final noTolerance = ProcessVersion(
        id: 'PV-2',
        name: '冻结版本B',
        frozenBy: 'cheesemaker-01',
        frozenAt: DateTime(2026, 9, 1),
        stepOrder: ProcessVersion.canonicalOrder,
      );
      final ctx = TraceContext(version: noTolerance, molds: [mold('M1')], turns: [
        MoldTurn(
          id: 'T1',
          moldId: 'M1',
          vatId: 'VAT-1',
          round: 1,
          position: 'R1-A',
          turnedAt: DateTime(2026, 9, 11, 23, 40),
          recordedAt: DateTime(2026, 9, 12, 2, 10),
        ),
      ]);
      expect(const TurnRule().check(ctx), isEmpty);
    });

    test('两模内容交换 → 位置交叉互换报警', () {
      final ctx = TraceContext(
        version: version,
        molds: [mold('M1'), mold('M2')],
        turns: [
          turn('T1', 'M1', 1, 'R1-A', 11, 0),
          turn('T2', 'M2', 1, 'R2-A', 11, 0),
          // 第 2 轮：M1 出现在 M2 的位置，M2 出现在 M1 的位置。
          turn('T3', 'M1', 2, 'R2-A', 12, 0),
          turn('T4', 'M2', 2, 'R1-A', 12, 0),
        ],
      );
      final findings = const TurnRule().check(ctx);
      final swap = findings.where((f) => f.code == 'TURN_CONTENT_SWAP').toList();
      expect(swap, hasLength(1));
      expect(swap.single.severity, Severity.warning);
      expect(swap.single.relatedIds, containsAll({'M1', 'M2'}));
    });

    test('翻模时标签遮住 → 身份需人工核对', () {
      final ctx = TraceContext(version: version, molds: [mold('M1')], turns: [
        turn('T1', 'M1', 1, 'R1-A', 11, 0, damage: TurnDamage.labelCovered),
      ]);
      final findings = const TurnRule().check(ctx);
      expect(findings, hasLength(1));
      expect(findings.single.code, 'TURN_LABEL_COVERED');
      expect(findings.single.severity, Severity.warning);
      expect(findings.single.relatedIds, containsAll({'M1', 'T1'}));
    });

    test('裂成两件未登记 → 报警；登记第二件 → 信息留痕', () {
      final pendingCtx = TraceContext(
        version: version,
        molds: [mold('M1')],
        turns: [
          turn('T1', 'M1', 1, 'R1-A', 11, 0, damage: TurnDamage.splitInTwo),
        ],
      );
      final pending = const TurnRule().check(pendingCtx);
      expect(pending, hasLength(1));
      expect(pending.single.code, 'TURN_SPLIT_PENDING');
      expect(pending.single.severity, Severity.warning);

      final registeredCtx = TraceContext(
        version: version,
        molds: [
          mold('M1'),
          MoldRecord(
            id: 'M1-B',
            batchId: 'B1',
            vatId: 'VAT-1',
            qrCode: 'QR-M1-B',
            splitFromMoldId: 'M1',
            splitAt: DateTime(2026, 9, 11, 11, 0),
          ),
        ],
        turns: [
          turn('T1', 'M1', 1, 'R1-A', 11, 0, damage: TurnDamage.splitInTwo),
        ],
      );
      final registered = const TurnRule().check(registeredCtx);
      expect(registered.any((f) => f.code == 'TURN_SPLIT_PENDING'), isFalse);
      final info =
          registered.singleWhere((f) => f.code == 'TURN_SPLIT_REGISTERED');
      expect(info.severity, Severity.info);
      expect(info.relatedIds, containsAll({'M1', 'M1-B'}));
    });

    test('翻模后改用不同压板 → 信息留痕', () {
      final ctx = TraceContext(version: version, molds: [mold('M1')], turns: [
        turn('T1', 'M1', 1, 'R1-A', 11, 0, pressPlateId: 'PL-1'),
        turn('T2', 'M1', 2, 'R1-B', 12, 0, pressPlateId: 'PL-2'),
      ]);
      final findings = const TurnRule().check(ctx);
      expect(findings, hasLength(1));
      expect(findings.single.code, 'TURN_PLATE_CHANGED');
      expect(findings.single.severity, Severity.info);
      expect(findings.single.message, contains('PL-1'));
      expect(findings.single.message, contains('PL-2'));
    });
  });
}
