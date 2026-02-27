import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'design_tokens.dart';

// ── 팔레트 정의 ─────────────────────────────────────────
const _indigoPalette = [
  Color(0xFF5B5BD6), Color(0xFFE05858), Color(0xFF2E9B6E),
  Color(0xFFE8A22A), Color(0xFF3B82F6), Color(0xFFEC4899),
  Color(0xFF8B5CF6), Color(0xFF06B6D4), Color(0xFFF97316), Color(0xFF64748B),
];

const _emeraldPalette = [
  Color(0xFF059669), Color(0xFF34D399), Color(0xFF0D9488),
  Color(0xFF84CC16), Color(0xFFEAB308), Color(0xFFF97316),
  Color(0xFF3B82F6), Color(0xFF8B5CF6), Color(0xFFEC4899), Color(0xFF6B7280),
];

const _sunsetPalette = [
  Color(0xFFF97316), Color(0xFFEF4444), Color(0xFFEC4899),
  Color(0xFFF59E0B), Color(0xFFD97706), Color(0xFFB45309),
  Color(0xFF7C3AED), Color(0xFF5B5BD6), Color(0xFF059669), Color(0xFF94A3B8),
];

const _oceanPalette = [
  Color(0xFF0EA5E9), Color(0xFF06B6D4), Color(0xFF0284C7),
  Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFF10B981),
  Color(0xFF3B82F6), Color(0xFF14B8A6), Color(0xFF38BDF8), Color(0xFF64748B),
];

const _rosePalette = [
  Color(0xFFE11D48), Color(0xFFEC4899), Color(0xFFF43F5E),
  Color(0xFFF97316), Color(0xFFF59E0B), Color(0xFFD946EF),
  Color(0xFFA855F7), Color(0xFF7C3AED), Color(0xFF5B5BD6), Color(0xFF94A3B8),
];

const _violetPalette = [
  Color(0xFF7C3AED), Color(0xFF6D28D9), Color(0xFF5B21B6),
  Color(0xFF4F46E5), Color(0xFF6366F1), Color(0xFF8B5CF6),
  Color(0xFFA78BFA), Color(0xFF0EA5E9), Color(0xFFEC4899), Color(0xFF374151),
];

// ── 테마 데이터 모델 ─────────────────────────────────────
class AppThemeData {
  final String id;
  final String name;
  final Color seedColor;
  final List<Color> palette;
  final bool isLocked;

  const AppThemeData({
    required this.id,
    required this.name,
    required this.seedColor,
    required this.palette,
    this.isLocked = false,
  });

  ThemeData buildTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
      contrastLevel: 0.1,
    ).copyWith(
      primary: const Color(0xFF00D4FF),
      surface: const Color(0xFF0E1628),
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
    );

    // ── 시스템 기본 폰트 TextTheme ──
    final baseText = ThemeData.dark().textTheme;
    final textTheme = baseText.copyWith(
      displayLarge: baseText.displayLarge?.copyWith(fontWeight: FontWeight.w800),
      displayMedium: baseText.displayMedium?.copyWith(fontWeight: FontWeight.w800),
      displaySmall: baseText.displaySmall?.copyWith(fontWeight: FontWeight.w700),
      headlineLarge: baseText.headlineLarge?.copyWith(fontWeight: FontWeight.w800),
      headlineMedium: baseText.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
      headlineSmall: baseText.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
      titleLarge: baseText.titleLarge?.copyWith(fontWeight: FontWeight.w800),
      titleMedium: baseText.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      titleSmall: baseText.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      bodyLarge: baseText.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      bodyMedium: baseText.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
      bodySmall: baseText.bodySmall?.copyWith(fontWeight: FontWeight.w500),
      labelLarge: baseText.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      labelMedium: baseText.labelMedium?.copyWith(fontWeight: FontWeight.w600),
      labelSmall: baseText.labelSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      textTheme: textTheme,
      scaffoldBackgroundColor: const Color(0xFF070B14),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFF0A1020),
        foregroundColor: AppColors.textPrimary,
        titleTextStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
        shape: const Border(
          bottom: BorderSide(
            color: Color(0x1400D4FF),
            width: 1,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF0A1020),
        selectedItemColor: Color(0xFF00D4FF),
        unselectedItemColor: Color(0x38FFFFFF),
        elevation: 0,
      ),
      // Icon button tap states
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          highlightColor: const Color(0xFF00D4FF).withValues(alpha: 0.15),
          hoverColor: const Color(0xFF00D4FF).withValues(alpha: 0.08),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surfaceFill,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.cardRadius),
          side: BorderSide(color: AppColors.surfaceBorder),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, AppDimens.buttonHeight),
          backgroundColor: const Color(0xFF00D4FF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, AppDimens.buttonHeight),
          foregroundColor: AppColors.textPrimary,
          side: BorderSide(color: AppColors.surfaceBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFF00D4FF),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.cardRadius),
          borderSide: BorderSide(color: AppColors.surfaceBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.cardRadius),
          borderSide: BorderSide(color: AppColors.surfaceBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.cardRadius),
          borderSide: const BorderSide(color: Color(0xFF00D4FF), width: 1.5),
        ),
        filled: true,
        fillColor: AppColors.surfaceFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        minVerticalPadding: 12,
      ),
      dividerTheme: DividerThemeData(
        space: 1,
        color: AppColors.surfaceBorder,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// ── 테마 목록 ─────────────────────────────────────────────
class AppThemes {
  AppThemes._();

  static const List<AppThemeData> all = [
    AppThemeData(
      id: 'indigo',
      name: '인디고',
      seedColor: Color(0xFF5B5BD6),
      palette: _indigoPalette,
    ),
    AppThemeData(
      id: 'emerald',
      name: '에메랄드',
      seedColor: Color(0xFF059669),
      palette: _emeraldPalette,
    ),
    AppThemeData(
      id: 'sunset',
      name: '선셋',
      seedColor: Color(0xFFF97316),
      palette: _sunsetPalette,
      isLocked: true,
    ),
    AppThemeData(
      id: 'ocean',
      name: '오션',
      seedColor: Color(0xFF0EA5E9),
      palette: _oceanPalette,
      isLocked: true,
    ),
    AppThemeData(
      id: 'rose',
      name: '로즈',
      seedColor: Color(0xFFE11D48),
      palette: _rosePalette,
      isLocked: true,
    ),
    AppThemeData(
      id: 'violet',
      name: '바이올렛',
      seedColor: Color(0xFF7C3AED),
      palette: _violetPalette,
      isLocked: true,
    ),
  ];

  static AppThemeData findById(String id) =>
      all.firstWhere((t) => t.id == id, orElse: () => all.first);
}
