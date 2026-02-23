import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../domain/item.dart';
import '../../../domain/settings.dart';
import '../../../l10n/app_localizations.dart';
import '../state/play_notifier.dart';
import '../widgets/roulette_wheel.dart';
import '../widgets/stats_sheet.dart';
import '../../../core/widgets/app_background.dart';

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
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.notEnoughItems)),
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
    final l10n = AppLocalizations.of(context)!;
    try {
      final boundary =
          _wheelKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) throw Exception('capture failed');
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception('convert failed');
      final bytes = byteData.buffer.asUint8List();
      await Share.shareXFiles(
        [XFile.fromData(bytes, mimeType: 'image/png', name: 'roulette_result.png')],
        text: AppUtils.buildShareText(_notifier.roulette?.name ?? '', winner.label),
      );
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.shareImageFailed)),
      );
    }
  }

  void _showShareOptions(BuildContext sheetCtx, Item winner) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (dCtx) => SimpleDialog(
        title: Text(l10n.shareTitle),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(dCtx).pop();
              _shareText(winner);
            },
            child: ListTile(
              leading: const Icon(Icons.text_fields_outlined),
              title: Text(l10n.shareTextTitle),
              subtitle: Text(l10n.shareTextSubtitle),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(dCtx).pop();
              _shareImage(winner);
            },
            child: ListTile(
              leading: const Icon(Icons.image_outlined),
              title: Text(l10n.shareImageTitle),
              subtitle: Text(l10n.shareImageSubtitle),
            ),
          ),
        ],
      ),
    );
  }

  void _showResultSheet(Item winner) {
    final l10n = AppLocalizations.of(context)!;
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
            SnackBar(content: Text(l10n.copiedMessage)),
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
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.historyTitle,
              style: Theme.of(context).textTheme.titleLarge,
            )
                .animate()
                .fadeIn(duration: 300.ms)
                .slideY(begin: -0.3, end: 0.0, duration: 300.ms, curve: Curves.easeOut),
          ),
          Expanded(
            child: history.isEmpty
                ? Center(child: Text(l10n.noHistory))
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
                      )
                          .animate()
                          .slideY(
                            begin: 0.2,
                            end: 0.0,
                            duration: (200 + i * 30).ms,
                            curve: Curves.easeOut,
                          )
                          .fadeIn(duration: (200 + i * 30).ms);
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
    final l10n = AppLocalizations.of(context)!;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: AnimatedBuilder(
            animation: _notifier,
            builder: (_, _) => Text(
              _notifier.roulette?.name ?? l10n.playFallbackTitle,
              style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.8),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.bar_chart_rounded),
              tooltip: l10n.statsTooltip,
              onPressed: () {
                if (_notifier.roulette != null) _showStats();
              },
            )
                .animate()
                .fadeIn(duration: 300.ms)
                .scaleXY(begin: 0.8, end: 1.0, duration: 300.ms, curve: Curves.elasticOut),
            IconButton(
              icon: const Icon(Icons.history_rounded),
              tooltip: l10n.historyTooltip,
              onPressed: _showHistory,
            )
                .animate()
                .fadeIn(duration: 300.ms, delay: 50.ms)
                .scaleXY(begin: 0.8, end: 1.0, duration: 300.ms, delay: 50.ms, curve: Curves.elasticOut),
          ],
        ),
        body: AnimatedBuilder(
          animation: _notifier,
          builder: (context, _) {
            final roulette = _notifier.roulette;
            if (roulette == null) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
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
                                          MediaQuery.of(context).size.width * 0.82,
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
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                            child: _SpinModeSegment(
                              currentMode: _notifier.spinMode,
                              isDisabled: _notifier.isSpinning,
                              onModeSelected: _notifier.setSpinMode,
                            )
                                .animate()
                                .fadeIn(duration: 300.ms, delay: 100.ms)
                                .slideY(begin: 0.2, end: 0.0, duration: 300.ms, delay: 100.ms, curve: Curves.easeOut),
                          ),
                          // 커스텀 모드 설정 버튼 (복구)
                          Visibility(
                            visible: _notifier.spinMode == SpinMode.custom,
                            maintainSize: false,
                            maintainAnimation: true,
                            maintainState: true,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ChoiceChip(
                                      label: Text(l10n.noRepeat),
                                      selected: _notifier.noRepeat,
                                      onSelected: _notifier.isSpinning
                                          ? null
                                          : (val) => _notifier.setNoRepeat(val),
                                      avatar: Icon(
                                        _notifier.noRepeat ? Icons.check_circle_rounded : Icons.block_rounded,
                                        size: 16,
                                      ),
                                      showCheckmark: false,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ChoiceChip(
                                      label: Text(l10n.autoReset),
                                      selected: _notifier.autoReset,
                                      onSelected: (!_notifier.noRepeat || _notifier.isSpinning)
                                          ? null
                                          : (val) => _notifier.setAutoReset(val),
                                      avatar: Icon(
                                        _notifier.autoReset ? Icons.check_circle_rounded : Icons.refresh_rounded,
                                        size: 16,
                                      ),
                                      showCheckmark: false,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // 모드별 상태 표시
                          Visibility(
                            visible: (_notifier.noRepeat &&
                                    !_notifier.autoReset &&
                                    !_notifier.allPicked) ||
                                _notifier.spinMode == SpinMode.round,
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                              child: _notifier.spinMode == SpinMode.round
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.repeat_rounded,
                                            size: 13,
                                            color: colorScheme.onSurfaceVariant
                                                .withValues(alpha: 0.7)),
                                        const SizedBox(width: 5),
                                        Text(
                                          l10n.roundStatus(
                                              (_notifier.roulette?.items.length ?? 0) -
                                                  _notifier.remainingCount,
                                              _notifier.roulette?.items.length ?? 0),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: colorScheme.onSurfaceVariant
                                                .withValues(alpha: 0.7),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.person_remove_outlined,
                                            size: 13,
                                            color: colorScheme.onSurfaceVariant
                                                .withValues(alpha: 0.7)),
                                        const SizedBox(width: 5),
                                        Text(
                                          l10n.remainingItems(_notifier.remainingCount),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: colorScheme.onSurfaceVariant
                                                .withValues(alpha: 0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          // 중복 제외 모두 뽑음 안내
                          if (_notifier.allPicked && !_notifier.isSpinning)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle_rounded,
                                      color: colorScheme.primary, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    l10n.allPicked,
                                    style: TextStyle(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13),
                                  ),
                                  const SizedBox(width: 4),
                                  TextButton(
                                    onPressed: _notifier.resetExcluded,
                                    style: TextButton.styleFrom(
                                        visualDensity: VisualDensity.compact),
                                    child: Text(l10n.actionReset),
                                  ),
                                ],
                              ),
                            ),
                          // SPIN 버튼
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                            child: _SpinButton(
                              isSpinning: _notifier.isSpinning,
                              allPicked: _notifier.allPicked,
                              onSpin: _spin,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// ── 개선된 ResultSheet ──────────────────────────────────────

class _ResultSheet extends StatefulWidget {
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
  State<_ResultSheet> createState() => _ResultSheetState();
}

class _ResultSheetState extends State<_ResultSheet> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final winnerColor = widget.winner.color;
    final isLight = winnerColor.computeLuminance() > 0.4;
    final textColor = isLight ? Colors.black87 : Colors.white;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(colorScheme.surface, winnerColor, 0.08) ?? colorScheme.surface,
            colorScheme.surface,
          ],
        ),
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
          )
              .animate()
              .fadeIn(duration: 300.ms)
              .scaleXY(begin: 0.8, end: 1.0, duration: 300.ms, curve: Curves.easeOut),
          // ── 결과 요약 헤더 ──
          Container(
            margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
            decoration: BoxDecoration(
              color: winnerColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: winnerColor.withOpacity(0.35),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.emoji_events_rounded,
                    size: 32,
                    color: textColor,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.resultLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textColor.withOpacity(0.7),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.winner.label,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.0,
                          color: textColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
              .animate()
              .scaleXY(
                begin: 0.85,
                end: 1.05,
                duration: 200.ms,
                curve: Curves.easeInOut,
              )
              .then()
              .scaleXY(
                begin: 1.05,
                end: 1.0,
                duration: 100.ms,
                curve: Curves.easeInOut,
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
                        label: Text(l10n.actionReSpin),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: colorScheme.outlineVariant,
                          ),
                        ),
                        onPressed: widget.onReSpin,
                      )
                          .animate()
                          .slideY(begin: 0.2, end: 0.0, duration: 300.ms, delay: 250.ms, curve: Curves.easeOut)
                          .fadeIn(duration: 300.ms, delay: 250.ms),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: winnerColor,
                          foregroundColor: textColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: widget.onClose,
                        child: Text(
                          l10n.actionConfirm,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                          .animate()
                          .slideY(begin: 0.2, end: 0.0, duration: 300.ms, delay: 300.ms, curve: Curves.easeOut)
                          .fadeIn(duration: 300.ms, delay: 300.ms),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        icon: const Icon(Icons.copy_rounded, size: 18),
                        label: Text(l10n.actionCopy),
                        style: TextButton.styleFrom(
                          foregroundColor: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: widget.onCopy,
                      )
                          .animate()
                          .slideY(begin: 0.1, end: 0.0, duration: 300.ms, delay: 350.ms, curve: Curves.easeOut)
                          .fadeIn(duration: 300.ms, delay: 350.ms),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        icon: const Icon(Icons.ios_share_rounded, size: 18),
                        label: Text(l10n.shareTitle),
                        style: TextButton.styleFrom(
                          foregroundColor: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: widget.onShare,
                      )
                          .animate()
                          .slideY(begin: 0.1, end: 0.0, duration: 300.ms, delay: 400.ms, curve: Curves.easeOut)
                          .fadeIn(duration: 300.ms, delay: 400.ms),
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
    final l10n = AppLocalizations.of(context)!;
    final modes = [
      (SpinMode.lottery, l10n.modeLottery),
      (SpinMode.round, l10n.modeRound),
      (SpinMode.custom, l10n.modeCustom),
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
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final isDisabled = isSpinning || allPicked;

    return SizedBox(
      width: double.infinity,
      height: 64,
      child: _PremiumSpinButton(
        onPressed: isDisabled ? null : onSpin,
        isSpinning: isSpinning,
        label: allPicked ? l10n.allPicked : l10n.spinLabel,
        color: cs.primary,
      ),
    );
  }
}

class _PremiumSpinButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isSpinning;
  final String label;
  final Color color;

  const _PremiumSpinButton({
    required this.onPressed,
    required this.isSpinning,
    required this.label,
    required this.color,
  });

  @override
  State<_PremiumSpinButton> createState() => _PremiumSpinButtonState();
}

class _PremiumSpinButtonState extends State<_PremiumSpinButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null;
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                widget.color,
                Color.lerp(widget.color, Colors.black, 0.1) ?? widget.color,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(isDisabled ? 0 : 0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: widget.isSpinning
                  ? Row(
                      key: const ValueKey('spinning'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          AppLocalizations.of(context)!.spinningLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      widget.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
