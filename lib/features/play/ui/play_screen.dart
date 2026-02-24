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
import '../../../data/ad_service.dart';

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
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 슬림 커스텀 헤더 ──
              AnimatedBuilder(
                animation: _notifier,
                builder: (_, _) => Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 8, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Text(
                          _notifier.roulette?.name ?? l10n.playFallbackTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                            fontSize: 17,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.bar_chart_rounded),
                        tooltip: l10n.statsTooltip,
                        onPressed: () {
                          if (_notifier.roulette != null) _showStats();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.history_rounded),
                        tooltip: l10n.historyTooltip,
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
                                        // ① 글로우 레이어 (휠 뒤 배경 조명)
                                        Positioned(
                                          top: 24,
                                          left: 0,
                                          right: 0,
                                          height: MediaQuery.of(context).size.width * 0.92,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: RadialGradient(
                                                colors: [
                                                  colorScheme.primary.withValues(alpha: 0.22),
                                                  Colors.transparent,
                                                ],
                                                stops: const [0.50, 1.0],
                                              ),
                                            ),
                                          ),
                                        ),
                                        // ② 휠: 포인터 높이 절반(24px)만큼 아래로 → 50% 중첩
                                        Padding(
                                          padding: const EdgeInsets.only(top: 24),
                                          child: AnimatedBuilder(
                                            animation: _animController,
                                            builder: (_, _) => CustomPaint(
                                              painter: RouletteWheelPainter(
                                                items: _notifier.availableItems,
                                                rotationAngle: _isDragging
                                                    ? _dragAngle
                                                    : _rotationAnim.value,
                                                primaryColor: colorScheme.primary,
                                              ),
                                              size: Size.square(
                                                MediaQuery.of(context).size.width * 0.92,
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
                  color: winnerColor.withValues(alpha: 0.35),
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
                    color: Colors.white.withValues(alpha: 0.2),
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
                          color: textColor.withValues(alpha: 0.7),
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

  static Color _modeColor(SpinMode mode) => switch (mode) {
        SpinMode.lottery => const Color(0xFF22C55E), // 초록
        SpinMode.round   => const Color(0xFF3B82F6), // 파랑
        SpinMode.custom  => const Color(0xFFF59E0B), // 주황
        _                => const Color(0xFF7C3AED),
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final modes = [
      (SpinMode.lottery, l10n.modeLottery),
      (SpinMode.round, l10n.modeRound),
      (SpinMode.custom, l10n.modeCustom),
    ];

    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: modes.map((entry) {
          final (mode, label) = entry;
          final isSelected = currentMode == mode;
          final canTap = !isDisabled;
          final modeColor = _modeColor(mode);

          return Expanded(
            child: GestureDetector(
              onTap: canTap ? () => onModeSelected(mode) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: isSelected
                      ? modeColor.withValues(alpha: isDark ? 0.20 : 0.14)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                  border: isSelected
                      ? Border.all(
                          color: modeColor.withValues(alpha: 0.45),
                          width: 1)
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: modeColor.withValues(alpha: 0.22),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                      color: isSelected
                          ? modeColor
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

class _PremiumSpinButtonState extends State<_PremiumSpinButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _updatePulse();
  }

  @override
  void didUpdateWidget(_PremiumSpinButton old) {
    super.didUpdateWidget(old);
    if (old.isSpinning != widget.isSpinning ||
        old.onPressed != widget.onPressed) {
      _updatePulse();
    }
  }

  void _updatePulse() {
    if (!widget.isSpinning && widget.onPressed != null) {
      if (!_pulseCtrl.isAnimating) _pulseCtrl.repeat(reverse: true);
    } else {
      _pulseCtrl.stop();
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

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
        child: AnimatedBuilder(
          animation: _pulseAnim,
          builder: (_, child) {
            final t = _pulseAnim.value;
            final glowAlpha = (isDisabled || widget.isSpinning)
                ? 0.0
                : 0.28 + t * 0.22; // idle: 0.28 ~ 0.50
            final glowBlur = (isDisabled || widget.isSpinning)
                ? 0.0
                : 12.0 + t * 16.0; // idle: 12 ~ 28
            return Container(
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
                    color: widget.color.withValues(alpha: glowAlpha),
                    blurRadius: glowBlur,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: child,
            );
          },
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

