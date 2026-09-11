import 'enums.dart';

/// 标准背景下的凝乳粒照片（相机接口保存）。
class CurdPhoto {
  const CurdPhoto({
    required this.id,
    required this.vatId,
    required this.zone,
    required this.takenAt,
    required this.filePath,
    required this.standardBackground,
    this.grainSizeMm,
  });

  final String id;
  final String vatId;
  final VatZone zone;
  final DateTime takenAt;
  final String filePath;

  /// 是否使用标准背景板拍摄（界面强制确认）。
  final bool standardBackground;

  /// 从照片或人工量测得到的粒径（mm，记录值）。
  final double? grainSizeMm;
}
