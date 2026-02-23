import 'package:flutter/material.dart';
import '../../../core/utils.dart';
import '../../../domain/roulette.dart';
import '../../../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final tintColor = roulette.items.isNotEmpty
        ? roulette.items.first.color
        : colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tintOpacity = isDark ? 0.10 : 0.07;
    final borderOpacity = isDark ? 0.25 : 0.20;

    return Dismissible(
      key: Key(roulette.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(Icons.delete_rounded, color: colorScheme.onError),
      ),
      confirmDismiss: (_) async => _showDeleteConfirm(context),
      onDismissed: (_) => onDelete(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.lerp(colorScheme.surface, tintColor, tintOpacity) ??
                  colorScheme.surface,
              Color.lerp(colorScheme.surface, tintColor, tintOpacity * 0.2) ??
                  colorScheme.surface,
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: tintColor.withOpacity(borderOpacity),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: tintColor.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: onTap,
            splashColor: tintColor.withOpacity(0.1),
            highlightColor: tintColor.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 52,
                    margin: const EdgeInsets.only(right: 14),
                    decoration: BoxDecoration(
                      color: tintColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  _ColorPreview(roulette: roulette),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          roulette.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.8,
                                color: colorScheme.onSurface,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              l10n.itemCount(roulette.items.length),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant
                                        .withOpacity(0.7),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            if (roulette.lastPlayedAt != null) ...[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Text(
                                  '·',
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant
                                        .withOpacity(0.4),
                                  ),
                                ),
                              ),
                              Text(
                                AppUtils.formatRelativeDate(
                                    roulette.lastPlayedAt!),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: colorScheme.onSurfaceVariant
                                          .withOpacity(0.5),
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: colorScheme.outline.withOpacity(0.5),
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: const Icon(Icons.more_horiz_rounded),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 20,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                      onPressed: () => _showMenu(context, l10n),
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

  void _showMenu(BuildContext context, AppLocalizations l10n) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(button.size.width, 0),
            ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    showMenu<RouletteCardAction>(
      context: context,
      position: position,
      elevation: 8,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      items: [
        PopupMenuItem(
          value: RouletteCardAction.edit,
          child: _MenuRow(
              icon: Icons.edit_note_rounded, label: l10n.menuEdit),
        ),
        PopupMenuItem(
          value: RouletteCardAction.duplicate,
          child: _MenuRow(
              icon: Icons.copy_rounded, label: l10n.menuDuplicate),
        ),
        PopupMenuItem(
          value: RouletteCardAction.rename,
          child: _MenuRow(
              icon: Icons.drive_file_rename_outline_rounded,
              label: l10n.menuRename),
        ),
        PopupMenuItem(
          value: RouletteCardAction.delete,
          child: _MenuRow(
              icon: Icons.delete_outline_rounded,
              label: l10n.actionDelete,
              isDestructive: true),
        ),
      ],
    ).then((action) {
      if (action != null) _handleAction(context, action);
    });
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
    final l10n = AppLocalizations.of(context)!;
    final ctrl = TextEditingController(text: roulette.name);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.renameTitle),
        content: TextField(
          controller: ctrl,
          maxLength: 30,
          autofocus: true,
          decoration: InputDecoration(
            labelText: l10n.rouletteNameLabel,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () {
              final name = ctrl.text.trim();
              if (name.isNotEmpty) onRename(name);
              Navigator.of(ctx).pop();
            },
            child: Text(l10n.actionRename),
          ),
        ],
      ),
    ).then((_) => ctrl.dispose());
  }

  Future<bool?> _showDeleteConfirm(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteRouletteTitle),
        content: Text(l10n.cardDeleteContent(roulette.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.actionDelete),
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDestructive;
  const _MenuRow({
    required this.icon,
    required this.label,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isDestructive ? colorScheme.error : colorScheme.onSurface;

    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: isDestructive ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _ColorPreview extends StatelessWidget {
  final Roulette roulette;
  const _ColorPreview({required this.roulette});

  @override
  Widget build(BuildContext context) {
    final colors = roulette.items.map((e) => e.color).toList();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: colors.length >= 2 ? colors : [...colors, colors.first],
            ),
          ),
          child: Center(
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
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
