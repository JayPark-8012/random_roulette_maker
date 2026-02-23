import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../data/local_storage.dart';
import '../../../l10n/app_localizations.dart';
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
    // 저장소 초기화 + 최소 1초 표시
    await Future.wait([
      LocalStorage.instance.init(),
      Future.delayed(const Duration(seconds: 1)),
    ]);

    if (!mounted) return;
    
    // SettingsNotifier 로드
    await SplashNotifier.instance.initializeApp();

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO(Phase2): 앱 아이콘 이미지로 교체
            Icon(
              Icons.casino_rounded,
              size: 96,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.splashTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.splashSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withAlpha(204),
                  ),
            ),
            const SizedBox(height: 48),
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onPrimary,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
