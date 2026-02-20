import 'package:flutter/material.dart';
import '../../../core/utils.dart';
import '../../../domain/roulette.dart';

enum RouletteCardAction { edit, duplicate, rename, delete }

class RouletteCard extends StatelessWidget {
  final Roulette roulette;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final Future<void> Function(String newName) onRename;
  final VoidCallback onDelete;

  const RouletteCard({
    super.key,
    required this.roulette,
    required this.onTap,
    required this.onEdit,
    required this.onDuplicate,
    required this.onRename,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: Key(roulette.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        color: colorScheme.error,
        child: Icon(Icons.delete_outline, color: colorScheme.onError),
      ),
      confirmDismiss: (_) async => _showDeleteConfirm(context),
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 4, 16),
            child: Row(
              children: [
                _ColorPreview(roulette: roulette),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        roulette.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '항목 ${roulette.items.length}개'
                        '${roulette.lastPlayedAt != null ? '  ·  ${AppUtils.formatRelativeDate(roulette.lastPlayedAt!)}' : ''}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<RouletteCardAction>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (action) => _handleAction(context, action),
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: RouletteCardAction.edit,
                      child: _MenuRow(icon: Icons.edit_outlined, label: '편집'),
                    ),
                    PopupMenuItem(
                      value: RouletteCardAction.duplicate,
                      child: _MenuRow(icon: Icons.copy_outlined, label: '복제'),
                    ),
                    PopupMenuItem(
                      value: RouletteCardAction.rename,
                      child: _MenuRow(
                          icon: Icons.drive_file_rename_outline,
                          label: '이름 변경'),
                    ),
                    PopupMenuItem(
                      value: RouletteCardAction.delete,
                      child:
                          _MenuRow(icon: Icons.delete_outline, label: '삭제'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleAction(BuildContext context, RouletteCardAction action) {
    switch (action) {
      case RouletteCardAction.edit:
        onEdit();
      case RouletteCardAction.duplicate:
        onDuplicate();
      case RouletteCardAction.rename:
        _showRenameDialog(context);
      case RouletteCardAction.delete:
        _showDeleteConfirm(context).then((confirmed) {
          if (confirmed == true) onDelete();
        });
    }
  }

  void _showRenameDialog(BuildContext context) {
    final ctrl = TextEditingController(text: roulette.name);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('이름 변경'),
        content: TextField(
          controller: ctrl,
          maxLength: 30,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: '룰렛 이름',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              final name = ctrl.text.trim();
              if (name.isNotEmpty) onRename(name);
              Navigator.of(ctx).pop();
            },
            child: const Text('변경'),
          ),
        ],
      ),
    ).then((_) => ctrl.dispose());
  }

  Future<bool?> _showDeleteConfirm(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('룰렛 삭제'),
        content: Text('"${roulette.name}"을(를) 삭제할까요?\n히스토리도 함께 삭제됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MenuRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 12),
        Text(label),
      ],
    );
  }
}

class _ColorPreview extends StatelessWidget {
  final Roulette roulette;
  const _ColorPreview({required this.roulette});

  @override
  Widget build(BuildContext context) {
    final colors = roulette.items.take(4).map((e) => e.color).toList();
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        children: [
          for (int i = 0; i < colors.length && i < 4; i++)
            Positioned(
              left: i * 8.0,
              top: i * 8.0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: colors[i],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 1.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
