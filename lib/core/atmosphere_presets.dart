import 'dart:math';
import 'package:flutter/material.dart';

/// Atmosphere 배경 프리셋
///
/// 앱 전체 배경 분위기를 결정하는 프리셋.
/// 다크 베이스 위에 그래디언트/패턴으로 개성 표현.
class AtmospherePreset {
  final String id;
  final String name;
  final Gradient? gradient;
  final Color solidColor;
  final Color surfaceColor;
  final Color overlayColor;
  final bool isLocked;
  final bool hasPattern;

  const AtmospherePreset({
    required this.id,
    required this.name,
    this.gradient,
    required this.solidColor,
    required this.surfaceColor,
    required this.overlayColor,
    this.isLocked = false,
    this.hasPattern = false,
  });
}

// ── 10개 프리셋 ──────────────────────────────────────────

const kAtmospherePresets = <AtmospherePreset>[
  // ── Free ──
  AtmospherePreset(
    id: 'deep_space',
    name: 'Deep Space',
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF1A2350), Color(0xFF0F1530)],
    ),
    solidColor: Color(0xFF1A2350),
    surfaceColor: Color(0x14FFFFFF),
    overlayColor: Color(0xE01A2350),
  ),
  AtmospherePreset(
    id: 'charcoal',
    name: 'Charcoal',
    solidColor: Color(0xFF2A2A42),
    surfaceColor: Color(0x14FFFFFF),
    overlayColor: Color(0xE02A2A42),
  ),
  // ── Premium ──
  AtmospherePreset(
    id: 'aurora',
    name: 'Aurora',
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF381468), Color(0xFF10605A), Color(0xFF582D70)],
      stops: [0.0, 0.5, 1.0],
    ),
    solidColor: Color(0xFF381468),
    surfaceColor: Color(0x14FFFFFF),
    overlayColor: Color(0xE0381468),
    isLocked: true,
  ),
  AtmospherePreset(
    id: 'sunset_glow',
    name: 'Sunset Glow',
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF5C3520), Color(0xFF321855)],
    ),
    solidColor: Color(0xFF5C3520),
    surfaceColor: Color(0x14FFFFFF),
    overlayColor: Color(0xE05C3520),
    isLocked: true,
  ),
  AtmospherePreset(
    id: 'ocean_depth',
    name: 'Ocean Depth',
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF122E55), Color(0xFF1A5060)],
    ),
    solidColor: Color(0xFF122E55),
    surfaceColor: Color(0x14FFFFFF),
    overlayColor: Color(0xE0122E55),
    isLocked: true,
  ),
  AtmospherePreset(
    id: 'neon_city',
    name: 'Neon City',
    gradient: RadialGradient(
      center: Alignment.bottomLeft,
      radius: 1.8,
      colors: [
        Color(0xFF401870),
        Color(0xFF1E1E38),
        Color(0xFF182855),
      ],
      stops: [0.0, 0.5, 1.0],
    ),
    solidColor: Color(0xFF1E1E38),
    surfaceColor: Color(0x14FFFFFF),
    overlayColor: Color(0xE01E1E38),
    isLocked: true,
  ),
  AtmospherePreset(
    id: 'forest_night',
    name: 'Forest Night',
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF1E4528), Color(0xFF141E22)],
    ),
    solidColor: Color(0xFF1E4528),
    surfaceColor: Color(0x14FFFFFF),
    overlayColor: Color(0xE01E4528),
    isLocked: true,
  ),
  AtmospherePreset(
    id: 'rose_gold',
    name: 'Rose Gold',
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF553040), Color(0xFF50452A)],
    ),
    solidColor: Color(0xFF553040),
    surfaceColor: Color(0x14FFFFFF),
    overlayColor: Color(0xE0553040),
    isLocked: true,
  ),
  AtmospherePreset(
    id: 'starfield',
    name: 'Starfield',
    solidColor: Color(0xFF101825),
    surfaceColor: Color(0x14FFFFFF),
    overlayColor: Color(0xE0101825),
    isLocked: true,
    hasPattern: true,
  ),
  AtmospherePreset(
    id: 'lava',
    name: 'Lava',
    gradient: RadialGradient(
      center: Alignment.center,
      radius: 1.2,
      colors: [Color(0xFF5C1A15), Color(0xFF553012)],
    ),
    solidColor: Color(0xFF5C1A15),
    surfaceColor: Color(0x14FFFFFF),
    overlayColor: Color(0xE05C1A15),
    isLocked: true,
  ),
];

/// ID로 Atmosphere 프리셋 검색 (없으면 deep_space 반환)
AtmospherePreset findAtmosphereById(String id) =>
    kAtmospherePresets.firstWhere(
      (a) => a.id == id,
      orElse: () => kAtmospherePresets.first,
    );

// ── Starfield 패턴 페인터 ──────────────────────────────────

class StarfieldPainter extends CustomPainter {
  StarfieldPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42); // 고정 시드 → 매 프레임 동일 패턴
    final paint = Paint()..color = const Color(0x33FFFFFF); // white 20%

    for (int i = 0; i < 80; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = 0.4 + rng.nextDouble() * 0.8;
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(StarfieldPainter old) => false;
}
