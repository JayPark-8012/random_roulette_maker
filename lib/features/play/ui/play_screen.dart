import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants.dart';
import '../../../core/design_tokens.dart';
import '../../../core/roulette_wheel_themes.dart';
import '../../../core/utils.dart';
import '../../../domain/item.dart';
import '../../../domain/settings.dart';
import '../../../l10n/app_localizations.dart';
import '../state/play_notifier.dart';
import '../widgets/roulette_wheel.dart';
import '../widgets/stats_sheet.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../data/ad_service.dart';
import '../../settings/state/settings_notifier.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen>
    with TickerProviderStateMixin {
  final PlayNotifier _notifier = PlayNotifier();
  late AnimationController _animController;
  late Animation<double> _rotationAnim;
  double _currentAngle = 0;
  final GlobalKey _wheelKey = GlobalKey();

  // 결과 오버레이 상태
  Item? _resultWinner;
  late AnimationController _resultSlideCtrl;
  late Animation<Offset> _resultSlideAnim;

  // 인터랙티브 드래그 상태
  bool _isDragging = false;
  double _dragAngle = 0;    // 드래그 중 실시간 각도
  double _wheelRadius = 0;  // 드래그 시작 시 캐시

  // 포인터 틱 애니메이션
  late AnimationController _pointerController;
  late Animation<double> _pointerAnim; // 0→1→-0.2→0 (꺾임 후 스프링 복귀)
  double _pointerKickAngle = 0;        // 현재 틱의 최대 꺾임 각도(라디안)
  int _pointerSectorIndex = -1;        // 직전 프레임의 섹터 인덱스
  double _prevAngle = 0;               // 직전 프레임 회전각 (속도/방향 계산용)

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this);
    _rotationAnim = const AlwaysStoppedAnimation(0);
    _animController.addListener(_onWheelTick);

    _pointerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _resultSlideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _resultSlideAnim = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _resultSlideCtrl,
      curve: Curves.easeOutCubic,
    ));
    // 꺾임(0→1) → 스프링 반동(1→-0.2) → 안정(-0.2→0)
    _pointerAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: -0.2)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -0.2, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
    ]).animate(_pointerController);
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
    _animController.removeListener(_onWheelTick);
    _animController.dispose();
    _pointerController.dispose();
    _resultSlideCtrl.dispose();
    _notifier.dispose();
    super.dispose();
  }

  // 스왑 속도(px/s)를 spinDuration 기준으로 비례 단축
  // 느린 스왑(300 px/s) → 기본 duration, 빠른 스왑(3000+ px/s) → 35% 단축
  Duration _velocityToDuration(Duration base, double velocityPxPerSec) {
    final factor = ((velocityPxPerSec - SpinConfig.swipeMinVelocity) /
            (SpinConfig.swipeMaxVelocity - SpinConfig.swipeMinVelocity))
        .clamp(0.0, 1.0);
    final ms = (base.inMilliseconds * (1.0 - factor * 0.65)).round();
    return Duration(milliseconds: ms.clamp(900, base.inMilliseconds));
  }

  // ── 포인터 틱 애니메이션 ─────────────────────────────────────

  /// 스핀 애니메이션 매 프레임마다 호출 — 섹터 경계 통과 시 틱 발동
  void _onWheelTick() {
    if (!_notifier.isSpinning) return;
    _checkSectorCrossing(_rotationAnim.value);
  }

  /// 현재 회전각 기준으로 포인터(12시)가 위치한 섹터 인덱스를 계산,
  /// 섹터가 바뀌면 _triggerPointerTick 호출
  void _checkSectorCrossing(double currentAngle) {
    final items = _notifier.availableItems;
    if (items.isEmpty) return;

    final totalWeight = items.fold<int>(0, (s, i) => s + i.weight);

    // 포인터(화면 -π/2) → 휠 로컬 기준 섹터 위치
    // sector 0 이 로컬 -π/2 에서 시작하므로: φ = -currentAngle (mod 2π)
    final sectorAngle =
        ((-currentAngle) % (2 * pi) + 2 * pi) % (2 * pi);

    int sectorIndex = items.length - 1;
    double accumulated = 0;
    for (int i = 0; i < items.length; i++) {
      accumulated += 2 * pi * items[i].weight / totalWeight;
      if (sectorAngle < accumulated) {
        sectorIndex = i;
        break;
      }
    }

    if (_pointerSectorIndex >= 0 && sectorIndex != _pointerSectorIndex) {
      final speedRad = (currentAngle - _prevAngle).abs();
      _triggerPointerTick(speedRad, currentAngle);
    }

    _pointerSectorIndex = sectorIndex;
    _prevAngle = currentAngle;
  }

  /// 포인터 틱 1회 실행: 속도에 비례한 꺾임 각도 + 방향 결정
  void _triggerPointerTick(double speedRad, double currentAngle) {
    // speedRad: 한 프레임 간 변화량(라디안) — 느림~0.01, 빠름~0.15
    final speedFactor = (speedRad / 0.12).clamp(0.0, 1.0);
    final kickRad = (5.0 + speedFactor * 20.0) * pi / 180; // 5°~25°
    // 회전 방향과 같은 방향으로 꺾임
    final direction = currentAngle >= _prevAngle ? 1.0 : -1.0;
    _pointerKickAngle = kickRad * direction;
    _pointerController.forward(from: 0);
  }

  // ── 인터랙티브 드래그 핸들러 ────────────────────────────────

  void _onPanStart(DragStartDetails details) {
    if (_notifier.isSpinning) return;
    _prevAngle = _currentAngle;
    _pointerSectorIndex = -1; // 드래그 시작 시 직전 섹터 리셋 → 첫 틱 오작동 방지
    setState(() {
      _isDragging = true;
      _dragAngle = _currentAngle;
      // 드래그 δx / 반지름 = 회전 라디안 → 반지름 캐시
      _wheelRadius = MediaQuery.of(context).size.width * 0.92 / 2;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;
    final newAngle = _dragAngle - details.delta.dx / _wheelRadius;
    _checkSectorCrossing(newAngle);
    setState(() => _dragAngle = newAngle);
  }

  void _onPanEnd(DragEndDetails details) {
    if (!_isDragging) return;
    setState(() => _isDragging = false);

    final velocity = details.velocity.pixelsPerSecond.distance;

    // 드래그 위치를 _currentAngle 에 반영 (스핀 시작각 동기화)
    _currentAngle = _dragAngle % (2 * 3.141592653589793);

    if (velocity < SpinConfig.swipeMinVelocity) {
      // 속도 부족 → 드래그 위치에 그냥 멈춤
      _rotationAnim = AlwaysStoppedAnimation(_currentAngle);
      return;
    }
    // 속도 충분 → 현재 각도 기준으로 스핀 시작
    _spin(swipeVelocity: velocity);
  }

  // debugSeed: 동일 결과 재현용 (null이면 Random() 사용)
  void _spin({int? debugSeed, double swipeVelocity = 0}) {
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

    // 2. 가중치 비례 섹터 내 랜덤 위치 역산
    //    섹터 중앙(0.5) 대신 15%~85% 내 랜덤 → 항상 중앙에 멈추는 인위적 느낌 제거
    double winnerStartFraction = 0;
    for (int i = 0; i < winnerIndex; i++) {
      winnerStartFraction += candidates[i].weight / totalWeight;
    }
    final winnerFraction = candidates[winnerIndex].weight / totalWeight;
    final sectorOffset = 0.15 + random.nextDouble() * 0.70;
    final targetNormalized =
        (winnerStartFraction + winnerFraction * sectorOffset) * 2 * pi;
    final finalCycleAngle = (2 * pi - targetNormalized) % (2 * pi);

    final currentCycleAngle = _currentAngle % (2 * pi);
    final deltaAngle =
        (finalCycleAngle - currentCycleAngle + 2 * pi) % (2 * pi);

    // 설정별 회전 수 범위 (duration과 짝맞춤 → 일관된 초기 속도 느낌)
    final (minRot, maxRot) = switch (_notifier.settings.spinDuration) {
      SpinDuration.short  => (3, 4),
      SpinDuration.normal => (5, 7),
      SpinDuration.long   => (8, 11),
    };
    final extraRotations = minRot + random.nextInt(maxRot - minRot + 1);
    final totalAngle = extraRotations * 2 * pi + deltaAngle;
    final targetAngle = _currentAngle + totalAngle;

    // 설정별 고정 duration — 등감속(Curves.decelerate)으로 t=1 에서 속도 = 0
    final baseDuration = switch (_notifier.settings.spinDuration) {
      SpinDuration.short  => SpinConfig.shortDuration,
      SpinDuration.normal => SpinConfig.normalDuration,
      SpinDuration.long   => SpinConfig.longDuration,
    };
    final duration = swipeVelocity > 0
        ? _velocityToDuration(baseDuration, swipeVelocity)
        : baseDuration;

    // Curves.decelerate = 1-(1-t)² → 속도 v(t) = 2(1-t), 리니어하게 감소 → t=1 에서 v=0
    _pointerSectorIndex = -1; // 스핀 시작 시 섹터 리셋 → 첫 틱 오작동 방지
    _animController.duration = duration;
    _rotationAnim = Tween<double>(
      begin: _currentAngle,
      end: targetAngle,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.decelerate,
    ));

    _animController
      ..reset()
      ..forward().then((_) {
        if (!mounted) return;
        _currentAngle = targetAngle % (2 * pi);
        _notifier.finishSpin(winnerItem).then((_) async {
          if (!mounted) return;
          if (_notifier.noRepeat) {
            setState(() {
              _currentAngle = 0;
              _rotationAnim = const AlwaysStoppedAnimation(0);
            });
          }
          await AdService.instance.tryShowInterstitialAfterSpin();
          if (!mounted) return;
          _showResultSheet(winnerItem);
        });
      });
  }

  Future<void> _shareText(Item winner) async {
    final l10n = AppLocalizations.of(context)!;
    await Share.share(
      l10n.shareResultText(_notifier.roulette?.name ?? '', winner.label),
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
        text: l10n.shareResultText(_notifier.roulette?.name ?? '', winner.label),
      );
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.shareImageFailed)),
      );
    }
  }

  void _showResultSheet(Item winner) {
    setState(() => _resultWinner = winner);
    _resultSlideCtrl.forward(from: 0);
  }

  void _onResultClose() {
    _resultSlideCtrl.reverse().then((_) {
      if (mounted) {
        _notifier.resetSpin();
        setState(() => _resultWinner = null);
      }
    });
  }

  void _onResultReSpin() {
    _resultSlideCtrl.reverse().then((_) {
      if (mounted) {
        _notifier.resetSpin();
        setState(() => _resultWinner = null);
        Future.microtask(_spin);
      }
    });
  }

  Future<void> _onResultCopy() async {
    if (_resultWinner == null) return;
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final text = l10n.shareResultText(
      _notifier.roulette?.name ?? '',
      _resultWinner!.label,
    );
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    messenger.showSnackBar(SnackBar(content: Text(l10n.copiedMessage)));
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
                          AppUtils.formatRelativeDate(
                            h.playedAt,
                            today: l10n.dateToday,
                            yesterday: l10n.dateYesterday,
                            daysAgo: l10n.dateDaysAgo,
                          ),
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

    return PopScope(
      canPop: _resultWinner == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _resultWinner != null) _onResultClose();
      },
      child: AppBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // ── 사이언 빛 번짐 (좌상단) ──
              Positioned(
                top: -60,
                left: -40,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Color(0x1200D4FF), Colors.transparent],
                    ),
                  ),
                ),
              ),
              // ── 퍼플 빛 번짐 (우하단) ──
              Positioned(
                bottom: -60,
                right: -40,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Color(0x0F7B61FF), Colors.transparent],
                    ),
                  ),
                ),
              ),
              SafeArea(
                bottom: false,
                child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 슬림 커스텀 헤더 ──
              AnimatedBuilder(
                animation: _notifier,
                builder: (_, _) => Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Row(
                    children: [
                      _NavIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _notifier.roulette?.name ?? l10n.playFallbackTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                            fontSize: 17,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _NavIconButton(
                        icon: Icons.bar_chart_rounded,
                        onPressed: () {
                          if (_notifier.roulette != null) _showStats();
                        },
                      ),
                      const SizedBox(width: 8),
                      _NavIconButton(
                        icon: Icons.history_rounded,
                        onPressed: _showHistory,
                      ),
                    ],
                  ),
                ),
              ),
              // ── 본문 ──
              Expanded(
                child: AnimatedBuilder(
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
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onPanStart: _onPanStart,
                              onPanUpdate: _onPanUpdate,
                              onPanEnd: _onPanEnd,
                              child: RepaintBoundary(
                                key: _wheelKey,
                                child: Center(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.92,
                                    child: Stack(
                                      alignment: Alignment.topCenter,
                                      children: [
                                        // ① 휠: 포인터 높이 절반(24px)만큼 아래로 → 50% 중첩
                                        Padding(
                                          padding: const EdgeInsets.only(top: 28),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white.withValues(alpha: 0.10),
                                                width: 2,
                                              ),
                                              boxShadow: const [
                                                // 안쪽 글로우
                                                BoxShadow(
                                                  color: Color(0x4000D4FF),
                                                  blurRadius: 16,
                                                  spreadRadius: 4,
                                                ),
                                                // 바깥쪽 글로우
                                                BoxShadow(
                                                  color: Color(0x1A00D4FF),
                                                  blurRadius: 40,
                                                  spreadRadius: 0,
                                                ),
                                              ],
                                            ),
                                            child: AnimatedBuilder(
                                              animation: _animController,
                                              builder: (_, _) => CustomPaint(
                                                painter: RouletteWheelPainter(
                                                  items: _notifier.availableItems,
                                                  rotationAngle: _isDragging
                                                      ? _dragAngle
                                                      : _rotationAnim.value,
                                                  primaryColor: AppColors.primary,
                                                  wheelTheme: findWheelThemeById(
                                                    SettingsNotifier.instance.wheelThemeId,
                                                  ),
                                                ),
                                                size: Size.square(
                                                  MediaQuery.of(context).size.width * 0.92,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // ③ 포인터: 휠 위에 렌더 + 섹터 틱 회전 애니메이션
                                        AnimatedBuilder(
                                          animation: _pointerController,
                                          builder: (_, child) => Transform.rotate(
                                            angle: _pointerKickAngle * _pointerAnim.value,
                                            alignment: Alignment.topCenter,
                                            child: child,
                                          ),
                                          child: const RoulettePointer(),
                                        ),
                                      ],
                                    ),
                                  ),
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
            ],
          ),
        ),
        // ── 결과 전체화면 오버레이 ──
        if (_resultWinner != null)
          SlideTransition(
            position: _resultSlideAnim,
            child: _ResultOverlay(
              winner: _resultWinner!,
              rouletteName: _notifier.roulette?.name ?? '',
              onReSpin: _onResultReSpin,
              onClose: _onResultClose,
              onCopy: _onResultCopy,
              onShareText: () => _shareText(_resultWinner!),
              onShareImage: () => _shareImage(_resultWinner!),
              spinMode: _notifier.spinMode,
              remainingCount: _notifier.remainingCount,
              totalCount: _notifier.roulette?.items.length ?? 0,
              allPicked: _notifier.allPicked,
              onReset: () {
                _notifier.resetExcluded();
                _onResultClose();
              },
            ),
          ),
      ],
    ),
        ),
      ),
    );
  }
}

