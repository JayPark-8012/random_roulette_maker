import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemNavigator;
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants.dart';
import '../../../data/premium_service.dart';
import '../../../domain/roulette.dart';
import '../../../l10n/app_localizations.dart';
import '../state/home_notifier.dart';
import '../widgets/roulette_card.dart';
import '../../tools/tools_tab.dart';

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
    final l10n = AppLocalizations.of(context)!;

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
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 헤더: 브랜드명 + 설정 버튼 ─────────────────
              _buildHeader(context, l10n),
              const SizedBox(height: 12),
              // ── 세그먼트 탭 (분리 위젯) ─────────────────────
              _QuickSegmentBar(
                selected: _mode,
                onChanged: (m) {
                  setState(() => _mode = m);
                  _modeAnimController.forward(from: 0.0);
                },
              ),
              const SizedBox(height: 12),
              // ── 콘텐츠 영역 (Offstage로 state 유지) ──────────
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // [룰렛 모드] 내 룰렛 세트 리스트
                    AnimatedOpacity(
                      opacity: _mode == _HomeMode.roulette ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 150),
                      child: Offstage(
                        offstage: _mode != _HomeMode.roulette,
                        child: _buildRouletteContent(context, l10n),
                      ),
                    ),
                    // [코인/주사위/숫자 모드] 기존 ToolsTab 재사용
                    AnimatedOpacity(
                      opacity: _mode != _HomeMode.roulette ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 150),
                      child: Offstage(
                        offstage: _mode == _HomeMode.roulette,
                        child: ToolsTab(showOnly: _toolsShowOnly),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // FAB: 룰렛 모드에서만 표시
        floatingActionButton: _mode == _HomeMode.roulette
            ? _buildFAB(context, cs, l10n)
            : null,
      ),
    );
  }

  /// 애니메이션이 적용된 FAB
  Widget _buildFAB(BuildContext context, ColorScheme cs, AppLocalizations l10n) {
    return FloatingActionButton.extended(
      onPressed: () => _onCreateTap(context),
      backgroundColor: cs.primary,
      foregroundColor: cs.onPrimary,
      elevation: 8,
      highlightElevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      icon: const Icon(Icons.add_rounded, size: 24),
      label: Text(
        l10n.fabCreateNew,
        style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5),
      ),
    )
        .animate()
        .scaleXY(begin: 0.8, end: 1.0, duration: 400.ms, curve: Curves.elasticOut)
        .fade(begin: 0.0, end: 1.0, duration: 200.ms);
  }

  // ── 헤더 ──────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.homeTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.0,
                  ),
            ),
          ).animate().fadeIn(duration: 300.ms),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.settings),
            tooltip: l10n.settingsTooltip,
          )
              .animate()
              .fadeIn(duration: 300.ms)
              .scaleXY(begin: 0.8, end: 1.0, duration: 300.ms, curve: Curves.elasticOut),
        ],
      ),
    );
  }

  // ── 룰렛 콘텐츠 영역 ──────────────────────────────────

  Widget _buildRouletteContent(BuildContext context, AppLocalizations l10n) {
    if (_notifier.isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (_notifier.roulettes.isEmpty) {
      return _EmptyState(onCreateTap: () => _onCreateTap(context))
          .animate()
          .fadeIn(duration: 300.ms, curve: Curves.easeOut)
          .scaleXY(begin: 0.95, end: 1.0, duration: 400.ms, curve: Curves.easeOut);
    }

    return CustomScrollView(
      key: const PageStorageKey('roulette_list'),
      slivers: [
        // 섹션 헤더 + 사용량 뱃지
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.sectionMySets,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                _UsageBadge(count: _notifier.count),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),
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
                )
                    .animate()
                    .slideY(
                      begin: 0.3,
                      end: 0.0,
                      duration: (i * 50 + 300).ms,
                      curve: Curves.easeOut,
                    )
                    .fadeIn(
                      duration: (i * 50 + 300).ms,
                      curve: Curves.easeOut,
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
    if (!_notifier.canCreate) {
      _showLimitDialog(context);
      return;
    }

    // Premium 제한 체크: 룰렛 생성
    final premiumService = PremiumService.instance;
    final canCreate = premiumService.canCreateRoulette(_notifier.roulettes.length);
    if (!canCreate) {
      _showPremiumRequiredDialog(context);
      return;
    }

    _showCreateBottomSheet(context);
  }

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
              title: Text(l10n.createBlankTitle),
              subtitle: Text(l10n.createBlankSubtitle),
              onTap: () {
                Navigator.of(ctx).pop();
                _navigateToEditor(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.auto_awesome_motion_rounded),
              title: Text(l10n.createTemplateTitle),
              subtitle: Text(l10n.createTemplateSubtitle),
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
      _showLimitDialog(context);
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final id = await _notifier.duplicate(roulette.id);
    if (id != null && mounted) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.duplicated(roulette.name))),
      );
    }
  }

  void _showLimitDialog(BuildContext context) {
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
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushNamed(AppRoutes.paywall);
            },
            child: Text(l10n.premiumButton),
          ),
        ],
      ),
    );
  }

  /// Premium 제한 다이얼로그: 룰렛 생성 한도 초과
  void _showPremiumRequiredDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.card_giftcard, size: 40),
        title: Text(l10n.paywallRouletteLimitTitle),
        content: Text(
          l10n.paywallRouletteLimitContent,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushNamed(AppRoutes.paywall);
            },
            child: Text(l10n.paywallPurchaseButton),
          ),
        ],
      ),
    );
  }
}

// ── 세그먼트 탭 바 (분리 위젯) ─────────────────────────────────

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

  String _labelOf(BuildContext context, _HomeMode m) {
    final l10n = AppLocalizations.of(context)!;
    return switch (m) {
      _HomeMode.roulette => l10n.tabRoulette,
      _HomeMode.coin => l10n.tabCoin,
      _HomeMode.dice => l10n.tabDice,
      _HomeMode.number => l10n.tabNumber,
    };
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: _HomeMode.values.map((mode) {
          final isActive = mode == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(mode),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? cs.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _icon(mode),
                      size: 15,
                      color: isActive ? cs.onPrimary : cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _labelOf(context, mode),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isActive ? cs.onPrimary : cs.onSurfaceVariant,
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
  final int count;
  const _UsageBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final isFull = count >= AppLimits.maxRouletteCount;
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.storage_rounded,
          size: 14,
          color:
              isFull ? cs.error : cs.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 4),
        Text(
          '$count / ${AppLimits.maxRouletteCount}',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isFull
                    ? cs.error
                    : cs.onSurfaceVariant.withValues(alpha: 0.6),
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
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.casino_rounded, size: 64, color: cs.primary),
            ),
            const SizedBox(height: 32),
            Text(
              l10n.emptyTitle,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
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
