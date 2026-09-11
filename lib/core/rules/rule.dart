import '../models/action_event.dart';
import '../models/curd_photo.dart';
import '../models/finding.dart';
import '../models/lab_sample.dart';
import '../models/mold.dart';
import '../models/mold_turn.dart';
import '../models/process_version.dart';
import '../models/whey.dart';

/// 一次检查所需的全部追溯数据（按奶槽聚合）。
class TraceContext {
  const TraceContext({
    required this.version,
    this.events = const [],
    this.transfers = const [],
    this.molds = const [],
    this.turns = const [],
    this.samples = const [],
    this.photos = const [],
  });

  /// 冻结的工艺版本（含制酪师录入的容差）。
  final ProcessVersion version;
  final List<ActionEvent> events;
  final List<WheyTransfer> transfers;
  final List<MoldRecord> molds;

  /// 翻模轮次记录。
  final List<MoldTurn> turns;
  final List<LabSample> samples;
  final List<CurdPhoto> photos;

  /// 按奶槽过滤出子上下文。
  TraceContext forVat(String vatId) => TraceContext(
        version: version,
        events: events.where((e) => e.vatId == vatId).toList(),
        transfers: transfers.where((t) => t.vatId == vatId).toList(),
        molds: molds.where((m) => m.vatId == vatId).toList(),
        turns: turns.where((t) => t.vatId == vatId).toList(),
        samples: samples.where((s) => s.vatId == vatId).toList(),
        photos: photos.where((p) => p.vatId == vatId).toList(),
      );

  Set<String> get vatIds => {
        ...events.map((e) => e.vatId),
        ...transfers.map((t) => t.vatId),
        ...molds.map((m) => m.vatId),
        ...turns.map((t) => t.vatId),
        ...samples.map((s) => s.vatId),
        ...photos.map((p) => p.vatId),
      };
}

/// 工位规则接口：纯函数，输入追溯数据，输出检查发现。
abstract class StationRule {
  const StationRule();

  /// 规则码前缀，如 `SEQ`。
  String get prefix;

  List<Finding> check(TraceContext ctx);
}
