import 'package:flutter/foundation.dart';
import 'premium_service.dart';

/// 광고 서비스 (얇은 레이어)
///
/// - 프리미엄 사용자는 모든 광고 함수가 무시됨
/// - 광고 SDK 교체 시 이 파일만 수정하면 됨
/// - 현재는 더미 구현 (로그만 출력)
class AdService {
  AdService._();
  static final AdService instance = AdService._();

  bool get _isPremium => PremiumService.instance.isPremium;

  /// 전면 광고 표시
  ///
  /// 프리미엄: 호출 무시 / 무료: TODO - 실제 광고 SDK 연동
  Future<void> showInterstitial() async {
    if (_isPremium) {
      debugPrint('[AdService] showInterstitial: skipped (premium)');
      return;
    }
    // TODO(Phase 5): 실제 광고 SDK 연동
    debugPrint('[AdService] showInterstitial: called (stub)');
  }

  /// 보상형 광고 표시
  ///
  /// 프리미엄: true 반환(항상 성공) / 무료: TODO - 실제 광고 SDK 연동
  Future<bool> showRewarded() async {
    if (_isPremium) {
      debugPrint('[AdService] showRewarded: skipped (premium) → true');
      return true;
    }
    // TODO(Phase 5): 실제 광고 SDK 연동
    debugPrint('[AdService] showRewarded: called (stub) → false');
    return false;
  }

  /// 배너 광고 표시 요청
  ///
  /// 프리미엄: 호출 무시
  void showBanner() {
    if (_isPremium) {
      debugPrint('[AdService] showBanner: skipped (premium)');
      return;
    }
    // TODO(Phase 5): 실제 배너 SDK 연동
    debugPrint('[AdService] showBanner: called (stub)');
  }

  /// 배너 광고 숨김 요청
  void hideBanner() {
    debugPrint('[AdService] hideBanner: called');
    // TODO(Phase 5): 실제 배너 SDK 연동
  }
}
