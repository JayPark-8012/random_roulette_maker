import 'package:flutter/material.dart';
import '../../../core/utils.dart';
import '../../../domain/history.dart';
import '../../../domain/roulette.dart';

class StatsSheet extends StatelessWidget {
  final Roulette roulette;
  final List<History> history;

  const StatsSheet({super.key, required this.roulette, required this.history});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 빈도 계산
    final freq = <String, _FreqItem>{};
    for (final h in history) {
      freq.update(
        h.resultLabel,
        (v) => _FreqItem(h.resultLabel, Color(h.resultColorValue), v.count + 1),
        ifAbsent: () => _FreqItem(h.resultLabel, Color(h.resultColorValue), 1),
      );
    }
    final sorted = freq.values.toList()
      ..sort((a, b) => b.count.compareTo(a.count));
    final maxCount = sorted.isEmpty ? 1 : sorted.first.count;
    final recent5 = history.reversed.take(5).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 드래그 핸들
        Center(
          child: Container(
            width: 32,
            height: 4,
            margin: const EdgeInsets.fromLTRB(0, 12, 0, 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        // 제목
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Text('통계', style: theme.textTheme.titleLarge),
              const SizedBox(width: 8),
              Text(
                '최근 ${history.length}회',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (history.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                '아직 기록이 없습니다.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 32),
              children: [
                // ── 최근 결과 5개 ───────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 4),
                  child: Text(
                    '최근 결과',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                ...recent5.map((h) => ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 24),
                      leading: CircleAvatar(
                        backgroundColor: Color(h.resultColorValue),
                        radius: 14,
                      ),
                      title: Text(h.resultLabel),
                      trailing: Text(
                        AppUtils.formatRelativeDate(h.playedAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )),
                const SizedBox(height: 16),
                // ── 항목별 빈도 바 ──────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Text(
                    '항목별 빈도',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                ...sorted.map((item) => Padding(
                      padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 72,
                            child: Text(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 22,
                                    color: theme.colorScheme
                                        .surfaceContainerHighest,
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: item.count / maxCount,
                                    child: Container(
                                      height: 22,
                                      color: item.color.withValues(alpha: 0.85),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 36,
                            child: Text(
                              '${item.count}회',
                              textAlign: TextAlign.end,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
      ],
    );
  }
}

class _FreqItem {
  final String label;
  final Color color;
  final int count;
  const _FreqItem(this.label, this.color, this.count);
}
