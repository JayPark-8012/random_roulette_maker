import 'dart:math';
import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback, SystemNavigator;
import '../../../core/constants.dart';
import '../../../data/premium_service.dart';
import '../../../domain/premium_state.dart';
import '../../../domain/roulette.dart';
import '../state/home_notifier.dart';
import '../widgets/roulette_card.dart';
import '../../tools/tools_tab.dart';
import '../../../core/widgets/app_background.dart';
import '../../../l10n/app_localizations.dart';

// ── 홈 모드 ──────────────────────────────────────────────────
enum _HomeMode { roulette, coin, dice, number }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeMode _mode = _HomeMode.roulette;
  final HomeNotifier _notifier = HomeNotifier();

  @override
  void initState() {
    super.initState();
    _notifier.addListener(_rebuild);
    _notifier.load();
  }

  @override
  void dispose() {
    _notifier.removeListener(_rebuild);
    _notifier.dispose();
    super.dispose();
  }

  void _rebuild() => setState(() {});

  /// 현재 모드에 맞는 ToolsTab showOnly 값
  String? get _toolsShowOnly => switch (_mode) {
        _HomeMode.coin => 'coin',
        _HomeMode.dice => 'dice',
        _HomeMode.number => 'number',
        _HomeMode.roulette => null,
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (_notifier.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(_notifier.error!)));
        _notifier.clearError();
      });
    }

    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, _) => SystemNavigator.pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: AppBackground(
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── 헤더: 브랜드명 + 설정 버튼 ─────────────────
                _buildHeader(context),
                const SizedBox(height: 8),
                // ── 콘텐츠 영역 (Offstage로 state 유지) ──────────
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Offstage(
                        offstage: _mode != _HomeMode.roulette,
                        child: _buildRouletteContent(context),
                      ),
                      Offstage(
                        offstage: _mode == _HomeMode.roulette,
                        child: ToolsTab(showOnly: _toolsShowOnly),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // ── 하단 NavigationBar (Floating Island) ────────────
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withValues(alpha: 0.35),
                    blurRadius: 24,
                    spreadRadius: 0,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: NavigationBar(
                    selectedIndex: _mode.index,
                    onDestinationSelected: (i) {
                      HapticFeedback.selectionClick();
                      setState(() => _mode = _HomeMode.values[i]);
                    },
                    backgroundColor: const Color(0xFF1A0F2E).withValues(alpha: 0.7),
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  height: 68,
                  labelBehavior:
                      NavigationDestinationLabelBehavior.alwaysShow,
                  destinations: [
                    NavigationDestination(
                      icon: const Icon(Icons.track_changes_outlined),
                      selectedIcon: const Icon(Icons.track_changes_rounded),
                      label: l10n.tabRoulette,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.monetization_on_outlined),
                      selectedIcon:
                          const Icon(Icons.monetization_on_rounded),
                      label: l10n.tabCoin,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.casino_outlined),
                      selectedIcon: const Icon(Icons.casino_rounded),
                      label: l10n.tabDice,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.shuffle_rounded),
                      selectedIcon: const Icon(Icons.shuffle_rounded),
                      label: l10n.tabNumber,
                    ),
                  ],
                ),
              ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        // FAB: 룰렛 모드에서만 표시
        floatingActionButton: _mode == _HomeMode.roulette
            ? FloatingActionButton.large(
                onPressed: () => _onCreateTap(context),
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
                elevation: 6,
                shape: const CircleBorder(),
                child: const Icon(Icons.add_rounded, size: 40),
              )
            : null,
      ),
    );
  }

  // ── 헤더 ──────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    const bgColor = Color(0xFF1A0F2E);
    const fgColor = Colors.white;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor.withValues(alpha: 0.6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 8, 12),
          child: Row(
        children: [
          // 로고 아이콘
          Container(
            width: 34,
            height: 34,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.track_changes_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          // 앱 이름
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.homeTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: fgColor,
                  ),
            ),
          ),
          // 설정 버튼
          IconButton(
            icon: Icon(Icons.settings_rounded, color: fgColor),
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.settings),
            tooltip: AppLocalizations.of(context)!.settingsTooltip,
          ),
        ],
      ),
    ),
    ),
    );
  }

  // ── 룰렛 콘텐츠 영역 ──────────────────────────────────

  Widget _buildRouletteContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_notifier.isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (_notifier.roulettes.isEmpty) {
      return _EmptyState(onCreateTap: () => _onCreateTap(context));
    }

    return CustomScrollView(
      key: const PageStorageKey('roulette_list'),
      slivers: [
        // 섹션 헤더 + 사용량 뱃지
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 16, 12),
            child: Row(
              children: [
                Expanded(
                  // titleMedium은 이미 theme에서 w700 설정
                  child: Text(
                    l10n.sectionMySets,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                ValueListenableBuilder<PremiumState>(
                  valueListenable:
                      PremiumService.instance.stateNotifier,
                  builder: (_, ps, child) => _UsageBadge(
                    label: PremiumService.instance
                        .formatSetCountLabel(_notifier.count),
                    isPremium: ps.isPremium,
                    isFull: !ps.isPremium &&
                        _notifier.count >= AppLimits.maxRouletteCount,
                  ),
                ),
              ],
            ),
          ),
        ),
        // 룰렛 카드 리스트
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RouletteCard(
                  roulette: _notifier.roulettes[i],
                  onTap: () =>
                      _navigateToPlay(context, _notifier.roulettes[i]),
                  onEdit: () => _navigateToEditor(context,
                      roulette: _notifier.roulettes[i]),
                  onDuplicate: () =>
                      _duplicateRoulette(context, _notifier.roulettes[i]),
                  onRename: (n) =>
                      _notifier.rename(_notifier.roulettes[i].id, n),
                  onDelete: () =>
                      _notifier.delete(_notifier.roulettes[i].id),
                ),
              ),
              childCount: _notifier.roulettes.length,
            ),
          ),
        ),
      ],
    );
  }

  // ── 네비게이션 / 다이얼로그 ─────────────────────────────

  void _onCreateTap(BuildContext context) {
    // canCreate 는 HomeNotifier → PremiumService.canCreateNewSet() 위임
    if (!_notifier.canCreate) {
      _showPremiumRequiredDialog(context);
      return;
    }
    _showCreateBottomSheet(context);
  }

  void _showCreateBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CreateSheet(
        onCreateManual: () {
          Navigator.of(ctx).pop();
          _navigateToEditor(context);
        },
        onCreateTemplate: () {
          Navigator.of(ctx).pop();
          Navigator.of(context)
              .pushNamed(AppRoutes.templates)
              .then((_) => _notifier.load());
        },
      ),
    );
  }

  void _navigateToPlay(BuildContext context, Roulette roulette) {
    Navigator.of(context)
        .pushNamed(AppRoutes.play, arguments: roulette.id)
        .then((_) => _notifier.load());
  }

  void _navigateToEditor(BuildContext context, {Roulette? roulette}) {
    Navigator.of(context)
        .pushNamed(AppRoutes.editor, arguments: roulette)
        .then((_) => _notifier.load());
  }

  Future<void> _duplicateRoulette(
      BuildContext context, Roulette roulette) async {
    if (!_notifier.canCreate) {
      _showPremiumRequiredDialog(context);
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    final id = await _notifier.duplicate(roulette.id);
    if (id != null && mounted) {
      messenger.showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.duplicated(roulette.name))),
      );
    }
  }

  void _showPremiumRequiredDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.lock_outline, size: 40),
        title: Text(l10n.limitTitle),
        content: Text(
          l10n.limitContent(AppLimits.maxRouletteCount),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.actionClose),
          ),
          FilledButton(
            // TODO(Phase3): 프리미엄 구매 플로우 연결
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.premiumComingSoon)),
              );
            },
            child: Text(l10n.premiumButton),
          ),
        ],
      ),
    );
  }
}

