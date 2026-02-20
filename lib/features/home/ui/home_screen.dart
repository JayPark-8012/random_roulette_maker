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
      appBar: AppBar(
        title: const Text('내 룰렛'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard_customize_outlined),
            onPressed: () => Navigator.of(context)
                .pushNamed(AppRoutes.templates)
                .then((_) => _notifier.load()),
            tooltip: '템플릿',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.settings),
            tooltip: '설정',
          ),
        ],
      ),
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

          if (_notifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_notifier.roulettes.isEmpty) {
            return _EmptyState(
              onCreateTap: () => _navigateToEditor(context),
            );
          }

          return Column(
            children: [
              _UsageBanner(count: _notifier.count),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 96),
                  itemCount: _notifier.roulettes.length,
                  itemBuilder: (ctx, i) {
                    final roulette = _notifier.roulettes[i];
                    return RouletteCard(
                      roulette: roulette,
                      onTap: () => _navigateToPlay(context, roulette),
                      onEdit: () =>
                          _navigateToEditor(context, roulette: roulette),
                      onDuplicate: () => _duplicateRoulette(context, roulette),
                      onRename: (newName) =>
                          _notifier.rename(roulette.id, newName),
                      onDelete: () => _notifier.delete(roulette.id),
                    );
                  },
                ),
              ),
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
        icon: const Icon(Icons.add),
        label: const Text('룰렛 만들기'),
      ),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isFull
          ? Theme.of(context).colorScheme.errorContainer
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Text(
        isFull
            ? '룰렛 $count / ${AppLimits.maxRouletteCount}개 (최대 도달)'
            : '룰렛 $count / ${AppLimits.maxRouletteCount}개 사용 중',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isFull
                  ? Theme.of(context).colorScheme.onErrorContainer
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
        textAlign: TextAlign.end,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreateTap;
  const _EmptyState({required this.onCreateTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.casino_outlined,
                size: 80,
                color: Theme.of(context).colorScheme.outlineVariant),
            const SizedBox(height: 24),
            Text('아직 룰렛이 없어요',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              '+ 버튼을 눌러 첫 룰렛을 만들어 보세요',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: onCreateTap,
              icon: const Icon(Icons.add),
              label: const Text('룰렛 만들기'),
            ),
          ],
        ),
      ),
    );
  }
}
