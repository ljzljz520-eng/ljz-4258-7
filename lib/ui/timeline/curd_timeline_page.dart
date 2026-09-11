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
    final event = ActionEvent(
      id: 'EV-${DateTime.now().microsecondsSinceEpoch}',
      vatId: widget.vatId,
      step: step,
      performedAt: DateTime.now(), // 手工动作时点：按下即记录，可追溯
      operatorId: 'operator-local',
      processVersionId: versions.first.id,
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
