import 'package:cheese_trace/core/models/action_event.dart';
import 'package:cheese_trace/core/models/enums.dart';
import 'package:cheese_trace/core/models/lab_sample.dart';
import 'package:cheese_trace/core/models/process_version.dart';
import 'package:cheese_trace/core/rules/rule.dart';
import 'package:cheese_trace/core/rules/sample_delay_rule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SampleDelayRule — 样品时延与关联', () {
    final version = ProcessVersion(
      id: 'PV-1',
      name: '冻结版本A',
      frozenBy: 'cheesemaker-01',
      frozenAt: DateTime(2026, 9, 1),
      stepOrder: ProcessVersion.canonicalOrder,
      tolerances: const QaTolerances(maxSampleDelay: Duration(minutes: 30)),
    );

    ActionEvent ev(StepKind step, int minute) => ActionEvent(
          id: 'e-${step.name}',
          vatId: 'VAT-1',
          step: step,
          performedAt: DateTime(2026, 9, 11, 8, minute),
          operatorId: 'op-1',
          processVersionId: 'PV-1',
        );

    test('送检时延超 30 分钟 → 警告', () {
      final ctx = TraceContext(
        version: version,
        events: [ev(StepKind.stirring, 30)],
        samples: [
          LabSample(
            id: 'S1',
            vatId: 'VAT-1',
            step: StepKind.stirring,
            sampledAt: DateTime(2026, 9, 11, 8, 35),
            receivedAt: DateTime(2026, 9, 11, 9, 30), // 55 分钟后
            moisturePct: 46.2,
            acidityPh: 5.1,
          ),
        ],
      );
      final findings = const SampleDelayRule().check(ctx);
      expect(findings.any((f) => f.code == 'LAB_SAMPLE_DELAYED'), isTrue);
    });

    test('样品关联的工步无动作记录 → 孤儿样品警告', () {
      final ctx = TraceContext(
        version: version,
        events: [ev(StepKind.curdling, 0)],
        samples: [
          LabSample(
            id: 'S2',
            vatId: 'VAT-1',
            step: StepKind.pressing, // 无压制记录
            sampledAt: DateTime(2026, 9, 11, 12),
            receivedAt: DateTime(2026, 9, 11, 12, 10),
          ),
        ],
      );
      final findings = const SampleDelayRule().check(ctx);
      expect(findings.any((f) => f.code == 'LAB_SAMPLE_ORPHAN'), isTrue);
    });

    test('时延内且工步存在 → 无发现', () {
      final ctx = TraceContext(
        version: version,
        events: [ev(StepKind.stirring, 30)],
        samples: [
          LabSample(
            id: 'S3',
            vatId: 'VAT-1',
            step: StepKind.stirring,
            sampledAt: DateTime(2026, 9, 11, 8, 35),
            receivedAt: DateTime(2026, 9, 11, 8, 50),
            moisturePct: 45.8,
          ),
        ],
      );
      expect(const SampleDelayRule().check(ctx), isEmpty);
    });
  });
}
