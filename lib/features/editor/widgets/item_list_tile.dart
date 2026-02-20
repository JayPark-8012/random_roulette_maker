import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../domain/item.dart';

class ItemListTile extends StatefulWidget {
  final Item item;
  final bool canDelete;
  final bool hasError; // 빈 라벨인데 저장 시도 → 빨간 테두리
  final bool showWeight; // 가중치 편집 모드
  final ValueChanged<String> onLabelChanged;
  final VoidCallback onDelete;
  final ValueChanged<int>? onWeightChanged;

  const ItemListTile({
    super.key,
    required this.item,
    required this.canDelete,
    required this.onLabelChanged,
    required this.onDelete,
    this.hasError = false,
    this.showWeight = false,
    this.onWeightChanged,
  });

  @override
  State<ItemListTile> createState() => _ItemListTileState();
}

class _ItemListTileState extends State<ItemListTile> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.item.label);
  }

  @override
  void didUpdateWidget(ItemListTile old) {
    super.didUpdateWidget(old);
    if (old.item.label != widget.item.label &&
        _ctrl.text != widget.item.label) {
      _ctrl.text = widget.item.label;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isError = widget.hasError && widget.item.label.trim().isEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 드래그 핸들
          ReorderableDragStartListener(
            index: widget.item.order,
            child: Icon(Icons.drag_handle, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(width: 12),
          // 색상 원
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: widget.item.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          // 텍스트 입력
          Expanded(
            child: TextField(
              controller: _ctrl,
              maxLength: AppLimits.maxLabelLength,
              decoration: InputDecoration(
                hintText: '항목 이름',
                counterText: '',
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: const OutlineInputBorder(),
                errorText: isError ? '필수 입력' : null,
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colorScheme.error, width: 2),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colorScheme.error, width: 2),
                ),
              ),
              onChanged: widget.onLabelChanged,
            ),
          ),
          // 가중치 조절 (+/-)
          if (widget.showWeight) ...[
            const SizedBox(width: 4),
            _WeightControl(
              weight: widget.item.weight,
              onChanged: widget.onWeightChanged,
            ),
          ],
          const SizedBox(width: 4),
          // 삭제 버튼
          IconButton(
            icon: Icon(
              Icons.close,
              color: widget.canDelete
                  ? colorScheme.error
                  : colorScheme.outlineVariant,
            ),
            onPressed: widget.canDelete ? widget.onDelete : null,
            tooltip: '항목 삭제',
          ),
        ],
      ),
    );
  }
}

class _WeightControl extends StatelessWidget {
  final int weight;
  final ValueChanged<int>? onChanged;

  const _WeightControl({required this.weight, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SmallIconButton(
          icon: Icons.remove,
          onTap: weight > 1 ? () => onChanged?.call(weight - 1) : null,
          color: colorScheme.primary,
        ),
        SizedBox(
          width: 22,
          child: Text(
            '$weight',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
          ),
        ),
        _SmallIconButton(
          icon: Icons.add,
          onTap: weight < 10 ? () => onChanged?.call(weight + 1) : null,
          color: colorScheme.primary,
        ),
      ],
    );
  }
}

class _SmallIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;

  const _SmallIconButton(
      {required this.icon, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          icon,
          size: 16,
          color: onTap != null ? color : color.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
