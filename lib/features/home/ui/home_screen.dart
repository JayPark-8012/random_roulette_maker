import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback, SystemNavigator;
import '../../../core/constants.dart';
import '../../../core/design_tokens.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/section_label.dart';
import '../../../data/local_storage.dart';
import '../../../data/premium_service.dart';
import '../../../data/roulette_repository.dart';
import '../../../data/templates_data.dart';
import '../../../domain/item.dart';
import '../../../domain/premium_state.dart';
import '../../../domain/roulette.dart';
import '../state/home_notifier.dart';
import '../widgets/roulette_card.dart';
import '../../tools/tools_tab.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/tab_icons.dart';
import '../../../l10n/app_localizations.dart';

// ── 홈 모드 ──────────────────────────────────────────────────
enum _HomeMode { roulette, coin, dice, number, ladder }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeMode _mode = _HomeMode.roulette;
  final HomeNotifier _notifier = HomeNotifier();
  bool _isFirstRun = false;

  // ── UI-layer state for 3-zone layout ──
  Map<String, String?> _lastResults = {};
  bool _setsExpanded = false;

  // ── 랜덤 추천 스타터 (앱 실행 시 1회 셔플) ──
  late final List<Map<String, dynamic>> _randomStarters;

  @override
  void initState() {
    super.initState();
    _notifier.addListener(_onNotifierChanged);
    _notifier.load();
    _checkFirstRun();
    final list = List<Map<String, dynamic>>.from(kStarterSets);
    list.shuffle();
    _randomStarters = list.take(4).toList();
  }

  void _onNotifierChanged() {
    setState(() {});
    _loadLastResults();
  }

  Future<void> _loadLastResults() async {
    final repo = RouletteRepository.instance;
    final results = <String, String?>{};
    for (final r in _notifier.roulettes) {
      final history = await repo.getHistory(r.id);
      results[r.id] = history.isNotEmpty ? history.last.resultLabel : null;
    }
    if (mounted) setState(() => _lastResults = results);
  }

  Future<void> _checkFirstRun() async {
    final completed =
        await LocalStorage.instance.getBool(StorageKeys.hasCompletedFirstRun);
    if (mounted && !completed) {
      setState(() => _isFirstRun = true);
    }
  }

  Future<void> _completeFirstRun() async {
    await LocalStorage.instance
        .setBool(StorageKeys.hasCompletedFirstRun, true);
    if (mounted) setState(() => _isFirstRun = false);
  }

  @override
  void dispose() {
    _notifier.removeListener(_onNotifierChanged);
    _notifier.dispose();
    super.dispose();
  }

  /// 현재 모드에 맞는 ToolsTab showOnly 값
  String? get _toolsShowOnly => switch (_mode) {
        _HomeMode.coin => 'coin',
        _HomeMode.dice => 'dice',
        _HomeMode.number => 'number',
        _HomeMode.ladder => 'ladder',
        _HomeMode.roulette => null,
      };

  @override
  Widget build(BuildContext context) {
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
        // ── 하단 NavigationBar ────────────────────────────
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0A1020),
            border: Border(
              top: BorderSide(
                color: Color(0x1400D4FF),
                width: 1,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 72,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(5, (i) {
                  final selected = _mode.index == i;
                  final labels = [
                    l10n.tabRoulette,
                    l10n.tabCoin,
                    l10n.tabDice,
                    l10n.tabNumber,
                    l10n.tabLadder,
                  ];
                  const tabColors = [
                    AppColors.colorRoulette,
                    AppColors.colorCoin,
                    AppColors.colorDice,
                    AppColors.colorNumber,
                    AppColors.colorLadder,
                  ];
                  final tabColor = tabColors[i];
                  final iconColor = selected
                      ? tabColor
                      : Colors.white.withValues(alpha: 0.25);

                  Widget icon;
                  switch (i) {
                    case 0:
                      icon = RouletteIcon(size: 22, color: iconColor);
                    case 1:
                      icon = CoinIcon(size: 22, color: iconColor);
                    case 2:
                      icon = DiceIcon(size: 22, color: iconColor);
                    case 3:
                      icon = NumberIcon(size: 22, color: iconColor);
                    case 4:
                      icon = LadderIcon(size: 22, color: iconColor);
                    default:
                      icon = const SizedBox.shrink();
                  }

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _mode = _HomeMode.values[i]);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ── 상단 인디케이터 바 ──
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: selected ? 28 : 0,
                            height: 2,
                            decoration: BoxDecoration(
                              color: selected ? tabColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          const SizedBox(height: 6),
                          // ── 아이콘 + 배경 ──
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            width: 36,
                            height: 28,
                            decoration: BoxDecoration(
                              color: selected
                                  ? tabColor.withValues(alpha: 0.12)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            alignment: Alignment.center,
                            child: icon,
                          ),
                          const SizedBox(height: 3),
                          // ── 레이블 ──
                          Text(
                            labels[i],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                              color: selected
                                  ? tabColor
                                  : AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        // FAB: 룰렛 모드에서만 표시
        floatingActionButton: _mode == _HomeMode.roulette
            ? Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [AppShadows.primaryGlow],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _onCreateTap(context),
                      borderRadius: BorderRadius.circular(100),
                      splashColor: Colors.white.withValues(alpha: 0.15),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_rounded,
                                color: Colors.white, size: 22),
                            SizedBox(width: 8),
                            Text(
                              '+ 새 세트',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  // ── 헤더 ──────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.06),
            width: 0.5,
          ),
        ),
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
              color: AppColors.surfaceBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.track_changes_rounded,
              color: AppColors.textPrimary,
              size: 18,
            ),
          ),
          // 앱 이름
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.homeTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    letterSpacing: -0.5,
                    color: AppColors.textPrimary,
                  ),
            ),
          ),
          // 설정 버튼
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.surfaceBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.settings_rounded, color: AppColors.textPrimary, size: 18),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.settings),
              tooltip: AppLocalizations.of(context)!.settingsTooltip,
            ),
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
      if (_isFirstRun) {
        return _FirstRunState(
          onStarterTap: (set) => _onStarterSetTap(context, set),
          onCreateManual: () {
            _completeFirstRun();
            _onCreateTap(context);
          },
          onViewMore: () {
            _completeFirstRun();
            Navigator.of(context)
                .pushNamed(AppRoutes.templates)
                .then((_) => _notifier.load());
          },
        );
      }
      return _EmptyState(onCreateTap: () => _onCreateTap(context));
    }

    // ── 3-zone hub layout ──

    // 세트 목록 (3개 초과 시 접기/펼치기)
    final allSets = _notifier.roulettes;

    // 최근 사용 세트 (lastPlayedAt가 있는 것 중 가장 최신)
    final recentlyPlayed = allSets
        .where((r) => r.lastPlayedAt != null)
        .toList()
      ..sort((a, b) => b.lastPlayedAt!.compareTo(a.lastPlayedAt!));
    final quickLaunch = recentlyPlayed.isNotEmpty ? recentlyPlayed.first : allSets.first;
    final visibleSets =
        _setsExpanded ? allSets : allSets.take(3).toList();
    final canExpand = allSets.length > 3;


    return SingleChildScrollView(
      key: const PageStorageKey('roulette_hub'),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ═════ Section 1: 빠른 실행 히어로 ═════
          _QuickLaunchCard(
            roulette: quickLaunch,
            lastResult: _lastResults[quickLaunch.id],
            onTap: () => _navigateToPlay(context, quickLaunch),
          ),
          const SizedBox(height: 28),

          // ═════ Section 2: 내 룰렛 세트 ═════
          ValueListenableBuilder<PremiumState>(
            valueListenable: PremiumService.instance.stateNotifier,
            builder: (_, ps, _) => SectionLabel(
              text: l10n.sectionMySets,
              trailing: PremiumService.instance
                  .formatSetCountLabel(_notifier.count),
              padding: const EdgeInsets.only(bottom: 10),
            ),
          ),
          for (int i = 0; i < visibleSets.length; i++) ...[
            RouletteCard(
              roulette: visibleSets[i],
              lastResult: _lastResults[visibleSets[i].id] != null
                  ? l10n.recentResult(
                      _lastResults[visibleSets[i].id]!)
                  : null,
              onTap: () =>
                  _navigateToPlay(context, visibleSets[i]),
              onEdit: () => _navigateToEditor(context,
                  roulette: visibleSets[i]),
              onDuplicate: () =>
                  _duplicateRoulette(context, visibleSets[i]),
              onRename: (n) =>
                  _notifier.rename(visibleSets[i].id, n),
              onDelete: () =>
                  _notifier.delete(visibleSets[i].id),
            ),
            if (i < visibleSets.length - 1)
              const SizedBox(height: 8),
          ],
          if (canExpand) ...[
            const SizedBox(height: 8),
            Center(
              child: TextButton.icon(
                onPressed: () =>
                    setState(() => _setsExpanded = !_setsExpanded),
                icon: Icon(
                  _setsExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                label: Text(
                  _setsExpanded ? l10n.showLess : l10n.showMore,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 28),

          // ═════ Section 3: 이런 룰렛 어때요? ═════
          SectionLabel(
            text: l10n.sectionRecommend,
            padding: const EdgeInsets.only(bottom: 10),
          ),
          Row(
            children: [
              for (int i = 0; i < _randomStarters.length; i++) ...[
                Expanded(
                  child: _RecommendCard(
                    set: _randomStarters[i],
                    onTap: () => _onStarterSetTap(context, _randomStarters[i]),
                  ),
                ),
                if (i < _randomStarters.length - 1)
                  const SizedBox(width: 6),
              ],
            ],
          ),
        ],
      ),
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
    final dupMsg = AppLocalizations.of(context)!.duplicated(roulette.name);
    final id = await _notifier.duplicate(roulette.id);
    if (id != null && mounted) {
      messenger.showSnackBar(SnackBar(content: Text(dupMsg)));
    }
  }

  // ── 스타터 세트 즉시 스핀 플로우 ──────────────────────────

  Future<void> _onStarterSetTap(
      BuildContext context, Map<String, dynamic> set) async {
    final l10n = AppLocalizations.of(context)!;
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    // l10n 키 해석
    final name = _resolveStarterName(l10n, set['nameKey'] as String);
    final itemLabels = _resolveStarterItems(l10n, set);

    try {
      final repo = RouletteRepository.instance;

      // 아이템 생성
      final items = itemLabels.asMap().entries.map((e) => Item(
            id: AppUtils.generateId(),
            label: e.value,
            colorValue: AppUtils.colorValueForIndex(e.key),
            order: e.key,
          )).toList();

      // 룰렛 저장
      final roulette = await repo.create(name: name, items: items);
      if (!mounted) return;

      // Play 화면으로 이동
      await nav.pushNamed(AppRoutes.play, arguments: roulette.id);
      if (!mounted) return;

      // 돌아온 후 저장 다이얼로그 표시 (State.context 사용)
      final shouldSave = await _showSaveDialog(this.context, name);

      if (shouldSave != true) {
        // 건너뛰기 → 삭제
        await repo.delete(roulette.id);
      }

      await _completeFirstRun();
      _notifier.load();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<bool?> _showSaveDialog(BuildContext context, String name) {
    final l10n = AppLocalizations.of(context)!;

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xB3000000),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFF1C2642),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0x33FFFFFF),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 40,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 아이콘
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.12),
                      ),
                      child: const Icon(
                        Icons.bookmark_add_rounded,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 타이틀
                    Text(
                      l10n.firstRunSaveTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    // 메시지
                    Text(
                      l10n.firstRunSaveMessage,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    // 세트 이름
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // 저장 버튼 (Primary gradient)
                    SizedBox(
                      width: double.infinity,
                      child: GradientButton(
                        text: l10n.firstRunSaveButton,
                        icon: Icons.check_rounded,
                        height: 48,
                        onPressed: () => Navigator.of(ctx).pop(true),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 건너뛰기 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: Material(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: () => Navigator.of(ctx).pop(false),
                          borderRadius: BorderRadius.circular(12),
                          child: Center(
                            child: Text(
                              l10n.firstRunSkipButton,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── l10n 키 해석 헬퍼 (templates_screen.dart와 동일 패턴) ──

  static String _resolveStarterName(AppLocalizations l10n, String key) =>
      switch (key) {
        'starterSetYesNo' => l10n.starterSetYesNo,
        'starterSetTruthDare' => l10n.starterSetTruthDare,
        'starterSetTeamSplit' => l10n.starterSetTeamSplit,
        'starterSetNumbers' => l10n.starterSetNumbers,
        'starterSetFood' => l10n.starterSetFood,
        'starterSetRandomOrder' => l10n.starterSetRandomOrder,
        'starterSetWinnerPick' => l10n.starterSetWinnerPick,
        _ => key,
      };

  static String _resolveStarterCategory(AppLocalizations l10n, String key) =>
      switch (key) {
        'starterCatDecision' => l10n.starterCatDecision,
        'starterCatFun' => l10n.starterCatFun,
        'starterCatTeam' => l10n.starterCatTeam,
        'starterCatNumbers' => l10n.starterCatNumbers,
        'starterCatFood' => l10n.starterCatFood,
        'starterCatGame' => l10n.starterCatGame,
        _ => key,
      };

  static List<String> _resolveStarterItems(
      AppLocalizations l10n, Map<String, dynamic> set) {
    if (set.containsKey('items')) {
      return (set['items'] as List).cast<String>();
    }
    return (set['itemKeys'] as List)
        .cast<String>()
        .map((k) => _resolveStarterItemKey(l10n, k))
        .toList();
  }

  static String _resolveStarterItemKey(AppLocalizations l10n, String key) =>
      switch (key) {
        'itemYes' => l10n.itemYes,
        'itemNo' => l10n.itemNo,
        'itemTruth' => l10n.itemTruth,
        'itemDare' => l10n.itemDare,
        'itemTeamA' => l10n.itemTeamA,
        'itemTeamB' => l10n.itemTeamB,
        'itemPlayer1' => l10n.itemPlayer1,
        'itemPlayer2' => l10n.itemPlayer2,
        'itemPlayer3' => l10n.itemPlayer3,
        'itemPlayer4' => l10n.itemPlayer4,
        'itemCandidateA' => l10n.itemCandidateA,
        'itemCandidateB' => l10n.itemCandidateB,
        'itemCandidateC' => l10n.itemCandidateC,
        'itemPizza' => l10n.itemPizza,
        'itemBurger' => l10n.itemBurger,
        'itemPasta' => l10n.itemPasta,
        'itemSalad' => l10n.itemSalad,
        'itemSushi' => l10n.itemSushi,
        _ => key,
      };

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

// ── 빈 상태 (첫 실행 완료 후) ─────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreateTap;
  const _EmptyState({required this.onCreateTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.10),
              ),
              child: const Icon(
                Icons.track_changes_rounded,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              l10n.emptyTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.emptySubtitle,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            GradientButton(
              text: l10n.emptyButton,
              icon: Icons.add_rounded,
              onPressed: onCreateTap,
              width: 220,
            ),
          ],
        ),
      ),
    );
  }
}

// ── 첫 실행 상태 ─────────────────────────────────────────────

/// 3개 스타터 세트 인덱스: starter_001(✅), starter_005(🍕), starter_003(👥)
const _kFirstRunSetIndices = [0, 4, 2];

class _FirstRunState extends StatelessWidget {
  final void Function(Map<String, dynamic> set) onStarterTap;
  final VoidCallback onCreateManual;
  final VoidCallback onViewMore;

  const _FirstRunState({
    required this.onStarterTap,
    required this.onCreateManual,
    required this.onViewMore,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── 도구 쇼케이스 + Welcome 헤더 ──
          const SizedBox(height: 24),
          // 도구 오브 Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ToolOrb(
                icon: CoinIcon(size: 24, color: AppColors.colorCoin),
                color: AppColors.colorCoin,
                label: l10n.tabCoin,
              ),
              const SizedBox(width: 10),
              _ToolOrb(
                icon: DiceIcon(size: 24, color: AppColors.colorDice),
                color: AppColors.colorDice,
                label: l10n.tabDice,
              ),
              const SizedBox(width: 10),
              _ToolOrb(
                icon: RouletteIcon(size: 32, color: AppColors.colorRoulette),
                color: AppColors.colorRoulette,
                label: l10n.tabRoulette,
                isCenter: true,
              ),
              const SizedBox(width: 10),
              _ToolOrb(
                icon: NumberIcon(size: 24, color: AppColors.colorNumber),
                color: AppColors.colorNumber,
                label: l10n.tabNumber,
              ),
              const SizedBox(width: 10),
              _ToolOrb(
                icon: LadderIcon(size: 24, color: AppColors.colorLadder),
                color: AppColors.colorLadder,
                label: l10n.tabLadder,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '${l10n.firstRunWelcomeTitle} 👋',
            style: const TextStyle(
              fontFamily: 'Syne',
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.firstRunSubtitle,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // ── 스타터 세트 카드 3개 ──
          for (final idx in _kFirstRunSetIndices) ...[
            _StarterSetCard(
              set: kStarterSets[idx],
              onTap: () => onStarterTap(kStarterSets[idx]),
            ),
            const SizedBox(height: 12),
          ],

          const SizedBox(height: 8),

          // ── 직접 만들기 텍스트 버튼 ──
          Center(
            child: TextButton.icon(
              onPressed: onCreateManual,
              icon: Icon(Icons.edit_rounded,
                  size: 18, color: AppColors.textSecondary),
              label: Text(
                l10n.firstRunCreateManual,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // ── 스타터 세트 더 보기 GradientButton ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GradientButton(
              text: l10n.firstRunViewMore,
              icon: Icons.grid_view_rounded,
              onPressed: onViewMore,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0369A1), Color(0xFF0284C7)],
              ),
              shadow: BoxShadow(
                color: const Color(0xFF0284C7).withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 도구 쇼케이스 오브 ──────────────────────────────────────────

class _ToolOrb extends StatelessWidget {
  final Widget icon;
  final Color color;
  final String label;
  final bool isCenter;

  const _ToolOrb({
    required this.icon,
    required this.color,
    required this.label,
    this.isCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = isCenter ? 68.0 : 52.0;
    final radius = isCenter ? 20.0 : 16.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: isCenter
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 24,
                    ),
                  ]
                : null,
          ),
          child: Center(child: icon),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: size,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

// ── 스타터 세트 카드 ─────────────────────────────────────────

class _StarterSetCard extends StatelessWidget {
  final Map<String, dynamic> set;
  final VoidCallback onTap;

  const _StarterSetCard({required this.set, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final emoji = set['emoji'] as String;
    final name =
        _HomeScreenState._resolveStarterName(l10n, set['nameKey'] as String);
    final category = _HomeScreenState._resolveStarterCategory(
        l10n, set['categoryKey'] as String);
    final items = _HomeScreenState._resolveStarterItems(l10n, set);

    return GlassCard(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.cardRadius),
          splashColor: AppColors.primary.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 미니 휠 프리뷰
                _MiniWheelPreview(
                  itemCount: items.length,
                  size: 56,
                ),
                const SizedBox(width: 16),
                // 텍스트 영역
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(emoji, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$category · ${items.length} items',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // 재생 버튼
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0284C7), Color(0xFF00D4FF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00D4FF).withValues(alpha: 0.4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── 미니 휠 프리뷰 ──────────────────────────────────────────

class _MiniWheelPreview extends StatelessWidget {
  final int itemCount;
  final double size;

  const _MiniWheelPreview({required this.itemCount, this.size = 56});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _WheelPainter(itemCount: itemCount),
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  final int itemCount;
  _WheelPainter({required this.itemCount});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;
    final sweepAngle = 2 * pi / itemCount;

    for (int i = 0; i < itemCount; i++) {
      final startAngle = i * sweepAngle - pi / 2;
      final paint = Paint()
        ..color = AppUtils.colorForIndex(i).withValues(alpha: 0.75)
        ..style = PaintingStyle.fill;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
    }

    // 중심 원
    canvas.drawCircle(
      center,
      radius * 0.22,
      Paint()..color = AppColors.surfaceFill,
    );
    // 테두리
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _WheelPainter old) =>
      old.itemCount != itemCount;
}

// ── 빠른 실행 카드 ──────────────────────────────────────────

class _QuickLaunchCard extends StatelessWidget {
  final Roulette roulette;
  final String? lastResult;
  final VoidCallback onTap;

  const _QuickLaunchCard({
    required this.roulette,
    this.lastResult,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final resultText = lastResult != null
        ? l10n.recentResult(lastResult!)
        : l10n.itemCount(roulette.items.length);

    final wheelColors = roulette.items.isNotEmpty
        ? roulette.items.map((e) => e.color).toList()
        : const [
            Color(0xFFFF6B6B), Color(0xFFFFB347),
            Color(0xFF98D8A3), Color(0xFF7CC8F5),
            Color(0xFFC3A6FF), Color(0xFFFFD93D),
          ];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1C30),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xFF00D4FF).withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00D4FF).withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 레이어1 — 배경 글로우
            Positioned(
              top: -50,
              right: -20,
              child: Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Color(0x1A00D4FF), Colors.transparent],
                  ),
                ),
              ),
            ),
            // 레이어2 — 상단 하이라이트 라인
            Positioned(
              top: 0,
              left: 16,
              right: 16,
              height: 1,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Color(0x2200D4FF),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // 레이어3 — 콘텐츠 Row
            Row(
              children: [
                // 휠 프리뷰
                ClipOval(
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CustomPaint(
                      painter: _MiniWheelPainter(wheelColors),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // 텍스트 영역
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pill 라벨
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0x1400D4FF),
                          border: Border.all(
                              color: const Color(0x4D00D4FF), width: 1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          l10n.sectionQuickLaunch.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 7.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF67E8F9),
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      // 세트 이름
                      Text(
                        roulette.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // 서브텍스트
                      const SizedBox(height: 2),
                      Opacity(
                        opacity: 0.65,
                        child: Text(
                          resultText,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF67E8F9),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // 스핀 버튼
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 11),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0284C7), Color(0xFF00D4FF)],
                    ),
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00D4FF).withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        l10n.quickLaunchSpin,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── 빠른 실행 미니 휠 페인터 ──────────────────────────────────

class _MiniWheelPainter extends CustomPainter {
  final List<Color> colors;
  _MiniWheelPainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final sweepAngle = (2 * pi) / colors.length;

    for (int i = 0; i < colors.length; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2 + (sweepAngle * i),
        sweepAngle,
        true,
        paint,
      );
    }

    // 중앙 도넛홀
    final holePaint = Paint()
      ..color = const Color(0xFF0F1C30)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.28, holePaint);

    // 도넛홀 테두리
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, radius * 0.28, borderPaint);
  }

  @override
  bool shouldRepaint(_MiniWheelPainter old) => old.colors != colors;
}

// ── 추천 카드 ────────────────────────────────────────────────

class _RecommendCard extends StatelessWidget {
  final Map<String, dynamic> set;
  final VoidCallback onTap;

  const _RecommendCard({required this.set, required this.onTap});

  static const _categoryColors = <String, Color>{
    'starterCatDecision': AppColors.colorNumber,
    'starterCatFun': AppColors.colorDice,
    'starterCatTeam': AppColors.colorRoulette,
    'starterCatNumbers': AppColors.colorCoin,
    'starterCatFood': AppColors.colorLadder,
    'starterCatGame': AppColors.colorDice,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final emoji = set['emoji'] as String;
    final categoryKey = set['categoryKey'] as String;
    final category = _HomeScreenState._resolveStarterCategory(
        l10n, categoryKey);
    final dotColor = _categoryColors[categoryKey] ?? AppColors.accent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: dotColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: dotColor.withValues(alpha: 0.18),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 컬러 도트
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: dotColor.withValues(alpha: 0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                '$emoji $category',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.65),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
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
