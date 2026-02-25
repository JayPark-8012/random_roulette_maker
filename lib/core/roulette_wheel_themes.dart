import 'package:flutter/material.dart';
import '../domain/roulette_wheel_theme.dart';

// ── 팔레트 정의 ──────────────────────────────────────────

const _classicPalette = [
  Color(0xFFE57373), Color(0xFF64B5F6), Color(0xFF81C784),
  Color(0xFFFFD54F), Color(0xFFBA68C8), Color(0xFF4DB6AC),
  Color(0xFFFF8A65), Color(0xFF90A4AE), Color(0xFFF06292),
  Color(0xFF4FC3F7),
];

const _candyPalette = [
  Color(0xFFFFB3C6), Color(0xFFB5EAD7), Color(0xFFFFC8DD),
  Color(0xFFC7F2A4), Color(0xFFFFDFBA), Color(0xFFBDE0FE),
  Color(0xFFE2BFFF), Color(0xFFFAEDB4), Color(0xFFADE8F4),
  Color(0xFFFFCAC9),
];

const _neonPalette = [
  Color(0xFFFF0080), Color(0xFF00FFFF), Color(0xFF00FF41),
  Color(0xFFFFFF00), Color(0xFFFF6600), Color(0xFF9900FF),
  Color(0xFF00BFFF), Color(0xFFFF1493), Color(0xFF39FF14),
  Color(0xFFFF4500),
];

const _midnightPalette = [
  Color(0xFF4C1D95), Color(0xFF1E3A5F), Color(0xFF14532D),
  Color(0xFF7C2D12), Color(0xFF1E1B4B), Color(0xFF164E63),
  Color(0xFF3B0764), Color(0xFF0C4A6E), Color(0xFF422006),
  Color(0xFF1C1917),
];

const _forestPalette = [
  Color(0xFF2D6A4F), Color(0xFF74C69D), Color(0xFF40916C),
  Color(0xFF95D5B2), Color(0xFF1B4332), Color(0xFF52B788),
  Color(0xFF8B5E3C), Color(0xFFD4A373), Color(0xFF6B8F71),
  Color(0xFFA7C957),
];

const _coralPalette = [
  Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFA07A),
  Color(0xFFFF7F50), Color(0xFFCD5C5C), Color(0xFFF08080),
  Color(0xFFE9967A), Color(0xFFFA8072), Color(0xFFFF4500),
  Color(0xFFFF6347),
];

const _galaxyPalette = [
  Color(0xFF3A0CA3), Color(0xFF7209B7), Color(0xFF560BAD),
  Color(0xFF480CA8), Color(0xFF3F37C9), Color(0xFF4361EE),
  Color(0xFF4CC9F0), Color(0xFF4895EF), Color(0xFF72EFDD),
  Color(0xFF06D6A0),
];

const _goldPalette = [
  Color(0xFFFFD700), Color(0xFFFFC200), Color(0xFFFFB300),
  Color(0xFFE6A817), Color(0xFFCF8914), Color(0xFFB8860B),
  Color(0xFFDEB887), Color(0xFFF0D060), Color(0xFFE8C547),
  Color(0xFFDAA520),
];

// ── 휠 테마 목록 ─────────────────────────────────────────

const List<RouletteWheelTheme> kRouletteWheelThemes = [
  RouletteWheelTheme(
    id: 'classic',
    name: '클래식',
    palette: _classicPalette,
    style: WheelStyle.classic,
  ),
  RouletteWheelTheme(
    id: 'candy',
    name: '캔디',
    palette: _candyPalette,
    style: WheelStyle.classic,
  ),
  RouletteWheelTheme(
    id: 'neon',
    name: '네온',
    palette: _neonPalette,
    style: WheelStyle.neonGlow,
    isLocked: true,
  ),
  RouletteWheelTheme(
    id: 'midnight',
    name: '미드나잇',
    palette: _midnightPalette,
    style: WheelStyle.gradient,
    isLocked: true,
  ),
  RouletteWheelTheme(
    id: 'forest',
    name: '포레스트',
    palette: _forestPalette,
    style: WheelStyle.gradient,
    isLocked: true,
  ),
  RouletteWheelTheme(
    id: 'coral',
    name: '코럴',
    palette: _coralPalette,
    style: WheelStyle.metallic,
    isLocked: true,
  ),
  RouletteWheelTheme(
    id: 'galaxy',
    name: '갤럭시',
    palette: _galaxyPalette,
    style: WheelStyle.crystal,
    isLocked: true,
  ),
  RouletteWheelTheme(
    id: 'gold',
    name: '골드',
    palette: _goldPalette,
    style: WheelStyle.metallic,
    isLocked: true,
  ),
];

RouletteWheelTheme findWheelThemeById(String id) =>
    kRouletteWheelThemes.firstWhere(
      (t) => t.id == id,
      orElse: () => kRouletteWheelThemes.first,
    );
