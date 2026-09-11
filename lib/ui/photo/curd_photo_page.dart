import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../app_scope.dart';
import '../../core/models/curd_photo.dart';
import '../../core/models/enums.dart';
import '../../data/db/database.dart' as db;
import '../../data/trace_repository.dart';

/// 凝乳粒拍照页：相机预览叠加标准背景参考框，
/// 拍摄后选择槽内位置并保存记录。
class CurdPhotoPage extends StatefulWidget {
  const CurdPhotoPage({super.key, this.presetVatId});

  final String? presetVatId;

  @override
  State<CurdPhotoPage> createState() => _CurdPhotoPageState();
}

class _CurdPhotoPageState extends State<CurdPhotoPage> {
  CameraController? _controller;
  String? _error;
  List<db.Vat> _vats = const [];
  String? _vatId;
  VatZone _zone = VatZone.top;
  bool _standardBackgroundConfirmed = false;
  bool _saving = false;

  TraceRepository get _repo => AppScope.repoOf(context);

  @override
  void initState() {
    super.initState();
    _vatId = widget.presetVatId;
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    final vats = await _repo.listVats();
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _error = '未检测到相机');
        return;
      }
      final controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted) return;
      setState(() {
        _controller = controller;
        _vats = vats;
        _vatId ??= vats.firstOrNull?.id;
      });
    } on CameraException catch (e) {
      setState(() => _error = '相机初始化失败：${e.description}');
    }
  }

  Future<void> _capture() async {
    final controller = _controller;
    final vatId = _vatId;
    if (controller == null || vatId == null || _saving) return;
    if (!_standardBackgroundConfirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请先确认已使用标准背景板')));
      return;
    }
    setState(() => _saving = true);
    try {
      final xfile = await controller.takePicture();
      final dir = await getApplicationDocumentsDirectory();
      final photoId = 'PH-${DateTime.now().microsecondsSinceEpoch}';
      final path = p.join(dir.path, 'curd_photos', '$photoId.jpg');
      await File(path).parent.create(recursive: true);
      await File(xfile.path).copy(path);
      await _repo.recordPhoto(CurdPhoto(
        id: photoId,
        vatId: vatId,
        zone: _zone,
        takenAt: DateTime.now(),
        filePath: path,
        standardBackground: true,
      ));
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('已保存照片 $photoId')));
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Scaffold(
      appBar: AppBar(title: const Text('凝乳粒拍照')),
      body: _error != null
          ? Center(child: Text(_error!))
          : controller == null || !controller.value.isInitialized
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CameraPreview(controller),
                          // 标准背景参考框：提示操作员将背景板对准框内。
                          Center(
                            child: Container(
                              width: 260,
                              height: 260,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.white70, width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Text('标准背景板区域',
                                      style:
                                          TextStyle(color: Colors.white70)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  initialValue: _vatId,
                                  decoration:
                                      const InputDecoration(labelText: '奶槽'),
                                  items: [
                                    for (final v in _vats)
                                      DropdownMenuItem(
                                          value: v.id, child: Text(v.code)),
                                  ],
                                  onChanged: (v) =>
                                      setState(() => _vatId = v),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<VatZone>(
                                  initialValue: _zone,
                                  decoration: const InputDecoration(
                                      labelText: '槽内位置'),
                                  items: [
                                    for (final z in VatZone.values)
                                      DropdownMenuItem(
                                          value: z, child: Text(z.label)),
                                  ],
                                  onChanged: (z) =>
                                      setState(() => _zone = z ?? _zone),
                                ),
                              ),
                            ],
                          ),
                          CheckboxListTile(
                            value: _standardBackgroundConfirmed,
                            onChanged: (v) => setState(() =>
                                _standardBackgroundConfirmed = v ?? false),
                            title: const Text('已使用标准背景板'),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                          FilledButton.icon(
                            onPressed: _saving ? null : _capture,
                            icon: const Icon(Icons.camera),
                            label: Text(_saving ? '保存中…' : '拍摄并保存'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
