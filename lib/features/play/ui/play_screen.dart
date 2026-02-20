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

    final duration = _notifier.settings.spinSpeed == SpinSpeed.fast
        ? SpinConfig.fastDuration
        : SpinConfig.normalDuration;

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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(32, 12, 32, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: winner.color,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.emoji_events, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              winner.label,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '당첨!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.copy),
                    label: const Text('결과 복사'),
                    onPressed: () async {
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
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('다시 돌리기'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _notifier.resetSpin();
                      Future.microtask(_spin);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.share_outlined),
                    label: const Text('공유'),
                    onPressed: () => _showShareOptions(ctx, winner),
                  ),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('닫기'),
                ),
              ],
            ),
          ],
        ),
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
    return Scaffold(
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: _notifier,
          builder: (_, _) =>
              Text(_notifier.roulette?.name ?? '룰렛'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_outlined),
            tooltip: '통계',
            onPressed: () {
              if (_notifier.roulette != null) _showStats();
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
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
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // 룰렛 휠 영역 — RepaintBoundary로 이미지 캡처 대상 지정
              Expanded(
                child: RepaintBoundary(
                  key: _wheelKey,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      // 포인터 (12시, 휠 상단에 밀착)
                      const RoulettePointer(),
                      // 휠
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
              // ── 모드 토글 ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: FilterChip(
                        label: const Text('중복 제외'),
                        selected: _notifier.noRepeat,
                        onSelected: _notifier.isSpinning
                            ? null
                            : _notifier.setNoRepeat,
                        avatar: const Icon(Icons.block_outlined, size: 16),
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
                        avatar: const Icon(Icons.refresh, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
              // ── 모두 뽑힘 배너 ─────────────────────────────
              if (_notifier.allPicked)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 16, 0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          color:
                              Theme.of(context).colorScheme.primary,
                          size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '모든 항목을 뽑았습니다!',
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      TextButton(
                        onPressed: _notifier.resetExcluded,
                        child: const Text('리셋'),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              // SPIN 버튼
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: FilledButton(
                    onPressed: (_notifier.isSpinning || _notifier.allPicked)
                        ? null
                        : _spin,
                    child: Text(
                      _notifier.isSpinning
                          ? '돌아가는 중...'
                          : _notifier.allPicked
                              ? '모두 뽑힘'
                              : 'SPIN',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
