import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../core/models/action_event.dart';
import '../../core/models/enums.dart';
import '../../core/models/finding.dart';
import '../../data/trace_repository.dart';

/// 凝乳时间轴：展示某奶槽从凝乳到压制的全部已实施动作，
/// 操作员可在此按工步记录动作（时点自动取当前时刻），
/// 页面底部实时显示规则检查发现。
class CurdTimelinePage extends StatefulWidget {
  const CurdTimelinePage({super.key, required this.vatId, required this.vatCode});

  final String vatId;
  final String vatCode;

  @override
  State<CurdTimelinePage> createState() => _CurdTimelinePageState();
}

class _CurdTimelinePageState extends State<CurdTimelinePage> {
  List<Finding> _findings = const [];

  TraceRepository get _repo => AppScope.repoOf(context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshFindings());
  }

  Future<void> _refreshFindings() async {
    final findings = await _repo.checkVat(widget.vatId);
    if (mounted) setState(() => _findings = findings);
  }

  Future<void> _recordStep(StepKind step) async {
    final versions = await _repo.listVersions();
    if (versions.isEmpty || !mounted) return;
    // 弹出工艺观测录入：温度 / 目视状态 / 槽内位置 / 切块尺寸 / 备注。
    // 操作员也可选择「直接记录」跳过观测，仅落可追溯时点。
    final observation = await showDialog<StepObservation>(
      context: context,
      builder: (_) => StepObservationDialog(step: step),
    );
    if (observation == null || !mounted) return; // 取消：不记录
    final event = ActionEvent(
      id: 'EV-${DateTime.now().microsecondsSinceEpoch}',
      vatId: widget.vatId,
      step: step,
      performedAt: DateTime.now(), // 手工动作时点：按下即记录，可追溯
      operatorId: 'operator-local',
      processVersionId: versions.first.id,
      temperatureC: observation.temperatureC,
      visualState: observation.visualState,
      cutSizeMm: observation.cutSizeMm,
      zone: observation.zone,
      note: observation.note,
    );
    await _repo.recordAction(event);
    await _refreshFindings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.vatCode} · 凝乳时间轴')),
      body: Column(
        children: [
          _StepButtons(onRecord: _recordStep),
          const Divider(height: 1),
          Expanded(
            child: StreamBuilder<List<ActionEvent>>(
              stream: _repo.watchEventsForVat(widget.vatId),
              builder: (context, snapshot) {
                final events = snapshot.data ?? const <ActionEvent>[];
                if (events.isEmpty) {
                  return const Center(child: Text('尚无动作记录，请从上方工步开始'));
                }
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, i) =>
                      _TimelineTile(event: events[i], isLast: i == events.length - 1),
                );
              },
            ),
          ),
          if (_findings.isNotEmpty) _FindingsPanel(findings: _findings),
        ],
      ),
    );
  }
}

class _StepButtons extends StatelessWidget {
  const _StepButtons({required this.onRecord});

  final ValueChanged<StepKind> onRecord;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          for (final step in StepKind.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilledButton.tonal(
                onPressed: () => onRecord(step),
                child: Text(step.label),
              ),
            ),
        ],
      ),
    );
  }
}

/// 操作员在工步按钮上录入的工艺观测（全部可空，纯记录值）。
class StepObservation {
  const StepObservation({
    this.temperatureC,
    this.visualState,
    this.cutSizeMm,
    this.zone,
    this.note,
  });

  final double? temperatureC;
  final VisualState? visualState;
  final double? cutSizeMm;
  final VatZone? zone;
  final String? note;
}

/// 工步观测录入对话框：按下工步按钮后弹出，
/// 「记录观测」携带观测落库，「直接记录」仅落时点，「取消」不记录。
class StepObservationDialog extends StatefulWidget {
  const StepObservationDialog({super.key, required this.step});

  final StepKind step;

  @override
  State<StepObservationDialog> createState() => _StepObservationDialogState();
}

class _StepObservationDialogState extends State<StepObservationDialog> {
  final _tempCtrl = TextEditingController();
  final _cutSizeCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  VisualState? _visualState;
  VatZone? _zone;

  @override
  void dispose() {
    _tempCtrl.dispose();
    _cutSizeCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _submit({required bool withObservation}) {
    if (!withObservation) {
      Navigator.of(context).pop(const StepObservation());
      return;
    }
    Navigator.of(context).pop(StepObservation(
      temperatureC: double.tryParse(_tempCtrl.text.trim()),
      visualState: _visualState,
      cutSizeMm: double.tryParse(_cutSizeCtrl.text.trim()),
      zone: _zone,
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('记录 · ${widget.step.label}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _tempCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: '实测温度 (℃)',
                hintText: '可空',
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<VisualState>(
              initialValue: _visualState,
              decoration: const InputDecoration(labelText: '目视状态'),
              items: [
                for (final s in VisualState.values)
                  DropdownMenuItem(value: s, child: Text(s.label)),
              ],
              onChanged: (v) => setState(() => _visualState = v),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<VatZone>(
              initialValue: _zone,
              decoration: const InputDecoration(labelText: '槽内位置'),
              items: [
                for (final z in VatZone.values)
                  DropdownMenuItem(value: z, child: Text(z.label)),
              ],
              onChanged: (v) => setState(() => _zone = v),
            ),
            // 切块尺寸仅在切割工步录入。
            if (widget.step == StepKind.cutting) ...[
              const SizedBox(height: 8),
              TextField(
                controller: _cutSizeCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: '切块尺寸 (mm)',
                  hintText: '可空',
                ),
              ),
            ],
            const SizedBox(height: 8),
            TextField(
              controller: _noteCtrl,
              decoration: const InputDecoration(
                labelText: '备注',
                hintText: '可空',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () => _submit(withObservation: false),
          child: const Text('直接记录'),
        ),
        FilledButton(
          onPressed: () => _submit(withObservation: true),
          child: const Text('记录观测'),
        ),
      ],
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.event, required this.isLast});

  final ActionEvent event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final t = event.performedAt;
    final time =
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:${t.second.toString().padLeft(2, '0')}';
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Icon(Icons.circle, size: 12, color: Theme.of(context).colorScheme.primary),
                if (!isLast)
                  Expanded(
                    child: VerticalDivider(
                        width: 1, color: Theme.of(context).dividerColor),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListTile(
              title: Text(event.step.label),
              subtitle: Text([
                time,
                if (event.temperatureC != null)
                  '${event.temperatureC!.toStringAsFixed(1)}℃',
                if (event.visualState != null) event.visualState!.label,
                if (event.cutSizeMm != null)
                  '切块 ${event.cutSizeMm!.toStringAsFixed(0)}mm',
                if (event.zone != null) event.zone!.label,
                if (event.note != null && event.note!.isNotEmpty)
                  '备注：${event.note}',
              ].join(' · ')),
            ),
          ),
        ],
      ),
    );
  }
}

class _FindingsPanel extends StatelessWidget {
  const _FindingsPanel({required this.findings});

  final List<Finding> findings;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 180),
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final f in findings)
              ListTile(
                dense: true,
                leading: Icon(
                  switch (f.severity) {
                    Severity.violation => Icons.error,
                    Severity.warning => Icons.warning_amber,
                    Severity.info => Icons.info_outline,
                  },
                  color: switch (f.severity) {
                    Severity.violation => Colors.red,
                    Severity.warning => Colors.orange,
                    Severity.info => Colors.blueGrey,
                  },
                ),
                title: Text(f.message, style: const TextStyle(fontSize: 13)),
              ),
          ],
        ),
      ),
    );
  }
}
