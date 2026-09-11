import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_scope.dart';
import '../../core/models/enums.dart';
import '../../core/models/finding.dart';
import '../../core/models/mold.dart';
import '../../core/models/mold_turn.dart';
import '../../data/db/database.dart' as db;
import '../../data/trace_repository.dart';

/// 翻模记录：选择奶槽与模具，录入本轮翻面的位置、实际时刻
/// （支持夜班补录过去时刻）、破损观察与压板编号。
///
/// - 轮次按该模具已有记录自动递增；
/// - 破损观察选「裂成两件」时可一并登记第二件模具（同事务落库）；
/// - 保存后按冻结版本复核，页面下方列出本槽待人工处置的翻模发现
///   （漏翻单模独立在列，不影响其他模具）。
class MoldTurnPage extends StatefulWidget {
  const MoldTurnPage({super.key, this.presetVatId, this.presetMoldId});

  /// 扫码等场景带入的预选对象。
  final String? presetVatId;
  final String? presetMoldId;

  @override
  State<MoldTurnPage> createState() => _MoldTurnPageState();
}

class _MoldTurnPageState extends State<MoldTurnPage> {
  List<db.Vat> _vats = const [];
  List<MoldRecord> _molds = const [];
  String? _vatId;
  String? _moldId;
  int _nextRound = 1;

  final _positionCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _backfillCtrl = TextEditingController(text: '0');
  final _pieceIdCtrl = TextEditingController();
  TurnDamage _damage = TurnDamage.none;
  bool _saving = false;
  List<Finding> _turnFindings = const [];

  TraceRepository get _repo => AppScope.repoOf(context);

  @override
  void initState() {
    super.initState();
    _vatId = widget.presetVatId;
    _moldId = widget.presetMoldId;
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final vats = await _repo.listVats();
    if (!mounted) return;
    setState(() {
      _vats = vats;
      _vatId ??= vats.firstOrNull?.id;
    });
    await _loadMolds();
  }

  Future<void> _loadMolds() async {
    final vatId = _vatId;
    if (vatId == null) return;
    final molds = await _repo.moldsForVat(vatId);
    if (!mounted) return;
    setState(() {
      _molds = molds;
      if (_moldId == null || !molds.any((m) => m.id == _moldId)) {
        _moldId = molds.firstOrNull?.id;
      }
    });
    await _refreshRound();
    await _refreshFindings();
  }

  Future<void> _refreshRound() async {
    final moldId = _moldId;
    if (moldId == null) return;
    final turns = await _repo.turnsForMold(moldId);
    if (!mounted) return;
    setState(() {
      _nextRound = turns.isEmpty
          ? 1
          : turns.map((t) => t.round).reduce((a, b) => a > b ? a : b) + 1;
    });
  }

  Future<void> _refreshFindings() async {
    final vatId = _vatId;
    if (vatId == null) return;
    final findings = await _repo.checkVat(vatId);
    if (!mounted) return;
    setState(() {
      _turnFindings =
          findings.where((f) => f.code.startsWith('TURN')).toList();
    });
  }

  MoldRecord? get _mold {
    for (final m in _molds) {
      if (m.id == _moldId) return m;
    }
    return null;
  }

