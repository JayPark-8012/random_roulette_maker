import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/premium_state.dart';
import '../../domain/purchase_provider.dart';

/// 프리미엄 상태 관리 서비스
/// 
/// 싱글톤으로 관리되는 중앙 상태 관리자
/// - PremiumState 저장/로드
/// - 구매 로직 위임 (PurchaseProvider)
/// - ValueNotifier로 상태 노티파이
class PremiumService extends ChangeNotifier {
  static PremiumService? _instance;
  static final _lock = Object();

  final PurchaseProvider _purchaseProvider;
  late final SharedPreferences _prefs;
  
  late ValueNotifier<PremiumState> _stateNotifier;
  
  static const _storageKey = 'premium_state_json';

  PremiumService._(this._purchaseProvider);

  /// 싱글톤 인스턴스 획득
  static PremiumService get instance {
    if (_instance == null) {
      throw StateError('PremiumService not initialized. Call initialize() first.');
    }
    return _instance!;
  }

  /// 초기화 (App 시작 시 호출)
  static Future<void> initialize(PurchaseProvider purchaseProvider) async {
    if (_instance != null) return;

    await synchronized(_lock, () async {
      _instance = PremiumService._(purchaseProvider);
      await _instance!._loadState();
    });
  }

  /// 비동기 lock 헬퍼
  static Future<T> synchronized<T>(Object lock, Future<T> Function() compute) async {
    // 간단한 구현: 실제로는 더 정교한 동기화 필요할 수 있음
    return compute();
  }

  /// 상태 로드 (SharedPreferences에서)
  Future<void> _loadState() async {
    _prefs = await SharedPreferences.getInstance();
    
    try {
      final jsonStr = _prefs.getString(_storageKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final json = jsonDecode(jsonStr) as Map<String, dynamic>;
        _stateNotifier = ValueNotifier(PremiumState.fromJson(json));
      } else {
        _stateNotifier = ValueNotifier(PremiumState.free());
      }
    } catch (e) {
      debugPrint('PremiumService: Failed to load state - $e');
      _stateNotifier = ValueNotifier(PremiumState.free());
    }

    // 상태 변경 알림
    notifyListeners();
  }

  /// 상태 저장 (SharedPreferences에)
  Future<void> _saveState(PremiumState state) async {
    try {
      final json = state.toJson();
      final jsonStr = jsonEncode(json);
      await _prefs.setString(_storageKey, jsonStr);
      debugPrint('PremiumService: State saved - $state');
    } catch (e) {
      debugPrint('PremiumService: Failed to save state - $e');
      rethrow;
    }
  }

  /// 현재 프리미엄 상태 조회
  PremiumState get state => _stateNotifier.value;

  /// 프리미엄 여부 (편의 메서드)
  bool get isPremium => state.isPremium;

  /// 상태 Stream (리스닝용)
  ValueNotifier<PremiumState> get stateNotifier => _stateNotifier;

  /// 프리미엄 구매
  /// 
  /// PurchaseProvider에 위임하고, 성공 시 상태 업데이트
  Future<bool> purchase() async {
    try {
      final success = await _purchaseProvider.purchase();
      if (success) {
        final newState = PremiumState.premium();
        _stateNotifier.value = newState;
        await _saveState(newState);
        notifyListeners();
      }
      return success;
    } catch (e) {
      debugPrint('PremiumService.purchase failed: $e');
      rethrow;
    }
  }

  /// 구매 복구
  Future<bool> restorePurchases() async {
    try {
      final restored = await _purchaseProvider.restorePurchases();
      if (restored) {
        final newState = PremiumState.premium();
        _stateNotifier.value = newState;
        await _saveState(newState);
        notifyListeners();
      }
      return restored;
    } catch (e) {
      debugPrint('PremiumService.restorePurchases failed: $e');
      rethrow;
    }
  }

  /// 프리미엄 상태 초기화 (테스트용)
  @visibleForTesting
  Future<void> resetForTesting() async {
    _stateNotifier.value = PremiumState.free();
    await _prefs.remove(_storageKey);
    notifyListeners();
  }