// ── 전체화면 결과 오버레이 ────────────────────────────────────

class _ResultOverlay extends StatefulWidget {
  final Item winner;
  final String rouletteName;
  final VoidCallback onReSpin;
  final VoidCallback onClose;
  final VoidCallback onCopy;
  final VoidCallback onShareText;
  final VoidCallback onShareImage;
  final SpinMode spinMode;
  final int remainingCount;
  final int totalCount;
  final bool allPicked;
  final VoidCallback onReset;

  const _ResultOverlay({
    required this.winner,
    required this.rouletteName,
    required this.onReSpin,
    required this.onClose,
    required this.onCopy,
    required this.onShareText,
    required this.onShareImage,
    required this.spinMode,
    required this.remainingCount,
    required this.totalCount,
    required this.allPicked,
    required this.onReset,
  });

  @override
  State<_ResultOverlay> createState() => _ResultOverlayState();
}

class _ResultOverlayState extends State<_ResultOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _flashCtrl;
  late final AnimationController _confettiCtrl;
  late final AnimationController _bounceCtrl;

  @override
  void initState() {
    super.initState();
    _flashCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..forward();
    _confettiCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..forward();
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _flashCtrl.dispose();
    _confettiCtrl.dispose();
    _bounceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final winnerColor = widget.winner.color;

    return BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: 22, sigmaY: 22),
      child: Container(
        color: Colors.black.withValues(alpha: 0.70),
        child: Stack(
          children: [
            // ── 메인 콘텐츠 ───────────────────────────
            SafeArea(
              child: Column(
                children: [
                  // 상단 닫기 버튼
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 4, 8, 0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close_rounded,
                              color: Colors.white70),
                          onPressed: widget.onClose,
                        ),
                      ],
                    ),
                  ),
                  // 당첨 표시 영역 (flex)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 트로피 원형 아이콘 (primary 그라데이션 + 펄스 링 + 바운스 12px)
                          AnimatedBuilder(
                            animation: _bounceCtrl,
                            builder: (_, child) => Transform.translate(
                              offset: Offset(
                                  0,
                                  -12 *
                                      Curves.easeInOut
                                          .transform(_bounceCtrl.value)),
                              child: child,
                            ),
                            child: SizedBox(
                              width: 170,
                              height: 170,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // 펄스 링 애니메이션 (Primary 20%)
                                  AnimatedBuilder(
                                    animation: _bounceCtrl,
                                    builder: (_, _) {
                                      final scale = 1.0 + _bounceCtrl.value * 0.15;
                                      final opacity = (1.0 - _bounceCtrl.value) * 0.20;
                                      return Transform.scale(
                                        scale: scale,
                                        child: Container(
                                          width: 160,
                                          height: 160,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: AppColors.primary.withValues(alpha: opacity),
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // 트로피 원 — Primary 그라데이션
                                  Container(
                                    width: 140,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppColors.primaryLight,
                                          AppColors.primary,
                                          AppColors.primaryDeep,
                                        ],
                                      ),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(alpha: 0.65),
                                          blurRadius: 40,
                                          spreadRadius: 8,
                                        ),
                                        BoxShadow(
                                          color: AppColors.primary.withValues(alpha: 0.30),
                                          blurRadius: 80,
                                          spreadRadius: 16,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.emoji_events_rounded,
                                      size: 72,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                              .animate()
                              .scale(
                                begin: const Offset(0.4, 0.4),
                                end: const Offset(1.0, 1.0),
                                duration: 500.ms,
                                curve: Curves.elasticOut,
                              ),
                          const SizedBox(height: 24),
                          // 컬러 도트
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: winnerColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      winnerColor.withValues(alpha: 0.6),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          )
                              .animate()
                              .scale(
                                begin: const Offset(0, 0),
                                end: const Offset(1, 1),
                                duration: 300.ms,
                                delay: 100.ms,
                                curve: Curves.easeOut,
                              ),
                          const SizedBox(height: 8),
                          // "당첨 항목" 라벨 — primary pill 배경
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              l10n.resultLabel,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                          const SizedBox(height: 12),
                          // 당첨 항목 이름 (세그먼트 색상 + 빛나는 blur 원형 배경)
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // 텍스트 뒤 빛나는 원형 배경
                              Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      winnerColor.withValues(alpha: 0.15),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                widget.winner.label,
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1.0,
                                  color: winnerColor,
                                  shadows: [
                                    Shadow(
                                      color: winnerColor.withValues(alpha: 0.9),
                                      blurRadius: 20,
                                      offset: Offset.zero,
                                    ),
                                    Shadow(
                                      color: winnerColor.withValues(alpha: 0.5),
                                      blurRadius: 50,
                                      offset: Offset.zero,
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          )
                              .animate()
                              .fadeIn(duration: 350.ms, delay: 150.ms)
                              .slideY(
                                begin: 0.25,
                                end: 0.0,
                                duration: 400.ms,
                                delay: 150.ms,
                                curve: Curves.easeOutCubic,
                              ),
                          // ── 라운드/커스텀 모드 진행 바 ──
                          if (widget.spinMode == SpinMode.round ||
                              widget.remainingCount <
                                  widget.totalCount) ...[
                            const SizedBox(height: 24),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              child: Column(
                                children: [
                                  Text(
                                    widget.spinMode == SpinMode.round
                                        ? l10n.roundStatus(
                                            widget.totalCount -
                                                widget.remainingCount,
                                            widget.totalCount)
                                        : l10n.remainingItems(
                                            widget.remainingCount),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(3),
                                    child: SizedBox(
                                      height: 6,
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: ColoredBox(
                                              color: Colors.white
                                                  .withValues(
                                                      alpha: 0.1),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                Alignment.centerLeft,
                                            child:
                                                FractionallySizedBox(
                                              widthFactor: widget
                                                          .totalCount >
                                                      0
                                                  ? ((widget.totalCount -
                                                              widget
                                                                  .remainingCount) /
                                                          widget
                                                              .totalCount)
                                                      .clamp(0.0, 1.0)
                                                  : 0,
                                              heightFactor: 1.0,
                                              child: Container(
                                                decoration:
                                                    const BoxDecoration(
                                                  gradient: AppColors
                                                      .primaryGradient,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                                .animate()
                                .fadeIn(
                                    duration: 300.ms, delay: 250.ms)
                                .slideY(
                                  begin: 0.15,
                                  end: 0,
                                  duration: 300.ms,
                                  delay: 250.ms,
                                  curve: Curves.easeOut,
                                ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  // 하단 버튼 영역
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    child: Column(
                      children: [
                        // Row 1: Ghost re-spin/reset + Gradient confirm
                        Row(
                          children: [
                            Expanded(
                              child: _GhostButton(
                                icon: widget.allPicked
                                    ? Icons.refresh_rounded
                                    : Icons.refresh_rounded,
                                label: widget.allPicked
                                    ? l10n.actionReset
                                    : l10n.actionReSpin,
                                onTap: widget.allPicked
                                    ? widget.onReset
                                    : widget.onReSpin,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GradientButton(
                                text: l10n.actionConfirm,
                                height: 48,
                                onPressed: widget.onClose,
                              ),
                            ),
                          ],
                        )
                            .animate()
                            .slideY(
                              begin: 0.2,
                              end: 0,
                              duration: 300.ms,
                              delay: 300.ms,
                              curve: Curves.easeOut,
                            )
                            .fadeIn(duration: 300.ms, delay: 300.ms),
                        const SizedBox(height: 16),
                        // Row 2: 3 sub-action icon circles
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _SubActionCircle(
                              icon: Icons.copy_rounded,
                              onTap: widget.onCopy,
                            ),
                            const SizedBox(width: 20),
                            _SubActionCircle(
                              icon: Icons.ios_share_rounded,
                              onTap: widget.onShareText,
                            ),
                            const SizedBox(width: 20),
                            _SubActionCircle(
                              icon: Icons.push_pin_outlined,
                              onTap: widget.onShareImage,
                            ),
                          ],
                        )
                            .animate()
                            .slideY(
                              begin: 0.15,
                              end: 0,
                              duration: 300.ms,
                              delay: 400.ms,
                              curve: Curves.easeOut,
                            )
                            .fadeIn(duration: 300.ms, delay: 400.ms),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          // ── Confetti 파티클 레이어 ─────────────────
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _confettiCtrl,
                builder: (_, _) => CustomPaint(
                  painter: _ConfettiPainter(
                    progress: _confettiCtrl.value,
                    winnerColor: winnerColor,
                  ),
                ),
              ),
            ),
          ),
          // ── Flash 오버레이 (등장 시 당첨 색 flash) ──
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _flashCtrl,
                builder: (_, _) => Opacity(
                  opacity: (_flashCtrl.value < 1.0
                          ? (1.0 - _flashCtrl.value) * 0.65
                          : 0.0)
                      .clamp(0.0, 1.0),
                  child: ColoredBox(color: winnerColor),
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

// ── Confetti CustomPainter ────────────────────────────────
//
// progress 0→1 동안 파티클이 위에서 아래로 낙하.
// 파티클마다 고정 랜덤 seed로 x위치/속도/크기/색상 사전 결정.

class _ConfettiPainter extends CustomPainter {
  final double progress;
  final Color winnerColor;

  static const _count = 48;
  static final _rng = Random(7); // fixed seed → 매 프레임 동일 배치

  // 파티클 속성: [x(0-1), startDelay(0-0.35), speed(0.6-1), w, h, initRot, drift(-1~1), colorIdx]
  static final _p = List.generate(_count, (_) => [
    _rng.nextDouble(),
    _rng.nextDouble() * 0.35,
    _rng.nextDouble() * 0.4 + 0.6,
    _rng.nextDouble() * 8 + 5,
    _rng.nextDouble() * 4 + 2,
    _rng.nextDouble() * 6.28,
    _rng.nextDouble() * 2 - 1,
    _rng.nextDouble(),
  ]);

  static const _palette = [
    Color(0xFFFF6B6B),
    Color(0xFFFFD93D),
    Color(0xFF6BCB77),
    Color(0xFF4D96FF),
    Color(0xFFEC4899),
    Color(0xFFF97316),
    Color(0xFFA78BFA),
  ];

  const _ConfettiPainter({required this.progress, required this.winnerColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1.0) return;

    for (final pt in _p) {
      final x0 = pt[0];
      final delay = pt[1];
      final speed = pt[2];
      final w = pt[3];
      final h = pt[4];
      final rot0 = pt[5];
      final drift = pt[6];
      final ci = (pt[7] * _palette.length).toInt().clamp(0, _palette.length - 1);

      // 지연 고려한 로컬 progress
      final t = ((progress - delay) * speed).clamp(0.0, 1.0);
      if (t <= 0) continue;

      // 후반부 서서히 fade
      final alpha = t < 0.75 ? 1.0 : (1.0 - (t - 0.75) / 0.25).clamp(0.0, 1.0);

      final px = x0 * size.width + drift * t * 30;
      final py = -20 + t * (size.height + 40);
      final rotation = rot0 + t * 6.28 * 2;

      final paint = Paint()
        ..color = _palette[ci].withValues(alpha: alpha * 0.9)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(rotation);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: w, height: h),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}

// ── Pill 세그먼트 컨트롤 ─────────────────────────────────────

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
    final l10n = AppLocalizations.of(context)!;
    final modes = [
      (SpinMode.lottery, l10n.modeLottery),
      (SpinMode.round, l10n.modeRound),
      (SpinMode.custom, l10n.modeCustom),
    ];

    return Container(
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1020),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: const Color(0xFFFFFFFF).withValues(alpha: 0.06),
          width: 1,
        ),
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
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF00D4FF).withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                  border: isSelected
                      ? Border.all(
                          color: const Color(0xFF00D4FF)
                              .withValues(alpha: 0.4),
                          width: 1,
                        )
                      : null,
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFF00D4FF)
                          : const Color(0xFFFFFFFF)
                              .withValues(alpha: 0.4),
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

// ── SPIN / STOP 버튼 ──────────────────────────────────────

class _SpinButton extends StatelessWidget {
  final bool isSpinning;
  final bool allPicked;
  final VoidCallback onSpin;

  const _SpinButton({
    required this.isSpinning,
    required this.allPicked,
    required this.onSpin,
  });

  static const _spinGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0284C7), Color(0xFF00D4FF)],
  );

  static const _stopGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFCC2255), Color(0xFFFF4466)],
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDisabled = allPicked && !isSpinning;

    return GestureDetector(
      onTap: isDisabled ? null : onSpin,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isDisabled ? 0.45 : 1.0,
        child: Container(
          height: 56,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: isSpinning ? _stopGradient : _spinGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: isDisabled
                ? []
                : [
                    BoxShadow(
                      color: isSpinning
                          ? const Color(0x66FF4466)
                          : const Color(0x6600D4FF),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: Center(
            child: Text(
              isSpinning
                  ? 'STOP'
                  : (allPicked ? l10n.allPicked : 'SPIN'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── 상단 네비게이션 아이콘 버튼 ─────────────────────────────

class _NavIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _NavIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.textPrimary, size: 18),
        ),
      ),
    );
  }
}

// ── Ghost 아웃라인 버튼 ──────────────────────────────────────

class _GhostButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _GhostButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surfaceBg,
        borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
        border: Border.all(
          color: AppColors.surfaceBorder,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
          splashColor: Colors.white.withValues(alpha: 0.08),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 서브 액션 글래스 원형 버튼 ────────────────────────────────

class _SubActionCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SubActionCircle({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.surfaceFill,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.surfaceBorder, width: 1),
          boxShadow: [AppShadows.card],
        ),
        child: Icon(icon, color: Colors.white70, size: 22),
      ),
    );
  }
}

