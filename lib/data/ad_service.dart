// 광고 서비스 진입점 — 플랫폼별 구현 분기
//
// - Android/iOS : ad_service_mobile.dart (google_mobile_ads 실제 구현)
// - Web         : ad_service_web.dart    (no-op stub, 광고 없음)
//
// 외부에서는 항상 이 파일만 import:
//   import 'ad_service.dart';
export 'ad_service_mobile.dart'
    if (dart.library.html) 'ad_service_web.dart';
