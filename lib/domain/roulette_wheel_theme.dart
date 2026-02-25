import 'package:flutter/material.dart';

/// 룰렛 휠 렌더링 스타일
enum WheelStyle {
  /// 단색 섹터 (기본)
  classic,

  /// 섹터별 방사형 그라디언트 (중심 밝음 → 외곽 어둠)
  gradient,

  /// 네온 발광 경계선
  neonGlow,

  /// 내부 별 모양 인셋 장식 (크리스탈 느낌)
  crystal,

  /// 섹터 안쪽 메탈릭 하이라이트 스트라이프
  metallic,
}

/// 룰렛 휠 테마 데이터
class RouletteWheelTheme {
  final String id;
  final String name;
  final List<Color> palette;
  final WheelStyle style;

  /// true = 프리미엄 전용
  final bool isLocked;

  const RouletteWheelTheme({
    required this.id,
    required this.name,
    required this.palette,
    required this.style,
    this.isLocked = false,
  });
}