// ── 사용량 뱃지 ───────────────────────────────────────────────

class _UsageBadge extends StatelessWidget {
  /// PremiumService.formatSetCountLabel(current) 결과 ("2/3" 또는 "2/∞")
  final String label;
  final bool isPremium;
  final bool isFull;

  const _UsageBadge({
    required this.label,
    required this.isPremium,
    required this.isFull,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // 프리미엄이면 에러 색상 없이 뮤트 표시
    final color = (!isPremium && isFull)
        ? cs.error
        : cs.onSurfaceVariant.withValues(alpha: 0.6);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.storage_rounded, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
        ),
      ],
    );
  }
}

// ── 빈 상태 ──────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreateTap;
  const _EmptyState({required this.onCreateTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 천천히 도는 미니 룰렛 휠
            const _MiniSpinningWheel(),
            const SizedBox(height: 32),
            Text(
              l10n.emptyTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.emptySubtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            FilledButton.icon(
              onPressed: onCreateTap,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.emptyButton),
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 미니 스피닝 휠 ─────────────────────────────────────────────

class _MiniSpinningWheel extends StatefulWidget {
  const _MiniSpinningWheel();

  @override
  State<_MiniSpinningWheel> createState() => _MiniSpinningWheelState();
}

class _MiniSpinningWheelState extends State<_MiniSpinningWheel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => Transform.rotate(
        angle: _ctrl.value * 2 * pi,
        child: child,
      ),
      child: const CustomPaint(
        painter: _SimpleWheelPainter(),
        size: Size(128, 128),
      ),
    );
  }
}

