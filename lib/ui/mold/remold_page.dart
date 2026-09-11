import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_scope.dart';
import '../../core/models/mold.dart';
import '../../data/trace_repository.dart';

/// 换模记录：选择原模具，录入新模具编号与二维码，
/// 新模具挂接原模具链（remoldedFromId），换模时点取当前时刻。
/// 压制后换模会被 RemoldRule 标记为违规。
class RemoldPage extends StatefulWidget {
  const RemoldPage({super.key, this.presetFromMoldId});

  /// 扫码等场景带入的原模具 id。
  final String? presetFromMoldId;

  @override
  State<RemoldPage> createState() => _RemoldPageState();
}

class _RemoldPageState extends State<RemoldPage> {
  List<MoldRecord> _molds = const [];
  String? _fromMoldId;
  final _newIdCtrl = TextEditingController();
  final _qrCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  bool _saving = false;

  TraceRepository get _repo => AppScope.repoOf(context);

  @override
  void initState() {
    super.initState();
    _fromMoldId = widget.presetFromMoldId;
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final molds = await _repo.listAllMolds();
    if (!mounted) return;
    setState(() {
      _molds = molds;
      _fromMoldId ??= molds.firstOrNull?.id;
    });
  }

  MoldRecord? get _fromMold {
    for (final m in _molds) {
      if (m.id == _fromMoldId) return m;
    }
    return null;
  }

  Future<void> _save() async {
    final from = _fromMold;
    final newId = _newIdCtrl.text.trim();
    if (from == null || newId.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('请选择原模具并填写新模具编号')));
      return;
    }
    if (await _repo.findMoldById(newId) != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('模具 $newId 已存在，请更换编号')));
      return;
    }
    setState(() => _saving = true);
    try {
      final now = DateTime.now();
      await _repo.remold(MoldRecord(
        id: newId,
        batchId: from.batchId, // 换模不换批：沿用原模具批与奶槽
        vatId: from.vatId,
        qrCode: _qrCtrl.text.trim().isEmpty ? 'QR-$newId' : _qrCtrl.text.trim(),
        weightG: double.tryParse(_weightCtrl.text.trim()),
        remoldedFromId: from.id,
        remoldedAt: now, // 换模时点：按下即记录，可追溯
      ));
      // 落库后立即按冻结版本复核（如压制后换模）。
      final findings = await _repo.checkVat(from.vatId);
      if (!mounted) return;
      final violations = findings
          .where((f) => f.code.startsWith('REMOLD'))
          .map((f) => f.message)
          .toList();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(violations.isEmpty
            ? '已记录换模 $newId'
            : '已记录 $newId，检查发现：${violations.join('；')}'),
        duration: const Duration(seconds: 4),
      ));
      Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _newIdCtrl.dispose();
    _qrCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final from = _fromMold;
    return Scaffold(
      appBar: AppBar(title: const Text('换模记录')),
      body: _molds.isEmpty
          ? const Center(child: Text('尚无模具记录，请先在「模具拆分」中创建'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _fromMoldId,
                  decoration: const InputDecoration(labelText: '原模具'),
                  items: [
                    for (final m in _molds)
                      DropdownMenuItem(
                        value: m.id,
                        child: Text(
                            '${m.id}（槽 ${m.vatId}${m.pressedAt != null ? ' · 已压制' : ''}）'),
                      ),
                  ],
                  onChanged: (v) => setState(() => _fromMoldId = v),
                ),
                if (from != null && from.pressedAt != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '注意：原模具已完成压制，压制后换模将被标记为违规。',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                const SizedBox(height: 12),
                TextField(
                  controller: _newIdCtrl,
                  decoration: const InputDecoration(
                    labelText: '新模具编号',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _qrCtrl,
                  decoration: const InputDecoration(
                    labelText: '新模具二维码',
                    hintText: '留空则自动生成',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _weightCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: '换模后重量 (g)',
                    hintText: '可空',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: const Icon(Icons.swap_horiz),
                  label: Text(_saving ? '保存中…' : '记录换模'),
                ),
              ],
            ),
    );
  }
}
