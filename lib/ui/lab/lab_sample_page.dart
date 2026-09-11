import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_scope.dart';
import '../../core/models/enums.dart';
import '../../core/models/lab_sample.dart';
import '../../data/db/database.dart' as db;
import '../../data/trace_repository.dart';

/// 实验室样品录入：取样即落可追溯时点，送检/结果可随后补录；
/// 样品按工步关联回该槽的动作记录。
class LabSamplePage extends StatefulWidget {
  const LabSamplePage({super.key, this.presetVatId});

  final String? presetVatId;

  @override
  State<LabSamplePage> createState() => _LabSamplePageState();
}

class _LabSamplePageState extends State<LabSamplePage> {
  List<db.Vat> _vats = const [];
  String? _vatId;
  StepKind _step = StepKind.curdling;
  bool _received = false; // 是否已送检（送检时点取当前时刻）
  final _moistureCtrl = TextEditingController();
  final _acidityCtrl = TextEditingController();
  final _labIdCtrl = TextEditingController();
  bool _saving = false;

  TraceRepository get _repo => AppScope.repoOf(context);

  @override
  void initState() {
    super.initState();
    _vatId = widget.presetVatId;
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final vats = await _repo.listVats();
    if (!mounted) return;
    setState(() {
      _vats = vats;
      _vatId ??= vats.firstOrNull?.id;
    });
  }

  Future<void> _save() async {
    final vatId = _vatId;
    if (vatId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('请选择奶槽')));
      return;
    }
    setState(() => _saving = true);
    try {
      final now = DateTime.now();
      final id = 'LS-${now.microsecondsSinceEpoch}';
      await _repo.recordSample(LabSample(
        id: id,
        vatId: vatId,
        step: _step,
        sampledAt: now, // 取样时点：按下即记录，可追溯
        receivedAt: _received ? now : null,
        moisturePct: double.tryParse(_moistureCtrl.text.trim()),
        acidityPh: double.tryParse(_acidityCtrl.text.trim()),
        labId: _labIdCtrl.text.trim().isEmpty ? null : _labIdCtrl.text.trim(),
      ));
      // 落库后立即按冻结版本复核（如样品时延 / 孤儿样品）。
      final findings = await _repo.checkVat(vatId);
      if (!mounted) return;
      final warnings = findings
          .where((f) => f.code.startsWith('LAB'))
          .map((f) => f.message)
          .toList();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(warnings.isEmpty
            ? '已记录样品 $id'
            : '已记录 $id，检查发现：${warnings.join('；')}'),
        duration: const Duration(seconds: 4),
      ));
      Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _moistureCtrl.dispose();
    _acidityCtrl.dispose();
    _labIdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('实验室样品录入')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            initialValue: _vatId,
            decoration: const InputDecoration(labelText: '奶槽'),
            items: [
              for (final v in _vats)
                DropdownMenuItem(value: v.id, child: Text(v.code)),
            ],
            onChanged: (v) => setState(() => _vatId = v),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<StepKind>(
            initialValue: _step,
            decoration: const InputDecoration(labelText: '关联工步'),
            items: [
              for (final s in StepKind.values)
                DropdownMenuItem(value: s, child: Text(s.label)),
            ],
            onChanged: (v) => setState(() => _step = v ?? _step),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _moistureCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: '水分 (%)',
                    hintText: '可空',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _acidityCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: '酸度 (pH)',
                    hintText: '可空',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _labIdCtrl,
            decoration: const InputDecoration(
              labelText: '实验室编号',
              hintText: '可空',
              border: OutlineInputBorder(),
            ),
          ),
          CheckboxListTile(
            value: _received,
            onChanged: (v) => setState(() => _received = v ?? false),
            title: const Text('已送检（记录送检时点）'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.science),
            label: Text(_saving ? '保存中…' : '记录样品'),
          ),
        ],
      ),
    );
  }
}
