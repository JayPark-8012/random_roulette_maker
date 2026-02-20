import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../domain/item.dart';
import '../../../domain/settings.dart';
import '../state/play_notifier.dart';
import '../widgets/roulette_wheel.dart';

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
    final items = _notifier.roulette?.items;
    if (items == null || items.length < AppLimits.minItemCount) return;

    _notifier.startSpin();

    final random = debugSeed != null ? Random(debugSeed) : Random();

    // 1. 결과 index 먼저 결정 (균등 확률)
    final winnerIndex = random.nextInt(items.length);

    // 2. 당첨 섹터 중앙에 포인터(12시)가 오는 각도 역산
    //    페인터: 섹터 i 시작 = i * sectorAngle - π/2 (+ rotationAngle)
    //    섹터 i 중앙 normalizedAngle = (i + 0.5) * sectorAngle
    //    normalizedAngle = (2π - rotationAngle % 2π) % 2π 의 역관계
    final sectorAngle = 2 * pi / items.length;
    final targetNormalized = (winnerIndex + 0.5) * sectorAngle;
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
        final winner = items[winnerIndex];
        _notifier.finishSpin(winner).then((_) {
          if (mounted) _showResultSheet(winner);
        });
      });
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
                    onPressed: () {
                      // TODO(Phase2): Clipboard.setData 연동
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppUtils.buildShareText(
                            _notifier.roulette?.name ?? '',
                            winner.label,
                          )),
                        ),
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
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('닫기'),
            ),
          ],
        ),
      ),
    ).then((_) => _notifier.resetSpin());
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
              // 룰렛 휠 영역 — 포인터와 휠을 하나의 Column으로 묶어 간격 고정
              Expanded(
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
                            items: roulette.items,
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
              // SPIN 버튼
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: FilledButton(
                    onPressed: _notifier.isSpinning ? null : _spin,
                    child: Text(
                      _notifier.isSpinning ? '돌아가는 중...' : 'SPIN',
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
