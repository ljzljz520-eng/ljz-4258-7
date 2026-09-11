import 'package:cheese_trace/core/models/action_event.dart';
import 'package:cheese_trace/core/models/curd_photo.dart';
import 'package:cheese_trace/core/models/enums.dart';
import 'package:cheese_trace/core/models/lab_sample.dart';
import 'package:cheese_trace/core/models/mold.dart';
import 'package:cheese_trace/core/models/process_version.dart';
import 'package:cheese_trace/core/models/whey.dart';
import 'package:cheese_trace/data/db/database.dart'
    show CheeseTraceDatabase;
import 'package:cheese_trace/data/trace_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CheeseTraceDatabase db;
  late TraceRepository repo;

  setUp(() async {
    db = CheeseTraceDatabase.forTesting(NativeDatabase.memory());
    repo = TraceRepository(db);
    await repo.freezeVersion(ProcessVersion(
      id: 'PV-1',
      name: '冻结版本A',
      frozenBy: 'cheesemaker-01',
      frozenAt: DateTime(2026, 9, 1),
      stepOrder: ProcessVersion.canonicalOrder,
      tolerances: const QaTolerances(
        maxGrainSizeDiffMm: 2.0,
        maxMoldWeightSpreadPct: 5.0,
        maxSampleDelay: Duration(minutes: 30),
      ),
    ));
    await repo.addVat('VAT-1', '1号槽', 'QR-VAT-1');
    await repo.addVat('VAT-2', '2号槽', 'QR-VAT-2');
    await repo.addWheyTank('TANK-A', '乳清罐A', 'QR-TANK-A');
  });

  tearDown(() => db.close());

  ActionEvent ev(String id, String vat, StepKind step, int minute) =>
      ActionEvent(
        id: id,
        vatId: vat,
        step: step,
        performedAt: DateTime(2026, 9, 11, 8, minute),
        operatorId: 'op-1',
        processVersionId: 'PV-1',
      );

  test('动作记录落库并可按时间轴读回', () async {
    await repo.recordAction(ev('e1', 'VAT-1', StepKind.curdling, 0));
    await repo.recordAction(ev('e2', 'VAT-1', StepKind.cutting, 20));
    final events = await repo.eventsForVat('VAT-1');
    expect(events.map((e) => e.step),
        [StepKind.curdling, StepKind.cutting]);
  });

  test('端到端：晚按切割 + 混批 + 重量不平 + 压制后换模 + 样品超时', () async {
    // 切割晚按（搅拌先于切割）。
    await repo.recordAction(ev('e1', 'VAT-1', StepKind.curdling, 0));
    await repo.recordAction(ev('e2', 'VAT-1', StepKind.stirring, 30));
    await repo.recordAction(ev('e3', 'VAT-1', StepKind.cutting, 35));

    // 乳清混批：两槽入同一罐。
    await repo.recordTransfer(WheyTransfer(
        id: 't1',
        vatId: 'VAT-1',
        tankId: 'TANK-A',
        transferredAt: DateTime(2026, 9, 11, 9)));
    await repo.recordTransfer(WheyTransfer(
        id: 't2',
        vatId: 'VAT-2',
        tankId: 'TANK-A',
        transferredAt: DateTime(2026, 9, 11, 9, 5)));

    // 模具重量不平 + 压制后换模。
    final pressed = DateTime(2026, 9, 11, 14);
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
            moldedAt: DateTime(2026, 9, 11, 10),
            pressedAt: pressed),
        MoldRecord(
            id: 'M2',
            batchId: 'B1',
            vatId: 'VAT-1',
            qrCode: 'QR-M2',
            weightG: 850,
            moldedAt: DateTime(2026, 9, 11, 10)),
      ],
    );
    await repo.remold(MoldRecord(
      id: 'M3',
      batchId: 'B1',
      vatId: 'VAT-1',
      qrCode: 'QR-M3',
      remoldedFromId: 'M1',
      remoldedAt: pressed.add(const Duration(hours: 1)),
    ));

    // 槽底粒径偏大。
    await repo.recordPhoto(CurdPhoto(
        id: 'P1',
        vatId: 'VAT-1',
        zone: VatZone.top,
        takenAt: DateTime(2026, 9, 11, 8, 25),
        filePath: '/x/p1.jpg',
        standardBackground: true,
        grainSizeMm: 8));
    await repo.recordPhoto(CurdPhoto(
        id: 'P2',
        vatId: 'VAT-1',
        zone: VatZone.bottom,
        takenAt: DateTime(2026, 9, 11, 8, 26),
        filePath: '/x/p2.jpg',
        standardBackground: true,
        grainSizeMm: 12));

    // 样品超时。
    await repo.recordSample(LabSample(
      id: 'S1',
      vatId: 'VAT-1',
      step: StepKind.stirring,
      sampledAt: DateTime(2026, 9, 11, 8, 35),
      receivedAt: DateTime(2026, 9, 11, 9, 30),
      moisturePct: 46.1,
      acidityPh: 5.2,
    ));

    // 单槽检查：顺序 + 粒度 + 重量 + 换模 + 时延 + 混批
    // （本槽所用乳清罐的全部来源都会纳入上下文）。
    final vatFindings = await repo.checkVat('VAT-1');
    final codes = vatFindings.map((f) => f.code).toSet();
    expect(codes, containsAll({
      'SEQ_OUT_OF_ORDER',
      'GRAIN_ZONE_UNEVEN',
      'MOLD_WEIGHT_UNEVEN',
      'REMOLD_AFTER_PRESS',
      'LAB_SAMPLE_DELAYED',
      'WHEY_TANK_MIXED',
    }));
    // 整库版本级检查同样发现混批。
    final allFindings = await repo.checkVersion('PV-1');
    expect(allFindings.any((f) => f.code == 'WHEY_TANK_MIXED'), isTrue);
  });

  test('二维码反查三种对象', () async {
    expect((await repo.findVatByQr('QR-VAT-1'))?.id, 'VAT-1');
    expect((await repo.findTankByQr('QR-TANK-A'))?.id, 'TANK-A');
    await repo.recordMold(const MoldRecord(
        id: 'M9', batchId: 'B9', vatId: 'VAT-1', qrCode: 'QR-M9'));
    expect((await repo.findMoldByQr('QR-M9'))?.id, 'M9');
  });
}
