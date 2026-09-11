import '../models/enums.dart';
import '../models/finding.dart';
import '../models/mold_turn.dart';
import 'rule.dart';

/// 翻模轮次规则：每次翻面记录模具、位置、实际时刻与破损观察。
///
/// 覆盖场景：
/// - 「漏翻」：同槽其他模具已翻到第 N 轮而某模具缺轮，该单模独立进入
///   人工处置（finding 只关联该模具，不影响其他模具的记录与判定）；
/// - 「夜班补录」：落库时刻晚于实际翻面时刻，超过冻结版本容差即报警；
/// - 「两模内容交换」：同一轮次两模具的位置与上一轮交叉互换，疑似
///   内容对调，需人工核对；
/// - 「翻模时标签遮住」：标签不可读，模具身份需人工核对；
/// - 「一个奶酪裂开分成两件」：观察到裂成两件但未登记第二件模具时报警，
///   已登记则信息留痕；
/// - 「翻模后改用不同压板」：同一模具相邻轮次压板编号变化，信息留痕。
class TurnRule extends StationRule {
  const TurnRule();

  @override
  String get prefix => 'TURN';

  @override
  List<Finding> check(TraceContext ctx) {
    final findings = <Finding>[];
    findings.addAll(_checkTurns(ctx));
    findings.addAll(_checkPlateChanges(ctx));
    findings.addAll(_checkContentSwap(ctx));
    findings.addAll(_checkMissedRounds(ctx));
    findings.addAll(_checkSplitPieces(ctx));
    return findings;
  }

  /// 逐条记录检查：夜班补录、标签遮住、裂件未登记。
  List<Finding> _checkTurns(TraceContext ctx) {
    final findings = <Finding>[];
    final maxDelay = ctx.version.tolerances.maxTurnRecordDelay;
    for (final t in ctx.turns) {
      if (maxDelay != null) {
        final delay = t.recordedAt.difference(t.turnedAt);
        if (delay > maxDelay) {
          findings.add(Finding(
            code: 'TURN_LATE_RECORD',
            severity: Severity.warning,
            vatId: t.vatId,
            relatedIds: {t.moldId, t.id},
            message: '槽 ${t.vatId}：模具 ${t.moldId} 第 ${t.round} 轮翻模于 '
                '${t.turnedAt.toIso8601String()} 实际发生，'
                '${t.recordedAt.toIso8601String()} 才落库，'
                '补录时延 ${delay.inMinutes} 分钟，'
                '超过容差 ${maxDelay.inMinutes} 分钟（如夜班补录），需人工确认。',
          ));
        }
      }
      if (t.damage == TurnDamage.labelCovered) {
        findings.add(Finding(
          code: 'TURN_LABEL_COVERED',
          severity: Severity.warning,
          vatId: t.vatId,
          relatedIds: {t.moldId, t.id},
          message: '槽 ${t.vatId}：模具 ${t.moldId} 第 ${t.round} 轮翻模时'
              '标签被遮住，身份无法扫码核对，需人工确认模具身份。',
        ));
      }
      if (t.damage == TurnDamage.splitInTwo) {
        final registered =
            ctx.molds.any((m) => m.splitFromMoldId == t.moldId);
        if (!registered) {
          findings.add(Finding(
            code: 'TURN_SPLIT_PENDING',
            severity: Severity.warning,
            vatId: t.vatId,
            relatedIds: {t.moldId, t.id},
            message: '槽 ${t.vatId}：模具 ${t.moldId} 第 ${t.round} 轮翻模时'
              '观察到奶酪裂成两件，但尚未登记第二件模具，请补登记。',
          ));
        }
      }
    }
    return findings;
  }

  /// 翻模后改用不同压板：同一模具相邻轮次压板编号变化（信息留痕）。
  List<Finding> _checkPlateChanges(TraceContext ctx) {
    final findings = <Finding>[];
    final byMold = <String, List<MoldTurn>>{};
    for (final t in ctx.turns) {
      byMold.putIfAbsent(t.moldId, () => []).add(t);
    }
    byMold.forEach((moldId, turns) {
      turns.sort((a, b) => a.round.compareTo(b.round));
      for (var i = 1; i < turns.length; i++) {
        final prev = turns[i - 1].pressPlateId;
        final curr = turns[i].pressPlateId;
        if (prev != null && curr != null && prev != curr) {
          findings.add(Finding(
            code: 'TURN_PLATE_CHANGED',
            severity: Severity.info,
            vatId: turns[i].vatId,
            relatedIds: {moldId, turns[i - 1].id, turns[i].id},
            message: '槽 ${turns[i].vatId}：模具 $moldId 第 ${turns[i - 1].round} 轮'
                '使用压板 $prev，第 ${turns[i].round} 轮改用压板 $curr，已留痕。',
          ));
        }
      }
    });
    return findings;
  }

