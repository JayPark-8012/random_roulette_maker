import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../domain/item.dart';

class ItemListTile extends StatefulWidget {
  final Item item;
  final bool canDelete;
  final bool hasError; // 빈 라벨인데 저장 시도 → 빨간 테두리
  final ValueChanged<String> onLabelChanged;
  final VoidCallback onDelete;

  const ItemListTile({
    super.key,
    required this.item,
    required this.canDelete,
    required this.onLabelChanged,
    required this.onDelete,
    this.hasError = false,
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
