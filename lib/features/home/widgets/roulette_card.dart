import 'package:flutter/material.dart';
import '../../../core/design_tokens.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/glass_card.dart';
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
  final String? lastResult;

  const RouletteCard({
    super.key,
    required this.roulette,
    required this.onTap,
    required this.onEdit,
    required this.onDuplicate,
    required this.onRename,
    required this.onDelete,
    this.lastResult,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final tintColor = roulette.items.isNotEmpty
        ? roulette.items.first.color
        : AppColors.primary;

    return Dismissible(
      key: Key(roulette.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(AppDimens.cardRadius),
        ),
        child: Icon(Icons.delete_rounded, color: colorScheme.onError),
      ),
      confirmDismiss: (_) async => _showDeleteConfirm(context),
      onDismissed: (_) => onDelete(),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppDimens.cardRadius),
            splashColor: AppColors.primary.withValues(alpha: 0.08),
            highlightColor: AppColors.primary.withValues(alpha: 0.04),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 14, 12, 14),
              child: Row(
                children: [
                  // ── 3px 세로 액센트 바 ──
                  Container(
                    width: 3,
                    height: 48,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: tintColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // ── 미니 휠 프리뷰 + 퍼플 글로우 ──
                  _ColorPreview(roulette: roulette),
                  const SizedBox(width: 14),
                  // ── 텍스트 영역 ──
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          roulette.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              l10n.itemCount(roulette.items.length),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (roulette.lastPlayedAt != null) ...[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Text(
                                  '·',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              Text(
                                AppUtils.formatRelativeDate(
                                    roulette.lastPlayedAt!),
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      Colors.white.withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (lastResult != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            lastResult!,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // ── 재생 버튼: Primary 원형 + 글로우 ──
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.45),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // ── 더보기 버튼: 흰색 10% bg, 8px radius ──
                  InkWell(
                    onTap: () => _showMenu(context, l10n),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.more_horiz_rounded,
                        color: AppColors.textSecondary,
                        size: 18,
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

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.40),
            blurRadius: 16,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: SweepGradient(
            colors: colors.length >= 2
                ? colors
                : [...colors, colors.first],
          ),
        ),
        child: Center(
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
