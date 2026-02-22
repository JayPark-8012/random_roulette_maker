import '../../settings/state/settings_notifier.dart';

/// Splash 화면에서 앱 전체 초기화 담당
class SplashNotifier {
  SplashNotifier._();
  static final SplashNotifier instance = SplashNotifier._();

  Future<void> initializeApp() async {
    // 설정 불러오기
    await SettingsNotifier.instance.load();
  }
}