  /// 两模内容交换：同一轮次两模具的位置与上一轮交叉互换。
  List<Finding> _checkContentSwap(TraceContext ctx) {
    final findings = <Finding>[];
    final byVat = <String, List<MoldTurn>>{};
    for (final t in ctx.turns) {
      byVat.putIfAbsent(t.vatId, () => []).add(t);
    }
    byVat.forEach((vatId, turns) {
      // 位置索引：pos[moldId][round] = position
      final pos = <String, Map<int, String>>{};
      for (final t in turns) {
        pos.putIfAbsent(t.moldId, () => {})[t.round] = t.position;
      }
      final moldIds = pos.keys.toList();
      for (var i = 0; i < moldIds.length; i++) {
        for (var j = i + 1; j < moldIds.length; j++) {
          final a = pos[moldIds[i]]!;
          final b = pos[moldIds[j]]!;
          for (final r in a.keys) {
            if (r < 2) continue;
            final aPrev = a[r - 1];
            final bPrev = b[r - 1];
            final aNow = a[r];
            final bNow = b[r];
            if (aPrev == null || bPrev == null || aNow == null || bNow == null) {
              continue;
            }
            if (aPrev != bPrev && aNow == bPrev && bNow == aPrev) {
              findings.add(Finding(
                code: 'TURN_CONTENT_SWAP',
                severity: Severity.warning,
                vatId: vatId,
                relatedIds: {moldIds[i], moldIds[j]},
                message: '槽 $vatId：第 $r 轮翻模后，模具 ${moldIds[i]} 出现在 '
                    '${moldIds[j]} 上一轮的位置（$bPrev），模具 ${moldIds[j]} 出现在 '
                    '${moldIds[i]} 上一轮的位置（$aPrev），'
                    '疑似两模内容交换，需人工核对。',
              ));
            }
          }
        }
      }
    });
    return findings;
  }

  /// 漏翻：缺轮的单模独立进入人工处置，不影响其他模具。
  List<Finding> _checkMissedRounds(TraceContext ctx) {
    final findings = <Finding>[];
    final byVat = <String, List<MoldTurn>>{};
    for (final t in ctx.turns) {
      byVat.putIfAbsent(t.vatId, () => []).add(t);
    }
    byVat.forEach((vatId, turns) {
      final maxRound = turns.map((t) => t.round).reduce((a, b) => a > b ? a : b);
      final roundsByMold = <String, Set<int>>{};
      for (final t in turns) {
        roundsByMold.putIfAbsent(t.moldId, () => {}).add(t.round);
      }
      // 参与翻模的模具：已有翻模记录的，以及本槽既非换模也非裂件的原始模具
      // （换模/裂件模具中途进入流程，不追究其进入前的轮次）。
      final candidates = <String>{
        ...roundsByMold.keys,
        ...ctx.molds
            .where((m) =>
                m.vatId == vatId && !m.isRemold && !m.isSplitPiece)
            .map((m) => m.id),
      };
      for (final moldId in candidates) {
        final recorded = roundsByMold[moldId] ?? const <int>{};
        // 换模/裂件模具只追究其已有记录之前的轮次之外的部分：
        // 以其首轮记录为起点，避免追究进入流程前的轮次。
        final firstRound =
            recorded.isEmpty ? 1 : recorded.reduce((a, b) => a < b ? a : b);
        for (var r = firstRound; r <= maxRound; r++) {
          if (!recorded.contains(r)) {
            findings.add(Finding(
              code: 'TURN_MISSED',
              severity: Severity.warning,
              vatId: vatId,
              relatedIds: {moldId},
              message: '槽 $vatId：模具 $moldId 缺少第 $r 轮翻模记录'
                  '（本槽已记录至第 $maxRound 轮），该模具进入人工处置；'
                  '其他模具记录不受影响。',
            ));
          }
        }
      }
    });
    return findings;
  }

  /// 裂件分件登记留痕（信息级）。
  List<Finding> _checkSplitPieces(TraceContext ctx) {
    final findings = <Finding>[];
    for (final m in ctx.molds) {
      if (m.isSplitPiece) {
        findings.add(Finding(
          code: 'TURN_SPLIT_REGISTERED',
          severity: Severity.info,
          vatId: m.vatId,
          relatedIds: {m.id, m.splitFromMoldId!},
          message: '槽 ${m.vatId}：模具 ${m.id} 为 ${m.splitFromMoldId} '
              '裂开分件的第二件（${m.splitAt?.toIso8601String() ?? '-'}），已登记。',
        ));
      }
    }
    return findings;
  }
}
