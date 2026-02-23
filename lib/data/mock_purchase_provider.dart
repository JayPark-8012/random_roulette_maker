import 'package:flutter/foundation.dart';
import '../../domain/purchase_provider.dart';

/// Mock 구현: 개발/테스트용 구매 제공자
/// 
/// 실제 결제 없이 구매 성공/실패를 시뮬레이션
class MockPurchaseProvider extends PurchaseProvider {
  /// 구매 성공 여부 시뮬레이션 플래그
  /// 
  /// true: 구매 성공 시뮬레이션
  /// false: 구매 실패 시뮬레이션
  bool shouldSucceed;

  /// 복구 시 성공 여부
  bool _shouldRestoreSucceed = false;

  MockPurchaseProvider({
    this.shouldSucceed = true,
  });

  @override
  Future<bool> purchase() async {
    debugPrint('[MockPurchaseProvider] purchase() called');

    // 구매 프로세스 시뮬레이션 (1초 지연)
    await Future.delayed(const Duration(seconds: 1));

    if (shouldSucceed) {
      debugPrint('[MockPurchaseProvider] purchase() SUCCESS');
      _shouldRestoreSucceed = true; // 복구도 성공하도록 설정
      return true;
    } else {
      debugPrint('[MockPurchaseProvider] purchase() FAILED');
      return false;
    }
  }

  @override
  Future<bool> restorePurchases() async {
    debugPrint('[MockPurchaseProvider] restorePurchases() called');

    // 복구 프로세스 시뮬레이션 (0.5초 지연)
    await Future.delayed(const Duration(milliseconds: 500));

    if (_shouldRestoreSucceed) {
      debugPrint('[MockPurchaseProvider] restorePurchases() SUCCESS');
      return true;
    } else {
      debugPrint('[MockPurchaseProvider] restorePurchases() NO PURCHASE');
      return false;
    }
  }

  /// 테스트용: 구매 상태 초기화
  void resetForTesting() {
    _shouldRestoreSucceed = false;
    debugPrint('[MockPurchaseProvider] resetForTesting() called');
  }
}
