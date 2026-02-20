import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../domain/roulette.dart';
import '../state/home_notifier.dart';
import '../widgets/roulette_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeNotifier _notifier = HomeNotifier();

  @override
  void initState() {
    super.initState();
    _notifier.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _notifier,
        builder: (context, _) {
          // 에러 스낵바
          if (_notifier.error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(_notifier.error!)),
              );
              _notifier.clearError();
            });
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context),
              if (_notifier.isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_notifier.roulettes.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(
                    onCreateTap: () => _navigateToEditor(context),
                  ),
                )
              else ...[
                SliverToBoxAdapter(
                  child: _UsageBanner(count: _notifier.count),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 8, bottom: 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) {
                        final roulette = _notifier.roulettes[i];
                        return RouletteCard(
                          roulette: roulette,
                          onTap: () => _navigateToPlay(context, roulette),
                          onEdit: () =>
                              _navigateToEditor(context, roulette: roulette),
                          onDuplicate: () =>
                              _duplicateRoulette(context, roulette),
                          onRename: (newName) =>
                              _notifier.rename(roulette.id, newName),
                          onDelete: () => _notifier.delete(roulette.id),
                        );
                      },
                      childCount: _notifier.roulettes.length,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_notifier.canCreate) {
            _navigateToEditor(context);
          } else {
            _showLimitDialog(context);
          }
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('새 룰렛 만들기'),
        elevation: 4,
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar.large(
      title: const Text('내 룰렛'),
      actions: [
        IconButton(
          icon: const Icon(Icons.dashboard_customize_rounded),
          onPressed: () => Navigator.of(context)
              .pushNamed(AppRoutes.templates)
              .then((_) => _notifier.load()),
          tooltip: '템플릿',
        ),
        IconButton(
          icon: const Icon(Icons.settings_rounded),
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.settings),
          tooltip: '설정',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _navigateToPlay(BuildContext context, Roulette roulette) {
    Navigator.of(context)
        .pushNamed(AppRoutes.play, arguments: roulette.id)
        .then((_) => _notifier.load()); // 플레이 후 lastPlayedAt 갱신 반영
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

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }
}

// ── 재사용 위젯 ────────────────────────────────────────────

class _UsageBanner extends StatelessWidget {
  final int count;
  const _UsageBanner({required this.count});

  @override
  Widget build(BuildContext context) {
    final isFull = count >= AppLimits.maxRouletteCount;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isFull
            ? colorScheme.errorContainer.withOpacity(0.5)
            : colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFull
              ? colorScheme.error.withOpacity(0.2)
              : colorScheme.outlineVariant.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            isFull ? Icons.warning_amber_rounded : Icons.info_outline_rounded,
            size: 16,
            color: isFull ? colorScheme.error : colorScheme.onSurfaceVariant,
          ),
          Text(
            isFull
                ? '룰렛 $count / ${AppLimits.maxRouletteCount}개 (최대 도달)'
                : '저장된 룰렛 $count / ${AppLimits.maxRouletteCount}개',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isFull ? colorScheme.error : colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreateTap;
  const _EmptyState({required this.onCreateTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.casino_rounded,
                size: 64,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '아직 생성된 룰렛이 없어요',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              '결정하기 힘든 고민이 있다면\n지금 바로 첫 번째 룰렛을 만들어 보세요!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            FilledButton.icon(
              onPressed: onCreateTap,
              icon: const Icon(Icons.add_rounded),
              label: const Text('첫 룰렛 만들기'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
