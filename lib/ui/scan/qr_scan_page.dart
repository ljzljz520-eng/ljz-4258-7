import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../app_scope.dart';
import '../../data/trace_repository.dart';

/// 二维码扫描页：识别凝乳槽、乳清罐与模具的二维码并解析绑定对象。
///
/// 作为路由使用时，扫描成功会以 [QrScanResult] pop 返回；
/// 调用方据此形成实际关联（打开奶槽、记录乳清去向、查看/换模具）。
class QrScanPage extends StatefulWidget {
  const QrScanPage({super.key});

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

/// 扫码解析出的对象类型。
enum QrTargetKind { vat, wheyTank, mold, unknown }

class QrScanResult {
  const QrScanResult({
    required this.code,
    required this.kind,
    required this.targetId,
    required this.label,
  });

  /// 原始二维码内容。
  final String code;

  /// 解析出的对象类型：奶槽 / 乳清罐 / 模具 / 未知。
  final QrTargetKind kind;

  /// 已解析对象的主键 id（未知类型时为 null）。
  final String? targetId;

  /// 展示用标签（编号或原始内容）。
  final String label;
}

class _QrScanPageState extends State<QrScanPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _handled = false;

  TraceRepository get _repo => AppScope.repoOf(context);

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handled) return;
    final code = capture.barcodes.firstOrNull?.rawValue;
    if (code == null || code.isEmpty) return;
    _handled = true;

    // 依次尝试解析为奶槽、乳清罐、模具。
    final vat = await _repo.findVatByQr(code);
    final tank = vat == null ? await _repo.findTankByQr(code) : null;
    final mold = vat == null && tank == null
        ? await _repo.findMoldByQr(code)
        : null;
    if (!mounted) return;

    final result = QrScanResult(
      code: code,
      kind: vat != null
          ? QrTargetKind.vat
          : tank != null
              ? QrTargetKind.wheyTank
              : mold != null
                  ? QrTargetKind.mold
                  : QrTargetKind.unknown,
      targetId: vat?.id ?? tank?.id ?? mold?.id,
      label: vat?.code ?? tank?.code ?? mold?.id ?? code,
    );
    Navigator.of(context).pop(result);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('扫码绑定')),
      body: Stack(
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              color: Colors.black54,
              padding: const EdgeInsets.all(16),
              child: const Text(
                '对准凝乳槽、乳清罐或模具上的二维码',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
