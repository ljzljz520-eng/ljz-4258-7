import 'package:cheese_trace/core/models/action_event.dart';
import 'package:cheese_trace/core/models/enums.dart';
import 'package:cheese_trace/core/models/process_version.dart';
import 'package:cheese_trace/core/rules/rule.dart';
import 'package:cheese_trace/core/rules/sequence_rule.dart';
import 'package:flutter_test/flutter_test.dart';

ProcessVersion _version() => ProcessVersion(
      id: 'PV-1',
      name: '冻结版本A',
      frozenBy: 'cheesemaker-01',
      frozenAt: DateTime(2026, 9, 1),
      stepOrder: ProcessVersion.canonicalOrder,
    );

ActionEvent _ev(String id, StepKind step, int minute) => ActionEvent(
      id: id,
      vatId: 'VAT-1',
      step: step,
      performedAt: DateTime(2026, 9, 11, 8, minute),
      operatorId: 'op-1',
      processVersionId: 'PV-1',
    );

void main() {
  group('SequenceRule — 切割按钮晚按', () {
    test('切割时点晚于搅拌时点 → 违规', () {
      final ctx = TraceContext(version: _version(), events: [
        _ev('e1', StepKind.curdling, 0),
        _ev('e2', StepKind.stirring, 30), // 搅拌 08:30
        _ev('e3', StepKind.cutting, 35), // 切割 08:35 —— 晚按！
      ]);
      final findings = const SequenceRule().check(ctx);
      final outOfOrder =
          findings.where((f) => f.code == 'SEQ_OUT_OF_ORDER').toList();
      expect(outOfOrder, hasLength(1));
      expect(outOfOrder.single.severity, Severity.violation);
      expect(outOfOrder.single.relatedIds, containsAll({'e2', 'e3'}));
      expect(outOfOrder.single.message, contains('切割'));
    });

    test('正常顺序 → 无违规', () {
      final ctx = TraceContext(version: _version(), events: [
        _ev('e1', StepKind.curdling, 0),
        _ev('e2', StepKind.cutting, 20),
        _ev('e3', StepKind.stirring, 30),
        _ev('e4', StepKind.wheyDrain, 45),
        _ev('e5', StepKind.molding, 50),
        _ev('e6', StepKind.pressing, 70),
      ]);
      final findings = const SequenceRule().check(ctx);
      expect(findings.where((f) => f.isViolation), isEmpty);
    });

    test('跳步（未切割直接搅拌）→ 警告', () {
      final ctx = TraceContext(version: _version(), events: [
        _ev('e1', StepKind.curdling, 0),
        _ev('e2', StepKind.stirring, 30),
      ]);
      final findings = const SequenceRule().check(ctx);
      expect(findings.any((f) => f.code == 'SEQ_STEP_MISSING'), isTrue);
    });

    test('重复按下 → 提示复核', () {
      final ctx = TraceContext(version: _version(), events: [
        _ev('e1', StepKind.curdling, 0),
        _ev('e2', StepKind.cutting, 20),
        _ev('e3', StepKind.cutting, 21),
      ]);
      final findings = const SequenceRule().check(ctx);
      expect(findings.any((f) => f.code == 'SEQ_STEP_DUPLICATED'), isTrue);
    });
  });
}
