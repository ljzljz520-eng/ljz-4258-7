import 'package:flutter/material.dart';

import '../app_scope.dart';
import 'photo/curd_photo_page.dart';
import 'scan/qr_scan_page.dart';
import 'split/mold_split_page.dart';
import 'timeline/curd_timeline_page.dart';

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
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (_) => const QrScanPage()),
                  ),
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
