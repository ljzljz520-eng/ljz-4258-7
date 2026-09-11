import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_scope.dart';
import '../../core/models/whey.dart';
import '../../data/db/database.dart' as db;
import '../../data/trace_repository.dart';

/// 乳清转移记录：选择奶槽与乳清罐（可由扫码带入），
/// 落库一条 奶槽 → 乳清罐 的去向记录，形成实际关联。
class WheyTransferPage extends StatefulWidget {
  const WheyTransferPage({super.key, this.presetVatId, this.presetTankId});

  /// 扫码等场景带入的预选对象。
  final String? presetVatId;
  final String? presetTankId;

  @override
  State<WheyTransferPage> createState() => _WheyTransferPageState();
}

class _WheyTransferPageState extends State<WheyTransferPage> {
  List<db.Vat> _vats = const [];
  List<db.WheyTank> _tanks = const [];
  String? _vatId;
  String? _tankId;
  final _amountCtrl = TextEditingController();
  bool _saving = false;

  TraceRepository get _repo => AppScope.repoOf(context);

  @override
  void initState() {
    super.initState();
    _vatId = widget.presetVatId;
    _tankId = widget.presetTankId;
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final vats = await _repo.listVats();
    final tanks = await _repo.listWheyTanks();
    if (!mounted) return;
    setState(() {
      _vats = vats;
      _tanks = tanks;
      _vatId ??= vats.firstOrNull?.id;
      _tankId ??= tanks.firstOrNull?.id;
    });
  }

  Future<void> _save() async {
    final vatId = _vatId;
    final tankId = _tankId;
    if (vatId == null || tankId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('请选择奶槽与乳清罐')));
      return;
    }
    setState(() => _saving = true);
    try {
      final id = 'WT-${DateTime.now().microsecondsSinceEpoch}';
      await _repo.recordTransfer(WheyTransfer(
        id: id,
        vatId: vatId,
        tankId: tankId,
        transferredAt: DateTime.now(), // 转移时点：按下即记录，可追溯
        amountL: double.tryParse(_amountCtrl.text.trim()),
      ));
      // 落库后立即按冻结版本复核（如乳清罐混批）。
      final findings = await _repo.checkVat(vatId);
      if (!mounted) return;
      final warnings = findings
          .where((f) => f.code.startsWith('WHEY'))
          .map((f) => f.message)
          .toList();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(warnings.isEmpty
            ? '已记录乳清去向 $id'
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
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('乳清转移记录')),
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
          DropdownButtonFormField<String>(
            initialValue: _tankId,
            decoration: const InputDecoration(labelText: '去向乳清罐'),
            items: [
              for (final t in _tanks)
                DropdownMenuItem(value: t.id, child: Text(t.code)),
            ],
            onChanged: (v) => setState(() => _tankId = v),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            decoration: const InputDecoration(
              labelText: '转移量 (L)',
              hintText: '可空',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.save),
            label: Text(_saving ? '保存中…' : '记录乳清去向'),
          ),
        ],
      ),
    );
  }
}
