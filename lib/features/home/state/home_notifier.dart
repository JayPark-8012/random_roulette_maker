import 'package:flutter/foundation.dart';
import '../../../core/utils.dart';
import '../../../data/premium_service.dart';
import '../../../data/roulette_repository.dart';
import '../../../domain/roulette.dart';

class HomeNotifier extends ChangeNotifier {
  final RouletteRepository _repo = RouletteRepository.instance;

  List<Roulette> _roulettes = [];
  bool _isLoading = false;
  String? _error;

  List<Roulette> get roulettes => List.unmodifiable(_roulettes);
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get count => _roulettes.length;
  bool get canCreate => PremiumService.instance.canCreateNewSet(count);

  // ── 조회 ──────────────────────────────────────────────

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _roulettes = await _repo.getAll();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int> countFromRepo() async => await _repo.currentCount();

  // ── 삭제 ──────────────────────────────────────────────

  Future<void> delete(String id) async {
    try {
      await _repo.delete(id);
      _roulettes.removeWhere((r) => r.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ── 복제 ──────────────────────────────────────────────

  /// 룰렛을 복사한 뒤 "[복사] 이름"으로 저장.
  /// 3개 제한 초과 시 Exception → error 세팅 후 null 반환.
  Future<String?> duplicate(String id) async {
    try {
      final original = await _repo.getById(id);
      if (original == null) return null;

      final copyName = '[복사] ${original.name}';
      final newName = copyName.length > 30 ? copyName.substring(0, 30) : copyName;

      final newItems = original.items
          .map((item) => item.copyWith(id: AppUtils.generateId()))
          .toList();

      final created = await _repo.create(name: newName, items: newItems);
      _roulettes.add(created);
      notifyListeners();
      return created.id;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // ── 이름 변경 ──────────────────────────────────────────

  Future<void> rename(String id, String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;
    try {
      final roulette = await _repo.getById(id);
      if (roulette == null) return;
      final updated = await _repo.update(roulette.copyWith(name: trimmed));
      final idx = _roulettes.indexWhere((r) => r.id == id);
      if (idx >= 0) {
        _roulettes[idx] = updated;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ── 더미 생성 (SharedPreferences 저장 전 첫 실행용) ──

  Future<void> createDummy(Roulette roulette) async {
    try {
      await _repo.create(name: roulette.name, items: roulette.items);
    } catch (_) {}
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
