import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../data/local_storage.dart';
import '../../l10n/app_localizations.dart';

class ToolsTab extends StatefulWidget {
  /// null = 전체 표시 / 'coin' | 'dice' | 'number' = 해당 도구만 표시
  final String? showOnly;
  const ToolsTab({super.key, this.showOnly});

  @override
  State<ToolsTab> createState() => _ToolsTabState();
}

class _ToolsTabState extends State<ToolsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // ── 코인 상태 ─────────────────────────────────────────
  bool? _coin; // null=미실행
  final List<bool> _coinHistory = [];

  // ── 주사위 상태 ───────────────────────────────────────
  static const _diceSides = [4, 6, 8, 10, 12, 20];
  int _diceType = 6;
  int? _diceResult;
  final List<Map<String, int>> _diceHistory = [];

  // ── 랜덤 숫자 상태 ────────────────────────────────────
  final _minCtrl = TextEditingController(text: '1');
  final _maxCtrl = TextEditingController(text: '100');
  int? _numResult;
  final List<Map<String, int>> _numHistory = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data =
          await LocalStorage.instance.getJsonMap(StorageKeys.toolsHistory);
      if (data == null || !mounted) return;
      setState(() {
        final coin = data['coin'] as List<dynamic>? ?? [];
        _coinHistory.addAll(coin.cast<bool>());
        if (_coinHistory.isNotEmpty) _coin = _coinHistory.first;

        final dice = data['dice'] as List<dynamic>? ?? [];
        for (final e in dice.cast<Map<String, dynamic>>()) {
          _diceHistory
              .add({'type': e['type'] as int, 'result': e['result'] as int});
        }
        if (_diceHistory.isNotEmpty) _diceResult = _diceHistory.first['result'];

        final nums = data['number'] as List<dynamic>? ?? [];
        for (final e in nums.cast<Map<String, dynamic>>()) {
          _numHistory.add({
            'min': e['min'] as int,
            'max': e['max'] as int,
            'result': e['result'] as int,
          });
        }
        if (_numHistory.isNotEmpty) _numResult = _numHistory.first['result'];
      });
    } catch (e) {
      // LocalStorage 초기화 전이거나 web 환경에서는 무시
      debugPrint('ToolsTab._load() error: $e');
    }
  }

  Future<void> _save() async {
    try {
      await LocalStorage.instance.setJsonMap(StorageKeys.toolsHistory, {
        'coin': _coinHistory,
        'dice': _diceHistory,
        'number': _numHistory,
      });
    } catch (e) {
      debugPrint('ToolsTab._save() error: $e');
    }
  }

  void _flipCoin() {
    final r = Random().nextBool();
    setState(() {
      _coin = r;
      _coinHistory.insert(0, r);
      if (_coinHistory.length > 10) _coinHistory.removeLast();
    });
    _save();
  }

  void _rollDice() {
    final r = Random().nextInt(_diceType) + 1;
    setState(() {
      _diceResult = r;
      _diceHistory.insert(0, {'type': _diceType, 'result': r});
      if (_diceHistory.length > 10) _diceHistory.removeLast();
    });
    _save();
  }

  void _generateNumber() {
    final min = int.tryParse(_minCtrl.text.trim()) ?? 1;
    final max = int.tryParse(_maxCtrl.text.trim()) ?? 100;
    if (min >= max) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.minMaxError)),
      );
      return;
    }
    final r = min + Random().nextInt(max - min + 1);
    setState(() {
      _numResult = r;
      _numHistory.insert(0, {'min': min, 'max': max, 'result': r});
      if (_numHistory.length > 20) _numHistory.removeLast();
    });
    _save();
  }

  @override
  void dispose() {
    _minCtrl.dispose();
    _maxCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final so = widget.showOnly;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        // [재사용] 코인 플립 카드
        if (so == null || so == 'coin')
          _CoinCard(coin: _coin, history: _coinHistory, onFlip: _flipCoin),
        // [재사용] 주사위 카드
        if (so == null) const SizedBox(height: 12),
        if (so == null || so == 'dice')
          _DiceCard(
            diceType: _diceType,
            diceSides: _diceSides,
            result: _diceResult,
            history: _diceHistory,
            onTypeChanged: (t) => setState(() => _diceType = t),
            onRoll: _rollDice,
          ),
        // [재사용] 랜덤 숫자 카드
        if (so == null) const SizedBox(height: 12),
        if (so == null || so == 'number')
          _NumberCard(
            minCtrl: _minCtrl,
            maxCtrl: _maxCtrl,
            result: _numResult,
            history: _numHistory,
            onGenerate: _generateNumber,
          ),
      ],
    );
  }
}

