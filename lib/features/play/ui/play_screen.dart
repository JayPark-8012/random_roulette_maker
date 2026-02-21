import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:share_plus/share_plus.dart';
import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../domain/item.dart';
import '../../../domain/settings.dart';
import '../state/play_notifier.dart';
import '../widgets/roulette_wheel.dart';
import '../widgets/stats_sheet.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen>
    with SingleTickerProviderStateMixin {
  final PlayNotifier _notifier = PlayNotifier();
  late AnimationController _animController;
  late Animation<double> _rotationAnim;
  double _currentAngle = 0;
  final GlobalKey _wheelKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this);
    _rotationAnim = const AlwaysStoppedAnimation(0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = ModalRoute.of(context)?.settings.arguments as String?;
    if (id != null) {
      _notifier.load(id).then((_) {
        if (!mounted) return;
        // 항목 2개 미만 체크
        if ((_notifier.roulette?.items.length ?? 0) < AppLimits.minItemCount) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('항목이 부족합니다. 편집 화면에서 추가해 주세요.')),
          );
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.editor,
            arguments: _notifier.roulette,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _notifier.dispose();
    super.dispose();
  }

  // debugSeed: 동일 결과 재현용 (null이면 Random() 사용)
  void _spin({int? debugSeed}) {
    if (_notifier.isSpinning) return;
    final allItems = _notifier.roulette?.items;
    if (allItems == null || allItems.length < AppLimits.minItemCount) return;

    // 중복 제외 모드: 뽑을 수 있는 항목 중에서 선택
    final candidates = _notifier.availableItems;
    if (candidates.isEmpty) return;

    _notifier.startSpin();

    final random = debugSeed != null ? Random(debugSeed) : Random();

    // 1. 가중치 기반 추첨 (weight=1이면 균등 확률과 동일)
    final totalWeight = candidates.fold<int>(0, (s, i) => s + i.weight);
    int pick = random.nextInt(totalWeight);
    Item winnerItem = candidates.last;
    for (final item in candidates) {
      pick -= item.weight;
      if (pick < 0) {
        winnerItem = item;
        break;
      }
    }
    final winnerIndex = candidates.indexOf(winnerItem);

    // 2. 가중치 비례 섹터 중앙에 포인터(12시)가 오는 각도 역산
    double winnerStartFraction = 0;
    for (int i = 0; i < winnerIndex; i++) {
      winnerStartFraction += candidates[i].weight / totalWeight;
    }
    final winnerFraction = candidates[winnerIndex].weight / totalWeight;
    final targetNormalized =
        (winnerStartFraction + winnerFraction / 2) * 2 * pi;
    final finalCycleAngle = (2 * pi - targetNormalized) % (2 * pi);

    final currentCycleAngle = _currentAngle % (2 * pi);
    final deltaAngle =
        (finalCycleAngle - currentCycleAngle + 2 * pi) % (2 * pi);

    // 3~5회전 후 섹터 중앙에 정확히 멈춤
    final extraRotations = SpinConfig.minExtraRotations +
        random.nextInt(
            SpinConfig.maxExtraRotations - SpinConfig.minExtraRotations + 1);
    final targetAngle = _currentAngle + extraRotations * 2 * pi + deltaAngle;

    final duration = switch (_notifier.settings.spinDuration) {
      SpinDuration.short => SpinConfig.shortDuration,
      SpinDuration.long => SpinConfig.longDuration,
      SpinDuration.normal => SpinConfig.normalDuration,
    };

    _animController.duration = duration;
    _rotationAnim = Tween<double>(
      begin: _currentAngle,
      end: targetAngle,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));

    _animController
      ..reset()
      ..forward().then((_) {
        if (!mounted) return;
        _currentAngle = targetAngle % (2 * pi);
        _notifier.finishSpin(winnerItem).then((_) {
          if (!mounted) return;
          if (_notifier.noRepeat) {
            setState(() {
              _currentAngle = 0;
              _rotationAnim = const AlwaysStoppedAnimation(0);
            });
          }
          _showResultSheet(winnerItem);
        });
      });
  }

  Future<void> _shareText(Item winner) async {
    await Share.share(
      AppUtils.buildShareText(_notifier.roulette?.name ?? '', winner.label),
    );
  }

  Future<void> _shareImage(Item winner) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final boundary =
          _wheelKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) throw Exception('캡처 불가');
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception('변환 실패');
      final bytes = byteData.buffer.asUint8List();
      await Share.shareXFiles(
        [XFile.fromData(bytes, mimeType: 'image/png', name: 'roulette_result.png')],
        text: AppUtils.buildShareText(_notifier.roulette?.name ?? '', winner.label),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('이미지 공유에 실패했습니다.')),
      );
    }
  }

  void _showShareOptions(BuildContext sheetCtx, Item winner) {
    showDialog<void>(
      context: context,
      builder: (dCtx) => SimpleDialog(
        title: const Text('공유'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(dCtx).pop();
              _shareText(winner);
            },
            child: const ListTile(
              leading: Icon(Icons.text_fields_outlined),
              title: Text('텍스트 공유'),
              subtitle: Text('룰렛명과 결과를 텍스트로'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(dCtx).pop();
              _shareImage(winner);
            },
            child: const ListTile(
              leading: Icon(Icons.image_outlined),
              title: Text('이미지 공유'),
              subtitle: Text('룰렛 화면을 이미지로'),
            ),
          ),
        ],
      ),
    );
  }

  void _showResultSheet(Item winner) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _ResultSheet(
        winner: winner,
        rouletteName: _notifier.roulette?.name ?? '',
        onReSpin: () {
          Navigator.of(ctx).pop();
          _notifier.resetSpin();
          Future.microtask(_spin);
        },
        onClose: () => Navigator.of(ctx).pop(),
        onCopy: () async {
          final text = AppUtils.buildShareText(
            _notifier.roulette?.name ?? '',
            winner.label,
          );
          final navigator = Navigator.of(ctx);
          final messenger = ScaffoldMessenger.of(context);
          await Clipboard.setData(ClipboardData(text: text));
          navigator.pop();
          messenger.showSnackBar(
            const SnackBar(content: Text('결과를 클립보드에 복사했습니다.')),
          );
        },
        onShare: () => _showShareOptions(ctx, winner),
      ),
    ).then((_) => _notifier.resetSpin());
  }

  void _showStats() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.72,
        child: StatsSheet(
          roulette: _notifier.roulette!,
          history: _notifier.history,
        ),
      ),
    );
  }

  void _showHistory() {
    final history = _notifier.history;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '최근 결과',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: history.isEmpty
                ? const Center(child: Text('아직 기록이 없습니다.'))
                : ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (_, i) {
                      final h = history[history.length - 1 - i]; // 최신순
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: h.resultColor,
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(h.resultLabel),
                        subtitle: Text(
                          AppUtils.formatRelativeDate(h.playedAt),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: AnimatedBuilder(
          animation: _notifier,
          builder: (_, _) => Text(
            _notifier.roulette?.name ?? '룰렛',
            style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.8),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            tooltip: '통계',
            onPressed: () {
              if (_notifier.roulette != null) _showStats();
            },
          ),
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: '히스토리',
            onPressed: _showHistory,
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _notifier,
        builder: (context, _) {
          final roulette = _notifier.roulette;
          if (roulette == null) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          return Column(
            children: [
              Expanded(
                child: RepaintBoundary(
                  key: _wheelKey,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const RoulettePointer(),
                        AnimatedBuilder(
                          animation: _animController,
                          builder: (_, _) => CustomPaint(
                            painter: RouletteWheelPainter(
                              items: _notifier.availableItems,
                              rotationAngle: _rotationAnim.value,
                            ),
                            size: Size.square(
                              MediaQuery.of(context).size.width * 0.85,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // 모드 세그먼트
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 6),
                child: _SpinModeSegment(
                  currentMode: _notifier.spinMode,
                  isDisabled: _notifier.isSpinning,
                  onModeSelected: _notifier.setSpinMode,
                ),
              ),
              // 모드별 상태 표시
              if (_notifier.noRepeat && !_notifier.autoReset && !_notifier.allPicked)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                  child: Row(
                    children: [
                      Icon(Icons.person_remove_outlined,
                          size: 13,
                          color: colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.7)),
                      const SizedBox(width: 5),
                      Text(
                        '남은 항목 ${_notifier.remainingCount}개',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_notifier.spinMode == SpinMode.round)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                  child: Row(
                    children: [
                      Icon(Icons.repeat_rounded,
                          size: 13,
                          color: colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.7)),
                      const SizedBox(width: 5),
                      Text(
                        '라운드 ${_notifier.roundNum} / ${_notifier.roulette?.items.length ?? 0}개',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              Visibility(
                visible: _notifier.spinMode == SpinMode.custom,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 2, 20, 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: FilterChip(
                          label: const Text('중복 제외'),
                          selected: _notifier.noRepeat,
                          onSelected: _notifier.isSpinning
                              ? null
                              : _notifier.setNoRepeat,
                          avatar:
                              const Icon(Icons.block_rounded, size: 16),
                          showCheckmark: false,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilterChip(
                          label: const Text('자동 리셋'),
                          selected: _notifier.autoReset,
                          onSelected:
                              (_notifier.noRepeat && !_notifier.isSpinning)
                                  ? _notifier.setAutoReset
                                  : null,
                          avatar:
                              const Icon(Icons.refresh_rounded, size: 16),
                          showCheckmark: false,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_notifier.allPicked)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 16, 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded,
                          color: colorScheme.primary, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '모든 항목을 뽑았습니다!',
                          style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      TextButton(
                        onPressed: _notifier.resetExcluded,
                        child: const Text('리셋'),
                      ),
                    ],
                  ),
                ),
              // SPIN 버튼
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
                child: _SpinButton(
                  isSpinning: _notifier.isSpinning,
                  allPicked: _notifier.allPicked,
                  onSpin: _spin,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── 개선된 ResultSheet ──────────────────────────────────────

class _ResultSheet extends StatelessWidget {
  final Item winner;
  final String rouletteName;
  final VoidCallback onReSpin;
  final VoidCallback onClose;
  final VoidCallback onCopy;
  final VoidCallback onShare;

  const _ResultSheet({
    required this.winner,
    required this.rouletteName,
    required this.onReSpin,
    required this.onClose,
    required this.onCopy,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final winnerColor = winner.color;
    final isLight = winnerColor.computeLuminance() > 0.4;
    final textColor = isLight ? Colors.black87 : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── 슈딧 핸들 ──
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // ── 색상 헤더 영역 ──
          Container(
            margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
            decoration: BoxDecoration(
              color: winnerColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: winnerColor.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: winnerColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: winnerColor.withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.emoji_events_rounded,
                    size: 32,
                    color: isLight ? Colors.black54 : Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '당쳊 항목',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        winner.label,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.0,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // ── 버튼 영역 ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('다시 돌리기'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: colorScheme.outlineVariant,
                          ),
                        ),
                        onPressed: onReSpin,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: winnerColor,
                          foregroundColor: textColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: onClose,
                        child: const Text(
                          '확인',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        icon: const Icon(Icons.copy_rounded, size: 18),
                        label: const Text('내용 복사'),
                        style: TextButton.styleFrom(
                          foregroundColor: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: onCopy,
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        icon: const Icon(Icons.ios_share_rounded, size: 18),
                        label: const Text('공유'),
                        style: TextButton.styleFrom(
                          foregroundColor: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: onShare,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── 모드 세그먼트 ─────────────────────────────────────────

class _SpinModeSegment extends StatelessWidget {
  final SpinMode currentMode;
  final bool isDisabled;
  final ValueChanged<SpinMode> onModeSelected;

  const _SpinModeSegment({
    required this.currentMode,
    required this.isDisabled,
    required this.onModeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const modes = [
      (SpinMode.lottery, '추첨'),
      (SpinMode.round, '라운드'),
      (SpinMode.custom, '커스텀'),
    ];

    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: modes.map((entry) {
          final (mode, label) = entry;
          final isSelected = currentMode == mode;
          final canTap = !isDisabled;

          return Expanded(
            child: GestureDetector(
              onTap: canTap ? () => onModeSelected(mode) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: isSelected ? cs.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                  border: isSelected
                      ? Border.all(
                          color: cs.outlineVariant.withValues(alpha: 0.6),
                          width: 0.5)
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: cs.shadow.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          )
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: isSelected
                          ? cs.onSurface
                          : cs.onSurfaceVariant.withValues(alpha: 0.65),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── 개선된 SPIN 버튼 ──────────────────────────────────────

class _SpinButton extends StatelessWidget {
  final bool isSpinning;
  final bool allPicked;
  final VoidCallback onSpin;

  const _SpinButton({
    required this.isSpinning,
    required this.allPicked,
    required this.onSpin,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDisabled = isSpinning || allPicked;

    return SizedBox(
      width: double.infinity,
      height: 64,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: isDisabled
              ? []
              : [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: FilledButton(
          onPressed: isDisabled ? null : onSpin,
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isSpinning
                ? Row(
                    key: const ValueKey('spinning'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: colorScheme.onPrimary.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        '돌아가는 중...',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                    ],
                  )
                : Text(
                    allPicked ? '모두 뉵힐' : 'SPIN',
                    key: const ValueKey('spin'),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
