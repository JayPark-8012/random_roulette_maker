import 'package:flutter/foundation.dart';
import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../data/roulette_repository.dart';
import '../../../domain/item.dart';
import '../../../domain/roulette.dart';

class EditorNotifier extends ChangeNotifier {
  final RouletteRepository _repo = RouletteRepository.instance;

  String? _editingId;
  String _name = '';
  List<Item> _items = [];
  bool _isSaving = false;
  bool _isDirty = false;
  String? _error;
  bool _weightMode = false;

  /// 저장 시도 후 유효성 실패 시 true → 빈 항목에 에러 하이라이트 표시
  bool _showErrors = false;

  String get name => _name;
  List<Item> get items => List.unmodifiable(_items);
  bool get isSaving => _isSaving;
  bool get isDirty => _isDirty;
  String? get error => _error;
  bool get isEditMode => _editingId != null;
  bool get showErrors => _showErrors;
  bool get weightMode => _weightMode;

  /// 빈 라벨을 가진 항목 ID 집합 (하이라이트용)
  Set<String> get invalidItemIds => _items
      .where((e) => e.label.trim().isEmpty)
      .map((e) => e.id)
      .toSet();

  bool get isNameValid => _name.trim().isNotEmpty;
  bool get hasEnoughItems => _items.length >= AppLimits.minItemCount;
  bool get hasEmptyItems => invalidItemIds.isNotEmpty;

  // ── 초기화 ────────────────────────────────────────────

  void initNew({List<String>? prefilledLabels}) {
    _editingId = null;
    _name = '';
    _isDirty = false;
    _showErrors = false;
    _error = null;
    _weightMode = false;
    _items = [];

    if (prefilledLabels != null && prefilledLabels.isNotEmpty) {
      for (int i = 0; i < prefilledLabels.length; i++) {
        _items.add(Item(
          id: AppUtils.generateId(),
          label: prefilledLabels[i],
          colorValue: AppUtils.colorValueForIndex(i),
          order: i,
        ));
      }
    } else {
      _items = [
        Item(
            id: AppUtils.generateId(),
            label: '',
            colorValue: AppUtils.colorValueForIndex(0),
            order: 0),
        Item(
            id: AppUtils.generateId(),
            label: '',
            colorValue: AppUtils.colorValueForIndex(1),
            order: 1),
      ];
    }
    notifyListeners();
  }

  void initEdit(Roulette roulette) {
    _editingId = roulette.id;
    _name = roulette.name;
    _items = List.of(roulette.items);
    _isDirty = false;
    _showErrors = false;
    _error = null;
    _weightMode = false;
    notifyListeners();
  }

  // ── 편집 액션 ─────────────────────────────────────────

  void toggleWeightMode() {
    _weightMode = !_weightMode;
    notifyListeners();
  }

  void updateItemWeight(String itemId, int weight) {
    final idx = _items.indexWhere((e) => e.id == itemId);
    if (idx < 0) return;
    _items[idx] = _items[idx].copyWith(weight: weight.clamp(1, 10));
    _isDirty = true;
    notifyListeners();
  }

  void setName(String value) {
    _name = value;
    _isDirty = true;
    notifyListeners();
  }

  void addItem() {
    final idx = _items.length;
    _items.add(Item(
      id: AppUtils.generateId(),
      label: '',
      colorValue: AppUtils.colorValueForIndex(idx),
      order: idx,
    ));
    _isDirty = true;
    notifyListeners();
  }

  void updateItemLabel(String itemId, String label) {
    final idx = _items.indexWhere((e) => e.id == itemId);
    if (idx < 0) return;
    _items[idx] = _items[idx].copyWith(label: label);
    _isDirty = true;
    notifyListeners();
  }

  void removeItem(String itemId) {
    if (_items.length <= AppLimits.minItemCount) {
      _error = '최소 ${AppLimits.minItemCount}개 항목이 필요합니다.';
      notifyListeners();
      return;
    }
    _items.removeWhere((e) => e.id == itemId);
    _reorderItems();
    _isDirty = true;
    notifyListeners();
  }

  void reorderItems(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final item = _items.removeAt(oldIndex);
    _items.insert(newIndex, item);
    _reorderItems();
    _isDirty = true;
    notifyListeners();
  }

  void _reorderItems() {
    for (int i = 0; i < _items.length; i++) {
      _items[i] = _items[i].copyWith(order: i);
    }
  }

  // ── 저장 ─────────────────────────────────────────────

  Future<bool> save() async {
    // 유효성 검사 → 실패 시 에러 표시 ON
    if (!isNameValid) {
      _error = '룰렛 이름을 입력해 주세요.';
      _showErrors = true;
      notifyListeners();
      return false;
    }
    if (!hasEnoughItems) {
      _error = '항목을 최소 ${AppLimits.minItemCount}개 입력해 주세요.';
      _showErrors = true;
      notifyListeners();
      return false;
    }
    if (hasEmptyItems) {
      _error = '비어있는 항목을 채워 주세요.';
      _showErrors = true;
      notifyListeners();
      return false;
    }

    _isSaving = true;
    _showErrors = false;
    _error = null;
    notifyListeners();

    try {
      final validItems =
          _items.where((e) => e.label.trim().isNotEmpty).toList();

      if (_editingId == null) {
        await _repo.create(name: _name.trim(), items: validItems);
      } else {
        final existing = await _repo.getById(_editingId!);
        if (existing == null) throw Exception('룰렛을 찾을 수 없습니다.');
        await _repo.update(
          existing.copyWith(name: _name.trim(), items: validItems),
        );
      }

      _isDirty = false;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> deleteRoulette() async {
    if (_editingId == null) return;
    try {
      await _repo.delete(_editingId!);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