// ── 코인 플립 카드 ─────────────────────────────────────────
class _CoinCard extends StatelessWidget {
  final bool? coin;
  final List<bool> history;
  final VoidCallback onFlip;

  const _CoinCard(
      {required this.coin, required this.history, required this.onFlip});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final isHeads = coin == true;
    final color = coin == null
        ? cs.surfaceContainerHighest
        : (isHeads ? cs.primary : cs.secondary);
    final textColor = coin == null
        ? cs.onSurfaceVariant
        : (isHeads ? cs.onPrimary : cs.onSecondary);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.monetization_on_outlined,
                    size: 20, color: cs.primary),
                const SizedBox(width: 8),
                Text(l10n.coinFlipTitle,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: coin != null
                    ? [
                        BoxShadow(
                            color: color.withValues(alpha: 0.4),
                            blurRadius: 14,
                            offset: const Offset(0, 4))
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  coin == null ? '?' : (isHeads ? l10n.coinHeads : l10n.coinTails),
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: textColor),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onFlip,
                icon: const Icon(Icons.flip),
                label: Text(l10n.actionFlip,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            if (history.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(l10n.recent10,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: cs.onSurfaceVariant)),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: history
                    .map((h) => Chip(
                          label: Text(h ? l10n.coinHeads : l10n.coinTails,
                              style: const TextStyle(fontSize: 12)),
                          backgroundColor: h
                              ? cs.primaryContainer
                              : cs.secondaryContainer,
                          side: BorderSide.none,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── 주사위 카드 ────────────────────────────────────────────
class _DiceCard extends StatelessWidget {
  final int diceType;
  final List<int> diceSides;
  final int? result;
  final List<Map<String, int>> history;
  final ValueChanged<int> onTypeChanged;
  final VoidCallback onRoll;

  const _DiceCard({
    required this.diceType,
    required this.diceSides,
    required this.result,
    required this.history,
    required this.onTypeChanged,
    required this.onRoll,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.casino_outlined, size: 20, color: cs.primary),
                const SizedBox(width: 8),
                Text(l10n.diceTitle,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: diceSides
                  .map((s) => ChoiceChip(
                        label: Text('D$s'),
                        selected: diceType == s,
                        onSelected: (_) => onTypeChanged(s),
                        visualDensity: VisualDensity.compact,
                        showCheckmark: false,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: result != null
                      ? cs.primaryContainer
                      : cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: result != null
                      ? [
                          BoxShadow(
                              color: cs.primary.withValues(alpha: 0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4))
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    result != null ? '$result' : '?',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: result != null
                          ? cs.onPrimaryContainer
                          : cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onRoll,
                icon: const Icon(Icons.casino_rounded),
                label: Text(l10n.rollDice(diceType),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            if (history.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(l10n.recent10,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: cs.onSurfaceVariant)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: history
                    .map((h) => Chip(
                          label: Text('D${h['type']} → ${h['result']}',
                              style: const TextStyle(fontSize: 12)),
                          backgroundColor: cs.surfaceContainerHighest,
                          side: BorderSide.none,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── 랜덤 숫자 카드 ─────────────────────────────────────────
class _NumberCard extends StatelessWidget {
  final TextEditingController minCtrl;
  final TextEditingController maxCtrl;
  final int? result;
  final List<Map<String, int>> history;
  final VoidCallback onGenerate;

  const _NumberCard({
    required this.minCtrl,
    required this.maxCtrl,
    required this.result,
    required this.history,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tag_rounded, size: 20, color: cs.primary),
                const SizedBox(width: 8),
                Text(l10n.randomNumberTitle,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minCtrl,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: l10n.minLabel,
                      isDense: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('~',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: cs.onSurfaceVariant)),
                ),
                Expanded(
                  child: TextField(
                    controller: maxCtrl,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: l10n.maxLabel,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                decoration: BoxDecoration(
                  color: result != null
                      ? cs.tertiaryContainer
                      : cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: result != null
                      ? [
                          BoxShadow(
                              color: cs.tertiary.withValues(alpha: 0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4))
                        ]
                      : [],
                ),
                child: Text(
                  result != null ? '$result' : '?',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: result != null
                        ? cs.onTertiaryContainer
                        : cs.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onGenerate,
                icon: const Icon(Icons.shuffle_rounded),
                label: Text(l10n.actionGenerate,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            if (history.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(l10n.recent20,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: cs.onSurfaceVariant)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: history
                    .map((h) => Chip(
                          label: Text(
                              '${h['min']}~${h['max']}: ${h['result']}',
                              style: const TextStyle(fontSize: 12)),
                          backgroundColor: cs.surfaceContainerHighest,
                          side: BorderSide.none,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
