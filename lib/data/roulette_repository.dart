import 'package:random_roulette_maker/data/premium_service.dart';

import '../core/constants.dart';
import '../core/utils.dart';
import '../domain/roulette.dart';
import '../domain/history.dart';
import '../domain/item.dart';
import 'local_storage.dart';

/// 룰렛 CRUD + 히스토리 관리
class RouletteRepository {
  RouletteRepository._();
  static final RouletteRepository instance = RouletteRepository._();
  bool get _isPremium => PremiumService.instance.isPremium;

  final LocalStorage _storage = LocalStorage.instance;

  // ── 룰렛 목록 조회 ────────────────────────────────────

  Future<List<Roulette>> getAll() async {
    final list = await _storage.getJsonList(StorageKeys.rouletteList);
    return list.map(Roulette.fromJson).toList();
  }

  Future<Roulette?> getById(String id) async {
    final all = await getAll();
    try {
      return all.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── 제한 확인 ─────────────────────────────────────────

  Future<bool> canCreate() async {
    final all = await getAll();
    if(_isPremium) return true;
    return all.length < AppLimits.maxRouletteCount;
  }

  Future<int> currentCount() async {
    final all = await getAll();
    return all.length;
  }

  // ── 룰렛 저장 / 수정 ─────────────────────────────────

  /// 신규 생성. 제한 초과 시 Exception 발생.
  Future<Roulette> create({
    required String name,
    required List<Item> items,
  }) async {
    if (!await canCreate()) {
      throw Exception('Max roulette limit reached (${AppLimits.maxRouletteCount}).');
    }

    final now = DateTime.now();
    final roulette = Roulette(
      id: AppUtils.generateId(),
      name: name,
      items: items,
      createdAt: now,
      updatedAt: now,
    );

    final all = await getAll();
    all.add(roulette);
    await _saveAll(all);
    return roulette;
  }

  /// 기존 룰렛 수정
  Future<Roulette> update(Roulette roulette) async {
    final updated = roulette.copyWith(updatedAt: DateTime.now());
    final all = await getAll();
    final idx = all.indexWhere((r) => r.id == roulette.id);
    if (idx < 0) throw Exception('Roulette not found: ${roulette.id}');
    all[idx] = updated;
    await _saveAll(all);
    return updated;
  }

  /// 룰렛 삭제 (히스토리 cascade)
  Future<void> delete(String id) async {
    final all = await getAll();
    all.removeWhere((r) => r.id == id);
    await _saveAll(all);
    // 히스토리도 삭제
    await _storage.remove(StorageKeys.historyKey(id));
  }

  /// 마지막 플레이 시각 업데이트
  Future<void> updateLastPlayed(String id) async {
    final roulette = await getById(id);
    if (roulette == null) return;
    await update(roulette.copyWith(lastPlayedAt: DateTime.now()));
  }

  Future<void> _saveAll(List<Roulette> list) async {
    await _storage.setJsonList(
      StorageKeys.rouletteList,
      list.map((r) => r.toJson()).toList(),
    );
  }

  // ── 히스토리 ──────────────────────────────────────────

  Future<List<History>> getHistory(String rouletteId) async {
    final list = await _storage.getJsonList(StorageKeys.historyKey(rouletteId));
    return list.map(History.fromJson).toList();
  }

  Future<void> addHistory(History history) async {
    final key = StorageKeys.historyKey(history.rouletteId);
    final list = await _storage.getJsonList(key);
    list.add(history.toJson());

    // FIFO: 최대 개수 초과 시 오래된 항목 제거
    while (list.length > AppLimits.maxHistoryCount) {
      list.removeAt(0);
    }

    await _storage.setJsonList(key, list);
  }
}
