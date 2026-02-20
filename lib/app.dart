import 'package:flutter/material.dart';
import 'core/app_themes.dart';
import 'core/constants.dart';
import 'features/settings/state/settings_notifier.dart';
import 'features/splash/ui/splash_screen.dart';
import 'features/home/ui/home_screen.dart';
import 'features/editor/ui/editor_screen.dart';
import 'features/play/ui/play_screen.dart';
import 'features/templates/ui/templates_screen.dart';
import 'features/settings/ui/settings_screen.dart';

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
    _settings.load();
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
      theme: themeData.buildTheme(Brightness.light),
      darkTheme: themeData.buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.editor: (_) => const EditorScreen(),
        AppRoutes.play: (_) => const PlayScreen(),
        AppRoutes.templates: (_) => const TemplatesScreen(),
        AppRoutes.settings: (_) => const SettingsScreen(),
      },
    );
  }
}
