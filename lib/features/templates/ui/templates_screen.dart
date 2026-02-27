import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../data/roulette_repository.dart';
import '../../../data/templates_data.dart';
import '../../../domain/item.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/template_card.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  bool _isCreating = false;

  // ── l10n 키 해석 헬퍼 ────────────────────────────────────

  static String _resolveName(AppLocalizations l10n, String key) =>
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

  static String _resolveCategory(AppLocalizations l10n, String key) =>
      switch (key) {
        'starterCatDecision' => l10n.starterCatDecision,
        'starterCatFun' => l10n.starterCatFun,
        'starterCatTeam' => l10n.starterCatTeam,
        'starterCatNumbers' => l10n.starterCatNumbers,
        'starterCatFood' => l10n.starterCatFood,
        'starterCatGame' => l10n.starterCatGame,
        _ => key,
      };

  static List<String> _resolveItems(
      AppLocalizations l10n, Map<String, dynamic> set) {
    if (set.containsKey('items')) {
      return (set['items'] as List).cast<String>();
    }
    return (set['itemKeys'] as List)
        .cast<String>()
        .map((k) => _resolveItemKey(l10n, k))
        .toList();
  }

  static String _resolveItemKey(AppLocalizations l10n, String key) =>
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF070B14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1020),
        title: Text(l10n.starterSetsTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: const Color(0xFF00D4FF).withValues(alpha: 0.08),
          ),
        ),
      ),
      body: Stack(
        children: [
          // ── 배경 빛 번짐 ──
          Positioned(
            top: -60,
            left: -60,
            width: 200,
            height: 200,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x1200D4FF), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            right: -40,
            width: 160,
            height: 160,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x0F7B61FF), Colors.transparent],
                ),
              ),
            ),
          ),
          GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.78,
            ),
            itemCount: kStarterSets.length,
            itemBuilder: (context, i) {
              final set = kStarterSets[i];
              final name = _resolveName(l10n, set['nameKey'] as String);
              final category =
                  _resolveCategory(l10n, set['categoryKey'] as String);
              final items = _resolveItems(l10n, set);
              return TemplateCard(
                emoji: set['emoji'] as String,
                name: name,
                category: category,
                items: items,
                onTap: () => _onTapCreate(context, name, items),
                onLongPress: () =>
                    _showDetailSheet(context, set, name, category, items),
              );
            },
          ),
          // 생성 중 로딩 오버레이
          if (_isCreating)
            const ColoredBox(
              color: Color(0x66000000),
              child: Center(child: CircularProgressIndicator.adaptive()),
            ),
        ],
      ),
    );
  }

  // ── 즉시 생성 → Play 화면 이동 ───────────────────────────

  Future<void> _onTapCreate(
    BuildContext context,
    String name,
    List<String> items,
  ) async {
    if (_isCreating) return;
    setState(() => _isCreating = true);

    // async gap 전에 캐시
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final repo = RouletteRepository.instance;
      final canCreate = await repo.canCreate();

      if (!mounted) return;

      if (!canCreate) {
        setState(() => _isCreating = false);
        _showPremiumLimit(this.context); // mounted 확인 후 State.context 사용
        return;
      }

      final itemList = items.asMap().entries.map((e) => Item(
            id: AppUtils.generateId(),
            label: e.value,
            colorValue: AppUtils.colorValueForIndex(e.key),
            order: e.key,
            weight: 1,
          )).toList();

      final roulette = await repo.create(name: name, items: itemList);

      if (!mounted) return;
      setState(() => _isCreating = false);

      // TemplatesScreen을 스택에서 제거하고 Play 화면으로
      nav.pushReplacementNamed(
        AppRoutes.play,
        arguments: roulette.id,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isCreating = false);
      messenger.showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  // ── 상세 시트 (롱프레스) ─────────────────────────────────

  void _showDetailSheet(
    BuildContext context,
    Map<String, dynamic> set,
    String name,
    String category,
    List<String> items,
  ) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (_, scrollCtrl) => Column(
          children: [
            // 핸들
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // 헤더
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Text(
                    set['emoji'] as String,
                    style: const TextStyle(fontSize: 36),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        l10n.templateItemsInfo(category, items.length),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            // 항목 목록
            Expanded(
              child: ListView.builder(
                controller: scrollCtrl,
                itemCount: items.length,
                itemBuilder: (_, i) => ListTile(
                  leading: CircleAvatar(
                    radius: 14,
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  title: Text(items[i]),
                ),
              ),
            ),
            // 사용 버튼
            Padding(
              padding: EdgeInsets.fromLTRB(
                  24, 12, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.rocket_launch_rounded),
                  label: Text(l10n.useTemplate),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _onTapCreate(context, name, items);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 프리미엄 제한 안내 ───────────────────────────────────

  void _showPremiumLimit(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 48),
            const SizedBox(height: 16),
            Text(
              l10n.freePlanLimit(AppLimits.maxRouletteCount),
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.actionClose),
            ),
          ],
        ),
      ),
    );
  }
}
