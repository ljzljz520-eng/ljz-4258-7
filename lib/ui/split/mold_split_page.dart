import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_scope.dart';
import '../../core/models/mold.dart';
import '../../data/db/database.dart' as db;
import '../../data/trace_repository.dart';

/// 模具拆分界面：将一口奶槽的凝乳拆分为一个模具批，
/// 逐模录入称重，实时显示批内离散度并对照冻结版本容差。
class MoldSplitPage extends StatefulWidget {
  const MoldSplitPage({super.key});

  @override
  State<MoldSplitPage> createState() => _MoldSplitPageState();
}

class _MoldSplitPageState extends State<MoldSplitPage> {
  List<db.Vat> _vats = const [];
  String? _vatId;
  int _moldCount = 4;
  final List<TextEditingController> _weightCtrls = [];
  double? _tolerancePct;
  bool _saving = false;

  TraceRepository get _repo => AppScope.repoOf(context);

  @override
  void initState() {
    super.initState();
    _rebuildControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final vats = await _repo.listVats();
    final versions = await _repo.listVersions();
    if (!mounted) return;
    setState(() {
      _vats = vats;
      _vatId = vats.firstOrNull?.id;
      _tolerancePct = versions.firstOrNull?.tolerances.maxMoldWeightSpreadPct;
    });
  }

  void _rebuildControllers() {
    for (final c in _weightCtrls) {
      c.dispose();
    }
    _weightCtrls
      ..clear()
      ..addAll(List.generate(_moldCount, (_) => TextEditingController()));
  }

  List<double?> get _weights =>
      _weightCtrls.map((c) => double.tryParse(c.text)).toList();

  /// 批内重量离散统计（均值与各模偏差百分比）。
  ({double mean, double maxSpreadPct})? get _stats {
    final w = _weights.whereType<double>().toList();
    if (w.length < 2) return null;
    final mean = w.reduce((a, b) => a + b) / w.length;
    if (mean <= 0) return null;
    final maxSpread =
        w.map((x) => (x - mean).abs() / mean * 100).reduce((a, b) => a > b ? a : b);
    return (mean: mean, maxSpreadPct: maxSpread);
  }

  Future<void> _save() async {
    final vatId = _vatId;
    if (vatId == null) return;
    if (_weights.any((w) => w == null)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('请填写全部模具重量')));
      return;
    }
    setState(() => _saving = true);
    try {
      final now = DateTime.now();
      final batchId = 'BATCH-${now.microsecondsSinceEpoch}';
      await _repo.splitIntoMolds(
        batchId: batchId,
        batchCode: '模具批 $batchId',
        vatId: vatId,
        createdAt: now,
        molds: [
          for (var i = 0; i < _moldCount; i++)
            MoldRecord(
              id: '$batchId-M${i + 1}',
              batchId: batchId,
              vatId: vatId,
              qrCode: 'QR-$batchId-M${i + 1}',
              weightG: _weights[i],
              moldedAt: now,
            ),
        ],
      );
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('已保存模具批 $batchId')));
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    for (final c in _weightCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = _stats;
    final tolerance = _tolerancePct;
    final overTolerance =
        stats != null && tolerance != null && stats.maxSpreadPct > tolerance;
    return Scaffold(
      appBar: AppBar(title: const Text('模具拆分')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            initialValue: _vatId,
            decoration: const InputDecoration(labelText: '来源奶槽'),
            items: [
              for (final v in _vats)
                DropdownMenuItem(value: v.id, child: Text(v.code)),
            ],
            onChanged: (v) => setState(() => _vatId = v),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('模具数量'),
              Expanded(
                child: Slider(
                  value: _moldCount.toDouble(),
                  min: 2,
                  max: 12,
                  divisions: 10,
                  label: '$_moldCount',
                  onChanged: (v) => setState(() {
                    _moldCount = v.round();
                    _rebuildControllers();
                  }),
                ),
              ),
              Text('$_moldCount 个'),
            ],
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < _moldCount; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextField(
                controller: _weightCtrls[i],
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                decoration: InputDecoration(
                  labelText: '模具 ${i + 1} 重量 (g)',
                  border: const OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          if (stats != null)
            Card(
              color: overTolerance
                  ? Theme.of(context).colorScheme.errorContainer
                  : null,
              child: ListTile(
                leading: Icon(
                    overTolerance ? Icons.warning_amber : Icons.check_circle),
                title: Text(
                    '批均值 ${stats.mean.toStringAsFixed(0)}g · 最大偏差 ${stats.maxSpreadPct.toStringAsFixed(1)}%'),
                subtitle: Text(tolerance == null
                    ? '冻结版本未录入重量容差'
                    : '容差 ±${tolerance.toStringAsFixed(1)}%'
                        '${overTolerance ? ' · 已超差' : ''}'),
              ),
            ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.save),
            label: Text(_saving ? '保存中…' : '保存模具批'),
          ),
        ],
      ),
    );
  }
}
