import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

/// SharedPreferences 기반 로컬 저장소.
/// 앱 수명 동안 싱글턴으로 사용. main()에서 init() 호출 후 사용.
class LocalStorage {
  LocalStorage._();
  static final LocalStorage instance = LocalStorage._();

  SharedPreferences? _prefs;

  /// 앱 시작 시 1회 호출. Splash에서 await.
  /// web 환경에서는 자동으로 shared_preferences가 초기화됨
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _ensureSchemaVersion();
  }

  SharedPreferences get _p {
    // web 환경이나 초기화 중일 때도 안전하게 처리
    if (_prefs == null) {
      // SharedPreferences가 아직 초기화되지 않았으면, 임시로 메모리 기반 구현 사용
      // (실제로는 웹에서는 자동 초기화되므로 이 코드는 실행되지 않음)
      throw StateError('LocalStorage.init()을 먼저 호출하세요.');
    }
    return _prefs!;
  }

  // ── 기본 읽기/쓰기 ────────────────────────────────────

  Future<String?> getString(String key) async => _p.getString(key);

  Future<void> setString(String key, String value) async =>
      await _p.setString(key, value);

  Future<void> remove(String key) async => await _p.remove(key);

  Future<bool> getBool(String key, {bool defaultValue = false}) async =>
      _p.getBool(key) ?? defaultValue;

  Future<void> setBool(String key, bool value) async =>
      await _p.setBool(key, value);

  // ── JSON 헬퍼 ─────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getJsonList(String key) async {
    try {
      final raw = _p.getString(key);
      if (raw == null || raw.isEmpty) return [];
      try {
        final decoded = jsonDecode(raw) as List<dynamic>;
        return decoded.cast<Map<String, dynamic>>();
      } catch (_) {
        return [];
      }
    } catch (e) {
      // LocalStorage 미초기화 상태에서는 빈 리스트 반환
      return [];
    }
  }

  Future<void> setJsonList(
      String key, List<Map<String, dynamic>> list) async {
    try {
      await _p.setString(key, jsonEncode(list));
    } catch (e) {
      // 무시 (web 환경이나 초기화 전)
    }
  }

  Future<Map<String, dynamic>?> getJsonMap(String key) async {
    try {
      final raw = _p.getString(key);
      if (raw == null || raw.isEmpty) return null;
      try {
        return jsonDecode(raw) as Map<String, dynamic>;
      } catch (_) {
        return null;
      }
    } catch (e) {
      // LocalStorage 미초기화 상태에서는 null 반환
      return null;
    }
  }

  Future<void> setJsonMap(String key, Map<String, dynamic> map) async {
    try {
      await _p.setString(key, jsonEncode(map));
    } catch (e) {
      // 무시 (web 환경이나 초기화 전)
    }
  }

  // ── 스키마 버전 관리 ──────────────────────────────────

  static const int _currentSchemaVersion = 1;

  Future<void> _ensureSchemaVersion() async {
    final stored = _p.getInt(StorageKeys.appDataVersion);
    if (stored == null) {
      await _p.setInt(StorageKeys.appDataVersion, _currentSchemaVersion);
    }
    // 향후: stored < _currentSchemaVersion 이면 마이그레이션 로직 추가
  }
}
