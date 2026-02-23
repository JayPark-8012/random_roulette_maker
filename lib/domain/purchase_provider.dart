/// 결제 제공자 추상 인터페이스
/// 
/// 실제 In-App Purchase 또는 Mock 구현체가 상속
abstract class PurchaseProvider {
  /// 프리미엄 구매 시도
  /// 
  /// 성공 시: true 반환
  /// 실패 시: false 반환 또는 예외 발생
  Future<bool> purchase();

  /// 기존 구매 복구 (앱 재설치 후 복구 등)
  /// 
  /// 구매 기록이 있으면: true
  /// 구매 기록이 없으면: false
  Future<bool> restorePurchases();
}
