import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../domain/item.dart';

class ItemListTile extends StatefulWidget {
  final Item item;
  final bool canDelete;
  final bool hasError; // 빈 라벨인데 저장 시도 → 빨간 테두리
  final bool showWeight; // 가중치 편집 모드
  final ValueChanged<String> onLabelChanged;
  final ValueChanged<int>? onColorChanged;
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
    this.onColorChanged,
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

  void _showColorPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => _ColorPickerSheet(
        currentColor: widget.item.color,
        onColorSelected: (color) {
          widget.onColorChanged?.call(color.value);
          Navigator.pop(ctx);
        },
      ),
    );
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
          // 색상 원 - 탭 가능
          GestureDetector(
            onTap: () => _showColorPicker(context),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: widget.item.color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
              ),
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

// ── 컬러 피커 시트 ──────────────────────────────────────
class _ColorPickerSheet extends StatelessWidget {
  final Color currentColor;
  final ValueChanged<Color> onColorSelected;

  const _ColorPickerSheet({
    required this.currentColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // 테마의 팔레트 색상들
    final colors = [
      const Color(0xFF5B5BD6), const Color(0xFFE05858), const Color(0xFF2E9B6E),
      const Color(0xFFE8A22A), const Color(0xFF3B82F6), const Color(0xFFEC4899),
      const Color(0xFF8B5CF6), const Color(0xFF06B6D4), const Color(0xFFF97316), const Color(0xFF64748B),
      const Color(0xFF059669), const Color(0xFF34D399), const Color(0xFF0D9488),
      const Color(0xFF84CC16), const Color(0xFFEAB308), const Color(0xFF0EA5E9),
      const Color(0xFF10B981), const Color(0xFF14B8A6), const Color(0xFF38BDF8), const Color(0xFFEF4444),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '색상 선택',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: colors.map((color) {
              final isSelected = color.value == currentColor.value;
              return GestureDetector(
                onTap: () => onColorSelected(color),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Icon(
                            Icons.check,
                            color: color.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                            size: 24,
                          ),
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

