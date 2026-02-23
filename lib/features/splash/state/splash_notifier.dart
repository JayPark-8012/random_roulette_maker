import '../../../data/mock_purchase_provider.dart';
import '../../../data/premium_service.dart';
import '../../settings/state/settings_notifier.dart';

/// Splash 화면에서 앱 전체 초기화 담당
class SplashNotifier {
  SplashNotifier._();
  static final SplashNotifier instance = SplashNotifier._();

  Future<void> initializeApp() async {
    // PremiumService 먼저 초기화 (다른 서비스가 의존)
    await PremiumService.initialize(MockPurchaseProvider());
    // 설정 불러오기
    await SettingsNotifier.instance.load();
  }
}
