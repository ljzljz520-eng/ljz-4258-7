import 'dart:async' show unawaited;

import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../core/models/mold.dart';
import 'lab/lab_sample_page.dart';
import 'mold/remold_page.dart';
import 'photo/curd_photo_page.dart';
import 'scan/qr_scan_page.dart';
import 'split/mold_split_page.dart';
import 'timeline/curd_timeline_page.dart';
import 'whey/whey_transfer_page.dart';

/// 扫码后按对象类型形成实际关联：
/// 奶槽 → 打开其凝乳时间轴；乳清罐 → 记录乳清去向（预选该罐）；
/// 模具 → 展示模具详情并可跳转换模；未知 → 提示。
///
/// 导航不 await（fire-and-forget）：本函数在关联发起后即返回，
/// 避免调用方被压栈页面的生命周期阻塞。
Future<void> handleScanResult(BuildContext context, QrScanResult result) async {
  final repo = AppScope.repoOf(context);
  switch (result.kind) {
    case QrTargetKind.vat:
      final vat = await repo.findVatByQr(result.code);
      if (vat == null || !context.mounted) return;
      unawaited(Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => CurdTimelinePage(vatId: vat.id, vatCode: vat.code),
      )));
    case QrTargetKind.wheyTank:
      if (!context.mounted) return;
      unawaited(Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => WheyTransferPage(presetTankId: result.targetId),
      )));
    case QrTargetKind.mold:
      final moldId = result.targetId;
      if (moldId == null || !context.mounted) return;
      final mold = await repo.findMoldById(moldId);
      if (mold == null || !context.mounted) return;
      unawaited(_showMoldSheet(context, mold));
    case QrTargetKind.unknown:
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('未识别的二维码：${result.code}')));
  }
}

Future<void> _showMoldSheet(BuildContext context, MoldRecord mold) {
  String fmt(DateTime? t) => t == null
      ? '-'
      : '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('模具 ${mold.id}',
              style: Theme.of(sheetContext).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('模具批 ${mold.batchId} · 奶槽 ${mold.vatId}'),
          Text('重量 ${mold.weightG?.toStringAsFixed(0) ?? '-'}g · '
              '入模 ${fmt(mold.moldedAt)} · 压制 ${fmt(mold.pressedAt)}'),
          if (mold.isRemold)
            Text('由 ${mold.remoldedFromId} 换模而来（${fmt(mold.remoldedAt)}）'),
          const SizedBox(height: 16),
          FilledButton.icon(
            icon: const Icon(Icons.swap_horiz),
            label: const Text('记录换模'),
            onPressed: () {
              Navigator.of(sheetContext).pop();
              Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => RemoldPage(presetFromMoldId: mold.id),
              ));
            },
          ),
        ],
      ),
    ),
  );
}

/// 主页：奶槽列表 + 各工位入口。
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = AppScope.repoOf(context);
    return Scaffold(
      appBar: AppBar(title: const Text('奶酪制作追溯')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('扫码绑定'),
                  onPressed: () async {
                    final result = await Navigator.of(context)
                        .push<QrScanResult>(MaterialPageRoute(
                            builder: (_) => const QrScanPage()));
                    if (result != null && context.mounted) {
                      await handleScanResult(context, result);
                    }
                  },
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.grid_view),
                  label: const Text('模具拆分'),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (_) => const MoldSplitPage()),
                  ),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.water_drop),
                  label: const Text('乳清转移'),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (_) => const WheyTransferPage()),
                  ),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.science),
                  label: const Text('实验室样品'),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (_) => const LabSamplePage()),
                  ),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text('换模记录'),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const RemoldPage()),
                  ),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('凝乳拍照'),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (_) => const CurdPhotoPage()),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: StreamBuilder(
              stream: repo.watchVats(),
              builder: (context, snapshot) {
                final vats = snapshot.data ?? const [];
                if (vats.isEmpty) {
                  return const Center(child: Text('暂无奶槽记录'));
                }
                return ListView.builder(
                  itemCount: vats.length,
                  itemBuilder: (context, i) {
                    final vat = vats[i];
                    return ListTile(
                      leading: const Icon(Icons.water_drop_outlined),
                      title: Text('${vat.code}（${vat.id}）'),
                      subtitle: Text(
                          '奶批 ${vat.milkBatch ?? '-'} · 二维码 ${vat.qrCode}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              CurdTimelinePage(vatId: vat.id, vatCode: vat.code),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
