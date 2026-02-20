import 'package:flutter/material.dart';

// ── 라우트 이름 ──────────────────────────────────────────
class AppRoutes {
  AppRoutes._();
  static const splash = '/splash';
  static const home = '/home';
  static const editor = '/editor';
  static const play = '/play';
  static const templates = '/templates';
  static const settings = '/settings';
}

// ── 비즈니스 제한 ────────────────────────────────────────
class AppLimits {
  AppLimits._();
  static const int maxRouletteCount = 3;   // 무료 플랜 최대 룰렛 수
  static const int maxHistoryCount = 20;   // 룰렛당 히스토리 최대 개수
  static const int maxItemCount = 50;      // 룰렛당 최대 항목 수
  static const int minItemCount = 2;       // 룰렛당 최소 항목 수
  static const int maxNameLength = 30;     // 룰렛 이름 최대 길이
  static const int maxLabelLength = 20;    // 항목 텍스트 최대 길이
}

// ── SharedPreferences 키 ─────────────────────────────────
class StorageKeys {
  StorageKeys._();
  static const rouletteList = 'roulette_list';
  static const settings = 'settings';
  static const appDataVersion = 'app_data_version';
  static String historyKey(String rouletteId) => 'history_$rouletteId';
}

// ── 기본 색상 팔레트 ─────────────────────────────────────
const List<Color> kDefaultPalette = [
  Color(0xFFE57373), // Red 300
  Color(0xFF64B5F6), // Blue 300
  Color(0xFF81C784), // Green 300
  Color(0xFFFFD54F), // Amber 300
  Color(0xFFBA68C8), // Purple 300
  Color(0xFF4DB6AC), // Teal 300
  Color(0xFFFF8A65), // Deep Orange 300
  Color(0xFF90A4AE), // Blue Grey 300
  Color(0xFFF06292), // Pink 300
  Color(0xFF4FC3F7), // Light Blue 300
];

// ── 애니메이션 상수 ──────────────────────────────────────
class SpinConfig {
  SpinConfig._();
  static const Duration normalDuration = Duration(milliseconds: 4500);
  static const Duration fastDuration = Duration(milliseconds: 2800);
  // 추가 회전 수 범위 (섹터 중앙 도달 전 전체 회전 수)
  static const int minExtraRotations = 3;
  static const int maxExtraRotations = 5;
}
