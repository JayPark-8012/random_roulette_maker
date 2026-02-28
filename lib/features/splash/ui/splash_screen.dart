import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../data/local_storage.dart';
import '../../../data/premium_service.dart';
import '../../../data/mock_purchase_provider.dart';
import '../state/splash_notifier.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.wait([
      LocalStorage.instance.init(),
      PremiumService.initialize(MockPurchaseProvider()),
      Future.delayed(const Duration(seconds: 1)),
    ]);

    if (!mounted) return;

    await SplashNotifier.instance.initializeApp();

    if (!mounted) return;

    // 첫 실행이면 온보딩 → 홈, 아니면 바로 홈
    final hasCompleted = await LocalStorage.instance
        .getBool(StorageKeys.hasCompletedFirstRun);
    if (!mounted) return;

    if (hasCompleted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 전체 화면 스플래시 이미지
          Image.asset(
            'assets/icons/splash_image.png',
            fit: BoxFit.cover,
          ),
          // 하단 로딩 인디케이터
          Positioned(
            left: 0,
            right: 0,
            bottom: 48,
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