class _SimpleWheelPainter extends CustomPainter {
  const _SimpleWheelPainter();

  static const _colors = [
    Color(0xFFFF6B6B),
    Color(0xFFFFD93D),
    Color(0xFF6BCB77),
    Color(0xFF4ECDC4),
    Color(0xFF7C3AED),
    Color(0xFFEC4899),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;
    const count = 6;
    const sweep = 2 * pi / count;
    final fill = Paint()..style = PaintingStyle.fill;

    // 섹터 채우기
    for (int i = 0; i < count; i++) {
      fill.color = _colors[i];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * sweep - pi / 2,
        sweep,
        true,
        fill,
      );
    }

    // 섹터 구분선
    final divider = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < count; i++) {
      final angle = i * sweep - pi / 2;
      canvas.drawLine(
        center,
        Offset(center.dx + radius * cos(angle), center.dy + radius * sin(angle)),
        divider,
      );
    }

    // 외곽 링
    final ring = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, ring);

    // 중앙 허브 (흰 원)
    fill
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.18, fill);
    final hubBorder = Paint()
      ..color = Colors.black.withValues(alpha: 0.10)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius * 0.18, hubBorder);
  }

  @override
  bool shouldRepaint(_SimpleWheelPainter old) => false;
}

// ── 새 룰렛 만들기 선택 시트 ──────────────────────────────────

class _CreateSheet extends StatelessWidget {
  final VoidCallback onCreateManual;
  final VoidCallback onCreateTemplate;

  const _CreateSheet({
    required this.onCreateManual,
    required this.onCreateTemplate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 핸들 바
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.fabCreateNew,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _CreateOptionCard(
                      icon: Icons.edit_rounded,
                      color: cs.primary,
                      title: l10n.createManualTitle,
                      subtitle: l10n.createManualSubtitle,
                      onTap: onCreateManual,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CreateOptionCard(
                      icon: Icons.auto_awesome_rounded,
                      color: cs.tertiary,
                      title: l10n.createTemplateTitle,
                      subtitle: l10n.createTemplateSubtitleNew,
                      onTap: onCreateTemplate,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 생성 옵션 카드 ─────────────────────────────────────────────

class _CreateOptionCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CreateOptionCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: 164,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withValues(alpha: 0.50),
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 컬러 아이콘 블록 (고정 높이)
                  Container(
                    height: 96,
                    color: color.withValues(alpha: 0.25),
                    child: Center(
                      child: Icon(icon, color: color, size: 48),
                    ),
                  ),
                  // 텍스트 영역
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            subtitle,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
