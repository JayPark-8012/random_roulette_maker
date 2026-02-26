import 'package:flutter/material.dart';

/// 디자인 토큰 — 앱 전체에서 참조하는 컬러·수치 상수
class AppColors {
  AppColors._();

  // ── Primary (3-stage depth) ──
  static const primaryDeep = Color(0xFF5B3FD4);
  static const primary = Color(0xFF7C5CFC);
  static const primaryLight = Color(0xFFC084FC);
  static final primaryGlow = Color(0x407C5CFC);

  // ── Primary Gradient (135°, 3-color) ──
  static const primaryGradient = LinearGradient(
    begin: Alignment(-1, -1),
    end: Alignment(1, 1),
    colors: [primaryDeep, primary, primaryLight],
  );

  // ── Background ──
  static const background = Color(0xFF060B18);

  // ── Surface (Glass Card) ──
  static final surfaceFill = Colors.white.withValues(alpha: 0.07);
  static final surfaceBorder = Colors.white.withValues(alpha: 0.08);

  // ── Text ──
  static const textPrimary = Colors.white;
  static final textSecondary = Colors.white.withValues(alpha: 0.55);

  // ── Gold ──
  static const gold = Color(0xFFFFB800);
  static const goldDark = Color(0xFFFF8C00);
  static const goldGradient = LinearGradient(
    begin: Alignment(-1, -1),
    end: Alignment(1, 1),
    colors: [gold, goldDark],
  );
}

class AppDimens {
  AppDimens._();

  // ── 모서리 ──
  static const cardRadius = 16.0;
  static const buttonRadius = 14.0;

  // ── 크기 ──
  static const buttonHeight = 56.0;

  // ── 여백 ──
  static const padding = 16.0;
}

class AppShadows {
  AppShadows._();

  // ── 카드 그림자 ──
  static final card = BoxShadow(
    color: Colors.black.withValues(alpha: 0.30),
    blurRadius: 32,
    offset: const Offset(0, 8),
  );

  // ── Primary 버튼 글로우 ──
  static final primaryGlow = BoxShadow(
    color: AppColors.primary.withValues(alpha: 0.45),
    blurRadius: 24,
    offset: const Offset(0, 8),
  );
}