  // ── 세트 수 제한 헬퍼 ─────────────────────────────────────

  /// 최대 룰렛 세트 수 (null = 무제한/프리미엄)
  int? get maxSets => isPremium ? null : 3;

  /// 프리미엄 = 무제한 세트
  bool get isUnlimitedSets => isPremium;

  /// 세트 수 표시 문자열
  ///
  /// 무료: "2/3" / 프리미엄: "2/∞"
  String formatSetCountLabel(int current) =>
      isPremium ? '$current/∞' : '$current/${maxSets ?? 3}';

  /// 새 룰렛 세트 생성 가능 여부
  ///
  /// 프리미엄: 무제한 / 무료: 최대 3개
  bool canCreateNewSet(int currentCount) {
    if (isPremium) return true;
    return currentCount < 3;
  }

  /// canCreateNewSet 이전 이름 (하위 호환)
  bool canCreateRoulette(int currentRouletteCount) =>
      canCreateNewSet(currentRouletteCount);

  // ── Atmosphere 제한 헬퍼 ─────────────────────────────────

  /// Atmosphere 배경 프리셋 사용 가능 여부
  ///
  /// 프리미엄: 모든 프리셋 사용
  /// 무료: 'deep_space', 'charcoal' 2개만 사용
  bool canUseAtmosphere(String id) {
    if (isPremium) return true;
    return id == 'deep_space' || id == 'charcoal';
  }

  // ── 팔레트 제한 헬퍼 ──────────────────────────────────────

  /// 팔레트 사용 가능 여부
  ///
  /// 프리미엄: 모든 팔레트 사용
  /// 무료: 'indigo', 'emerald' 2개만 사용
  bool canUsePalette(String themeId) {
    if (isPremium) return true;
    return themeId == 'indigo' || themeId == 'emerald';
  }

  /// 룰렛 휠 테마 사용 가능 여부
  ///
  /// 프리미엄: 모든 휠 테마 사용
  /// 무료: 'classic', 'candy' 2개만 사용
  bool canUseWheelTheme(String wheelThemeId) {
    if (isPremium) return true;
    return wheelThemeId == 'classic' || wheelThemeId == 'candy';
  }

  // ── 사다리 참가자 수 제한 ─────────────────────────────────

  static const maxFreeLadderParticipants = 6;
  static const maxPremiumLadderParticipants = 12;

  /// 사다리 참가자 추가 가능 여부
  static bool canAddLadderParticipant(bool isPremium, int currentCount) {
    final max = isPremium
        ? maxPremiumLadderParticipants
        : maxFreeLadderParticipants;
    return currentCount < max;
  }

  // ── 주사위 타입 제한 ──────────────────────────────────────

  static const freeAllowedDice = ['D6'];
  static const premiumAllowedDice = ['D4', 'D6', 'D8', 'D10', 'D12', 'D20'];

  /// 주사위 타입 사용 가능 여부
  static bool canUseDiceType(bool isPremium, String diceType) {
    if (isPremium) return true;
    return freeAllowedDice.contains(diceType);
  }

  // ── 숫자 범위 제한 ────────────────────────────────────────

  static const maxFreeNumberRange = 9999;
  static const maxPremiumNumberRange = 999999999;

  /// 숫자 최댓값 범위 허용 여부
  static bool isNumberRangeAllowed(bool isPremium, int max) {
    final limit = isPremium
        ? maxPremiumNumberRange
        : maxFreeNumberRange;
    return max <= limit;
  }

  /// 무료 플랜 제한 정보 반환
  Map<String, dynamic> get freeLimits => {
    'maxRouletteSets': 3,
    'availablePalettes': ['indigo', 'emerald'],
    'availableWheelThemes': ['classic', 'candy'],
    'availableAtmospheres': ['deep_space', 'charcoal'],
    'maxLadderParticipants': maxFreeLadderParticipants,
    'allowedDice': freeAllowedDice,
    'maxNumberRange': maxFreeNumberRange,
  };
}
