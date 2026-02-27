import 'package:flutter/material.dart';

/// ⚡ Electric Navy Design Tokens
class AppColors {
  AppColors._();

  // ── Background 레이어 ──
  static const bgBase     = Color(0xFF070B14); // 메인 배경
  static const bgElevated = Color(0xFF0A1020); // 헤더/탭바
  static const bgCard     = Color(0xFF0E1628); // 일반 카드
  static const bgHero     = Color(0xFF0F1C30); // 히어로 카드

  // ── 액센트 — 사이언 블루 ──
  static const accent       = Color(0xFF00D4FF); // 메인
  static const accentDeep   = Color(0xFF0284C7); // 딥
  static const accentGlow   = Color(0x2E00D4FF); // 글로우 18%
  static const accentSoft   = Color(0x1400D4FF); // 소프트 8%
  static const accentBorder = Color(0x4000D4FF); // 테두리 25%

  // ── 서브 액센트 — 퍼플 (스핀 결과/강조용) ──
  static const spark     = Color(0xFF7B61FF);
  static const sparkGlow = Color(0x1F7B61FF);

  // ── STOP 버튼용 ──
  static const stopRed  = Color(0xFFFF4466);
  static const stopGlow = Color(0x33FF4466);

  // ── 텍스트 ──
  static const textPrimary   = Color(0xFFFFFFFF);
  static const textSecondary = Color(0x80FFFFFF); // 50%
  static const textTertiary  = Color(0x38FFFFFF); // 22%
  static const textAccent    = Color(0xFF67E8F9); // 사이언 서브텍스트

  // ── 서피스/보더 ──
  static const borderBase   = Color(0x0FFFFFFF); // 6%
  static const borderAccent = Color(0x4000D4FF); // 25%

  // ── 기존 alias 호환 ──
  static const primary      = accent;
  static const primaryDeep  = accentDeep;
  static const primaryGlow  = accentGlow;
  static const primaryLight = Color(0xFF67E8F9);
  static const gold         = Color(0xFFFFB800);
  static const goldGlow     = Color(0x33FFB800);
  static const goldDeep     = Color(0xFFCC8800);

  /// 기존 코드 호환 alias
  static const background  = bgBase;
  static const bgDeep      = Color(0xFF050810);
  static const bgSurface   = bgCard;
  static const goldDark    = goldDeep;
  static const surfaceBg     = Color(0x0DFFFFFF); // 5%
  static const surfaceBorder = borderBase;
  static const surfaceHover  = Color(0x14FFFFFF); // 8%
  static const surfaceFill   = surfaceBg;

  // ── Gradient ──
  static const primaryGradient = LinearGradient(
    begin: Alignment(-1, -1),
    end: Alignment(1, 1),
    colors: [accentDeep, accent, primaryLight],
  );
  static const goldGradient = LinearGradient(
    begin: Alignment(-1, -1),
    end: Alignment(1, 1),
    colors: [gold, goldDeep],
  );
}

class AppDimens {
  AppDimens._();

  // ── 모서리 ──
  static const cardRadius   = 15.0;
  static const buttonRadius = 100.0;
  static const chipRadius   = 100.0;

  // ── 크기 ──
  static const buttonHeight = 56.0;

  // ── 여백 ──
  static const padding = 16.0;
}

class AppShadows {
  AppShadows._();

  // ── 카드 그림자 ──
  static const card = BoxShadow(
    color: Color(0x66000000),
    blurRadius: 24,
    offset: Offset(0, 8),
  );

  // ── 액센트 버튼 글로우 ──
  static const primaryGlow = BoxShadow(
    color: Color(0x5500D4FF),
    blurRadius: 20,
    offset: Offset(0, 8),
  );

  // ── Gold 글로우 ──
  static const goldGlow = BoxShadow(
    color: Color(0x55FFB800),
    blurRadius: 20,
    offset: Offset(0, 8),
  );
}
