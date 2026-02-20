import 'package:flutter/material.dart';

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

  ThemeData buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        color: colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        minVerticalPadding: 12,
      ),
      dividerTheme: const DividerThemeData(space: 1),
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
