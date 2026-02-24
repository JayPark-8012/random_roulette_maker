import 'package:flutter/widgets.dart';

/// 광고 서비스 — Web 전용 no-op stub
///
/// google_mobile_ads 는 Web 미지원 → 모든 메서드가 아무것도 하지 않음.
/// 외부에서는 ad_service.dart(conditional export)를 통해서만 접근.
class AdService {
  AdService._();
  static final AdService instance = AdService._();

  Future<void> initialize() async {}

  Future<void> showInterstitial() async {}

  Future<void> tryShowInterstitialAfterSpin() async {}

  Widget bannerWidget() => const SizedBox.shrink();

  Future<bool> showRewarded() async => false;

  void onPremiumActivated() {}
}
