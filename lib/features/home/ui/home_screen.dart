import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show SystemNavigator;
import 'package:flutter_animate/flutter_animate.dart';
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

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  _HomeMode _mode = _HomeMode.roulette;
  final HomeNotifier _notifier = HomeNotifier();
  late AnimationController _modeAnimController;

  @override
  void initState() {
    super.initState();
    _modeAnimController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _notifier.addListener(_rebuild);
    _notifier.load();
  }

  @override
  void dispose() {
    _modeAnimController.dispose();
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, _) => SystemNavigator.pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Let AppBackground show
        body: AppBackground(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── 헤더: 브랜드명 + 설정 버튼 ─────────────────
                _buildHeader(context),
                const SizedBox(height: 16),
                // ── 세그먼트 탭 (분리 위젯) ─────────────────────
                _QuickSegmentBar(
                  selected: _mode,
                  onChanged: (m) {
                    HapticFeedback.selectionClick();
                    setState(() => _mode = m);
                  },
                ),
                const SizedBox(height: 16),
                // ── 콘텐츠 영역 (Offstage로 state 유지) ──────────
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // [룰렛 모드] 내 룰렛 세트 리스트
                      Offstage(
                        offstage: _mode != _HomeMode.roulette,
                        child: _buildRouletteContent(context),
                      ),
                      // [코인/주사위/숫자 모드] 기존 ToolsTab 재사용
                      // showOnly 파라미터로 해당 도구 카드만 표시
                      // Offstage로 항상 tree에 유지 → 히스토리 state 보존
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // FAB: 룰렛 모드에서만 표시
      floatingActionButton: _mode == _HomeMode.roulette
          ? FloatingActionButton.extended(
              onPressed: () => _onCreateTap(context),
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              elevation: 2,
              highlightElevation: 4,
              shape: const StadiumBorder(),
              icon: const Icon(Icons.add_rounded, size: 22),
              label: Text(
                AppLocalizations.of(context)!.fabCreateNew,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: cs.onPrimary,
                    ),
              ),
            )
          : null,
      ),
    );
  }

  // ── 헤더 ──────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 8, 0),
      child: Row(
        children: [
          Expanded(
            // TextTheme에서 headlineMedium이 이미 w800, -0.8 spacing 제공
            child: Text(
              AppLocalizations.of(context)!.homeTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.settings_rounded,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.settings),
            tooltip: AppLocalizations.of(context)!.settingsTooltip,
          ),
        ],
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

  /// [이동] 기존 홈 AppBar 템플릿 버튼 → FAB 바텀시트로 통합
  void _showCreateBottomSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(ctx).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.add_circle_outline_rounded),
              title: Text(l10n.createManualTitle),
              subtitle: Text(l10n.createManualSubtitle),
              onTap: () {
                Navigator.of(ctx).pop();
                _navigateToEditor(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.auto_awesome_motion_rounded),
              title: Text(l10n.createTemplateTitle),
              subtitle: Text(l10n.createTemplateSubtitleNew),
              onTap: () {
                Navigator.of(ctx).pop();
                Navigator.of(context)
                    .pushNamed(AppRoutes.templates)
                    .then((_) => _notifier.load());
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
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

// ── 세그먼트 탭 바 (분리 위젯) ─────────────────────────────────
//
// 배치: 가로 1줄 / 높이 ~44px (padding 4 + inner 8*2 + icon 15)
// active  → cs.primary 배경 + cs.onPrimary 텍스트/아이콘
// inactive → 투명 배경 + cs.onSurfaceVariant (dim)

class _QuickSegmentBar extends StatelessWidget {
  final _HomeMode selected;
  final ValueChanged<_HomeMode> onChanged;

  const _QuickSegmentBar({required this.selected, required this.onChanged});

  static IconData _icon(_HomeMode m) => switch (m) {
        _HomeMode.roulette => Icons.casino_rounded,
        _HomeMode.coin => Icons.monetization_on_outlined,
        _HomeMode.dice => Icons.casino_outlined,
        _HomeMode.number => Icons.tag_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    String label(_HomeMode m) => switch (m) {
          _HomeMode.roulette => l10n.tabRoulette,
          _HomeMode.coin => l10n.tabCoin,
          _HomeMode.dice => l10n.tabDice,
          _HomeMode.number => l10n.tabNumber,
        };

    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: _HomeMode.values.map((mode) {
          final isActive = mode == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(mode),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 6),
                transform: Matrix4.identity()..scale(isActive ? 1.02 : 1.0),
                transformAlignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isActive ? cs.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: cs.primary.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _icon(mode),
                      size: 16,
                      color: isActive
                          ? cs.onPrimary
                          : cs.onSurfaceVariant.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      label(mode),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight:
                                isActive ? FontWeight.w700 : FontWeight.w500,
                            color: isActive
                                ? cs.onPrimary
                                : cs.onSurfaceVariant.withOpacity(0.6),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
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
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.casino_rounded, size: 56, color: cs.primary),
            ),
            const SizedBox(height: 32),
            Text(
              l10n.emptyTitle,
              // headlineSmall에서 이미 w700 + -0.5 spacing 제공
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
