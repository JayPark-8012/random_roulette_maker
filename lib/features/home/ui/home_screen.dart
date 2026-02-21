import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../domain/roulette.dart';
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

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── 헤더: 브랜드명 + 설정 버튼 ─────────────────
            _buildHeader(context),
            const SizedBox(height: 12),
            // ── 세그먼트 탭 (분리 위젯) ─────────────────────
            _QuickSegmentBar(
              selected: _mode,
              onChanged: (m) => setState(() => _mode = m),
            ),
            const SizedBox(height: 12),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // FAB: 룰렛 모드에서만 표시
      floatingActionButton: _mode == _HomeMode.roulette
          ? FloatingActionButton.extended(
              onPressed: () => _onCreateTap(context),
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              elevation: 0,
              highlightElevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              icon: const Icon(Icons.add_rounded, size: 24),
              label: const Text(
                '새 룰렛 만들기',
                style:
                    TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5),
              ),
            )
          : null,
    );
  }

  // ── 헤더 ──────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '랜덤 툴',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.0,
                  ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.settings),
            tooltip: '설정',
          ),
        ],
      ),
    );
  }

  // ── 룰렛 콘텐츠 영역 ──────────────────────────────────

  Widget _buildRouletteContent(BuildContext context) {
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
            padding: const EdgeInsets.fromLTRB(20, 4, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '내 룰렛 세트',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                _UsageBadge(count: _notifier.count),
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
    if (!_notifier.canCreate) {
      _showLimitDialog(context);
      return;
    }
    _showCreateBottomSheet(context);
  }

  /// [이동] 기존 홈 AppBar 템플릿 버튼 → FAB 바텀시트로 통합
  void _showCreateBottomSheet(BuildContext context) {
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
              title: const Text('빈 룰렛으로 시작'),
              subtitle: const Text('항목을 직접 입력합니다'),
              onTap: () {
                Navigator.of(ctx).pop();
                _navigateToEditor(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.auto_awesome_motion_rounded),
              title: const Text('템플릿으로 시작'),
              subtitle: const Text('미리 만들어진 구성으로 시작합니다'),
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
    final messenger = ScaffoldMessenger.of(context);
    final id = await _notifier.duplicate(roulette.id);
    if (id != null && mounted) {
      messenger.showSnackBar(
        SnackBar(content: Text('"${roulette.name}"을(를) 복제했습니다.')),
      );
    }
  }

  void _showLimitDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.lock_outline, size: 40),
        title: const Text('룰렛 제한'),
        content: Text(
          '무료 플랜은 최대 ${AppLimits.maxRouletteCount}개까지 저장할 수 있습니다.\n'
          '기존 룰렛을 삭제하거나 프리미엄으로 업그레이드해 보세요.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('닫기'),
          ),
          FilledButton(
            // TODO(Phase3): 프리미엄 구매 플로우 연결
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('프리미엄 기능은 준비 중입니다.')),
              );
            },
            child: const Text('프리미엄 알아보기'),
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

  static String _label(_HomeMode m) => switch (m) {
        _HomeMode.roulette => '룰렛',
        _HomeMode.coin => '코인',
        _HomeMode.dice => '주사위',
        _HomeMode.number => '숫자',
      };

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
                      _label(mode),
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
              '아직 생성된 룰렛이 없어요',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              '결정하기 힘든 고민이 있다면\n지금 바로 첫 번째 룰렛을 만들어 보세요!',
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
              label: const Text('첫 룰렛 만들기'),
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