  Future<void> _save() async {
    final mold = _mold;
    final position = _positionCtrl.text.trim();
    if (mold == null || position.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('请选择模具并填写翻模后位置')));
      return;
    }
    final backfillMin = int.tryParse(_backfillCtrl.text.trim()) ?? 0;
    final pieceId = _pieceIdCtrl.text.trim();
    if (_damage == TurnDamage.splitInTwo &&
        pieceId.isNotEmpty &&
        await _repo.findMoldById(pieceId) != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('模具 $pieceId 已存在，请更换编号')));
      return;
    }
    setState(() => _saving = true);
    try {
      final now = DateTime.now();
      // 实际时刻支持补录：默认此刻，可回填「多少分钟前」。
      final turnedAt = now.subtract(Duration(minutes: backfillMin));
      final turn = MoldTurn(
        id: 'TURN-${now.microsecondsSinceEpoch}',
        moldId: mold.id,
        vatId: mold.vatId,
        round: _nextRound,
        position: position,
        turnedAt: turnedAt,
        recordedAt: now, // 落库时刻：与补录的实际时刻分开保存
        damage: _damage,
        pressPlateId:
            _plateCtrl.text.trim().isEmpty ? null : _plateCtrl.text.trim(),
        note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      );
      if (_damage == TurnDamage.splitInTwo && pieceId.isNotEmpty) {
        // 裂成两件：翻模记录与第二件模具一并落库。
        await _repo.recordTurnWithSplitPiece(
          turn: turn,
          piece: MoldRecord(
            id: pieceId,
            batchId: mold.batchId, // 分件不换批：沿用原模具批与奶槽
            vatId: mold.vatId,
            qrCode: 'QR-$pieceId',
            splitFromMoldId: mold.id,
            splitAt: turnedAt,
          ),
        );
      } else {
        await _repo.recordTurn(turn);
      }
      // 落库后立即按冻结版本复核（漏翻/补录/交换/裂件等）。
      final findings = await _repo.checkVat(mold.vatId);
      if (!mounted) return;
      final warnings = findings
          .where((f) => f.code.startsWith('TURN'))
          .map((f) => f.message)
          .toList();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(warnings.isEmpty
            ? '已记录第 $_nextRound 轮翻模'
            : '已记录第 $_nextRound 轮翻模，检查发现：${warnings.join('；')}'),
        duration: const Duration(seconds: 4),
      ));
      // 留在本页继续记录下一轮。
      _positionCtrl.clear();
      _noteCtrl.clear();
      _pieceIdCtrl.clear();
      _backfillCtrl.text = '0';
      setState(() => _damage = TurnDamage.none);
      await _loadMolds();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _positionCtrl.dispose();
    _plateCtrl.dispose();
    _noteCtrl.dispose();
    _backfillCtrl.dispose();
    _pieceIdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('翻模记录')),
      body: _vats.isEmpty
          ? const Center(child: Text('暂无奶槽记录'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _vatId,
                  decoration: const InputDecoration(labelText: '奶槽'),
                  items: [
                    for (final v in _vats)
                      DropdownMenuItem(value: v.id, child: Text(v.code)),
                  ],
                  onChanged: (v) async {
                    setState(() {
                      _vatId = v;
                      _moldId = null;
                    });
                    await _loadMolds();
                  },
                ),
                const SizedBox(height: 12),
                if (_molds.isEmpty)
                  const Text('本槽尚无模具，请先在「模具拆分」中创建')
                else ...[
                  DropdownButtonFormField<String>(
                    initialValue: _moldId,
                    decoration: InputDecoration(
                        labelText: '模具（下一轮次第 $_nextRound 轮）'),
                    items: [
                      for (final m in _molds)
                        DropdownMenuItem(
                          value: m.id,
                          child: Text(
                              '${m.id}${m.isSplitPiece ? '（裂件）' : ''}'),
                        ),
                    ],
                    onChanged: (v) async {
                      setState(() => _moldId = v);
                      await _refreshRound();
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _positionCtrl,
                    decoration: const InputDecoration(
                      labelText: '翻模后位置（架位/层位）',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _backfillCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: '实际发生在多少分钟前（补录用，0 为此刻）',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<TurnDamage>(
                    initialValue: _damage,
                    decoration: const InputDecoration(labelText: '破损观察'),
                    items: [
                      for (final d in TurnDamage.values)
                        DropdownMenuItem(value: d, child: Text(d.label)),
                    ],
                    onChanged: (v) =>
                        setState(() => _damage = v ?? TurnDamage.none),
                  ),
                  if (_damage == TurnDamage.splitInTwo) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: _pieceIdCtrl,
                      decoration: const InputDecoration(
                        labelText: '第二件模具编号（裂件登记，可稍后补登）',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextField(
                    controller: _plateCtrl,
                    decoration: const InputDecoration(
                      labelText: '压板编号',
                      hintText: '可空；与上轮不同将留痕',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _noteCtrl,
                    decoration: const InputDecoration(
                      labelText: '备注',
                      hintText: '可空',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: const Icon(Icons.flip),
                    label: Text(_saving ? '保存中…' : '记录第 $_nextRound 轮翻模'),
                  ),
                ],
                if (_turnFindings.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text('本槽翻模检查发现（人工处置）',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  for (final f in _turnFindings)
                    Card(
                      child: ListTile(
                        leading: Icon(
                          f.isViolation
                              ? Icons.error
                              : f.severity == Severity.warning
                                  ? Icons.warning_amber
                                  : Icons.info_outline,
                          color: f.isViolation
                              ? Theme.of(context).colorScheme.error
                              : null,
                        ),
                        title: Text(f.code),
                        subtitle: Text(f.message),
                      ),
                    ),
                ],
              ],
            ),
    );
  }
}
