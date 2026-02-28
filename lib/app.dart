import 'package:flutter/material.dart';
import 'core/app_themes.dart';
import 'core/constants.dart';
import 'features/settings/state/settings_notifier.dart';
import 'l10n/app_localizations.dart';
import 'features/splash/ui/splash_screen.dart';
import 'features/home/ui/home_screen.dart';
import 'features/editor/ui/editor_screen.dart';
import 'features/play/ui/play_screen.dart';
import 'features/templates/ui/templates_screen.dart';
import 'features/settings/ui/settings_screen.dart';
import 'features/paywall/ui/paywall_screen.dart';

/// 부드러운 페이지 전환 애니메이션
class SmoothPageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;
  final String? title;

  SmoothPageRoute({
    required this.builder,
    this.title,
    super.settings,
  });

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic)),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _settings = SettingsNotifier.instance;

  @override
  void initState() {
    super.initState();
    _settings.addListener(_onThemeChanged);
    // load()는 Splash에서 LocalStorage 초기화 후 호출됨
  }

  @override
  void dispose() {
    _settings.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final themeData = AppThemes.findById(_settings.themeId);
    return MaterialApp(
      title: '랜덤 룰렛 메이커',
      debugShowCheckedModeBanner: false,
      locale: _settings.appLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: themeData.buildTheme(),
      themeMode: ThemeMode.dark,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case AppRoutes.splash:
            page = const SplashScreen();
            break;
          case AppRoutes.home:
            page = const HomeScreen();
            break;
          case AppRoutes.editor:
            page = const EditorScreen();
            break;
          case AppRoutes.play:
            page = const PlayScreen();
            break;
          case AppRoutes.templates:
            page = const TemplatesScreen();
            break;
          case AppRoutes.settings:
            page = const SettingsScreen();
            break;
          case AppRoutes.paywall:
            page = const PaywallScreen();
            break;
          default:
            page = const HomeScreen();
        }
        return SmoothPageRoute(builder: (_) => page, settings: settings);
      },
    );
  }
}
