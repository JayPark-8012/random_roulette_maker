import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../domain/roulette.dart';
import '../state/editor_notifier.dart';
import '../widgets/item_list_tile.dart';
import '../../play/widgets/roulette_wheel.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final EditorNotifier _notifier = EditorNotifier();
  late final TextEditingController _nameCtrl;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Roulette) {
      // 기존 룰렛 편집 모드
      _notifier.initEdit(args);
      _nameCtrl.text = args.name;
    } else if (args is Map<String, dynamic>) {
      // 템플릿에서 진입: 항목 사전 입력 + 이름 자동 설정
      final templateItems = (args['templateItems'] as List<dynamic>).cast<String>();
      final templateName = args['templateName'] as String? ?? '';
      _notifier.initNew(prefilledLabels: templateItems);
      _notifier.setName(templateName);
      _nameCtrl.text = templateName;
    } else {
      // 신규 생성 모드
      _notifier.initNew();
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _handleBack(context);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: AnimatedBuilder(
            animation: _notifier,
            builder: (_, _) => Text(
              _notifier.isEditMode ? '룰렛 편집' : '룰렛 만들기',
              style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.8),
            ),
          ),
          actions: [
            AnimatedBuilder(
              animation: _notifier,
              builder: (_, _) => _notifier.isEditMode
                  ? IconButton(
                      icon: const Icon(Icons.delete_outline_rounded),
                      tooltip: '룰렛 삭제',
                      onPressed: () => _confirmDelete(context),
                    )
                  : const SizedBox.shrink(),
            ),
            AnimatedBuilder(
              animation: _notifier,
              builder: (_, _) => _notifier.isSaving
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilledButton(
                        onPressed: () => _save(context),
                        child: const Text('저장',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
            ),
          ],
        ),
        body: AnimatedBuilder(
          animation: _notifier,
          builder: (context, _) {
            return Column(
              children: [
                if (_notifier.error != null)
                  MaterialBanner(
                    content: Text(_notifier.error!),
                    actions: [
                      TextButton(
                        onPressed: _notifier.clearError,
                        child: const Text('닫기'),
                      ),
                    ],
                  ),
                // 룰렛 이름 입력
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: TextField(
                    controller: _nameCtrl,
                    maxLength: AppLimits.maxNameLength,
                    decoration: InputDecoration(
                      labelText: '룰렛 이름',
                      hintText: '예: 오늘 점심 메뉴',
                      border: const OutlineInputBorder(),
                      errorText: (_notifier.showErrors && !_notifier.isNameValid)
                          ? '이름을 입력해 주세요'
                          : null,
                    ),
                    onChanged: _notifier.setName,
                  ),
                ),
                // 리얼타임 미니 휠 프리뷰
                _MiniWheelPreview(items: _notifier.items),
                // 항목 목록 헤더
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  child: Row(
                    children: [
                      Text(
                        '항목 (${_notifier.items.length}개)',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const Spacer(),
                      Text(
                        '드래그하여 순서 변경',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant
                                  .withOpacity(0.5),
                            ),
                      ),
                    ],
                  ),
                ),
                // 항목 재정렬 리스트
                Expanded(
                  child: ReorderableListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: _notifier.items.length,
                    onReorder: _notifier.reorderItems,
                    itemBuilder: (ctx, i) {
                      final item = _notifier.items[i];
                      return ItemListTile(
                        key: Key(item.id),
                        item: item,
                        canDelete:
                            _notifier.items.length > AppLimits.minItemCount,
                        hasError: _notifier.showErrors &&
                            _notifier.invalidItemIds.contains(item.id),
                        onLabelChanged: (v) =>
                            _notifier.updateItemLabel(item.id, v),
                        onColorChanged: (colorValue) =>
                            _notifier.updateItemColor(item.id, colorValue),
                        onDelete: () => _notifier.removeItem(item.id),
                        showWeight: true,
                        onWeightChanged: (w) =>
                            _notifier.updateItemWeight(item.id, w),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
        // 항목 추가 버튼
        floatingActionButton: FloatingActionButton.small(
          onPressed: _notifier.addItem,
          tooltip: '항목 추가',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _save(BuildContext context) async {
    final navigator = Navigator.of(context);
    final success = await _notifier.save();
    if (success && mounted) {
      navigator.pop();
    }
  }

  Future<void> _handleBack(BuildContext context) async {
    final navigator = Navigator.of(context);
    if (!_notifier.isDirty) {
      navigator.pop();
      return;
    }
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('저장하지 않고 나가기'),
        content: const Text('변경사항이 저장되지 않습니다. 나가시겠어요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('계속 편집'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('나가기'),
          ),
        ],
      ),
    );
    if (leave == true && mounted) {
      navigator.pop();
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final navigator = Navigator.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('룰렛 삭제'),
        content: const Text('이 룰렛을 삭제할까요?\n히스토리도 함께 삭제됩니다.'),
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
    if (confirmed == true && mounted) {
      await _notifier.deleteRoulette();
      if (mounted) navigator.pop();
    }
  }
}

// ─── 미니 휠 프리뷰 ───────────────────────────────────────────────
class _MiniWheelPreview extends StatelessWidget {
  final List<dynamic> items;
  const _MiniWheelPreview({required this.items});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          // 미니 휠
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  painter: RouletteWheelPainter(
                    items: items.cast(),
                    rotationAngle: 0,
                  ),
                  size: const Size(100, 100),
                ),
                Positioned(
                  top: 0,
                  child: CustomPaint(
                    size: const Size(12, 18),
                    painter: _MiniPointerPainter(color: colorScheme.error),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // 아이템 요약 리스트
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '실시간 프리뷰',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 6),
                ...items.take(5).map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: item.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.label.isEmpty ? '(빈 항목)' : item.label,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: item.label.isEmpty
                                      ? colorScheme.onSurfaceVariant
                                          .withOpacity(0.4)
                                      : colorScheme.onSurface,
                                  fontStyle: item.label.isEmpty
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                if (items.length > 5)
                  Padding(
                    padding: const EdgeInsets.only(top: 2, left: 16),
                    child: Text(
                      '+ ${items.length - 5}개 더',
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniPointerPainter extends CustomPainter {
  final Color color;
  const _MiniPointerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_MiniPointerPainter old) => old.color != color;
}
