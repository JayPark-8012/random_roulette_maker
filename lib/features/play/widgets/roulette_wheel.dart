import 'dart:math';
import 'package:flutter/material.dart';
import '../../../domain/item.dart';
import '../../../domain/roulette_wheel_theme.dart';

/// 룰렛 휠 CustomPainter
class RouletteWheelPainter extends CustomPainter {
  final List<Item> items;
  final double rotationAngle;
  final Color? primaryColor; // 테마 컬러 → 베젤 glow에 사용
  final RouletteWheelTheme? wheelTheme; // null이면 item.color 그대로 사용

  const RouletteWheelPainter({
    required this.items,
    this.rotationAngle = 0,
    this.primaryColor,
    this.wheelTheme,
  });

  Color _sectorColor(int index) {
    if (wheelTheme != null) {
      return wheelTheme!.palette[index % wheelTheme!.palette.length];
    }
    return items[index].color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 18;
    final totalWeight = items.fold<int>(0, (s, i) => s + i.weight);

    // ① 베젤 (회전 비적용, 항상 정적)
    _drawBezel(canvas, center, radius);

    // ② 섹터 + 텍스트 (회전 적용)
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationAngle);

    double currentAngle = -pi / 2;
    for (int i = 0; i < items.length; i++) {
      final sweepAngle = 2 * pi * items[i].weight / totalWeight;
      final startAngle = currentAngle;
      final baseColor = _sectorColor(i);

      // 스타일별 섹터 렌더링
      _drawSector(canvas, baseColor, i, startAngle, sweepAngle, radius);

      _drawSectorText(canvas, items[i].label, startAngle, sweepAngle, radius);
      currentAngle += sweepAngle;
    }

    // ③ 중앙 허브 (메탈릭 멀티레이어)
    _drawHub(canvas, radius);

    canvas.restore();
  }

  // ── 스타일별 섹터 렌더링 ─────────────────────────────────────────

  void _drawSector(
    Canvas canvas,
    Color baseColor,
    int index,
    double startAngle,
    double sweepAngle,
    double radius,
  ) {
    final style = wheelTheme?.style ?? WheelStyle.classic;
    final rect = Rect.fromCircle(center: Offset.zero, radius: radius);

    switch (style) {
      case WheelStyle.classic:
        _drawClassicSector(canvas, baseColor, rect, startAngle, sweepAngle);
      case WheelStyle.gradient:
        _drawGradientSector(
            canvas, baseColor, rect, startAngle, sweepAngle, radius);
      case WheelStyle.neonGlow:
        _drawNeonSector(canvas, baseColor, rect, startAngle, sweepAngle);
      case WheelStyle.metallic:
        _drawMetallicSector(canvas, baseColor, rect, startAngle, sweepAngle);
      case WheelStyle.crystal:
        _drawCrystalSector(
            canvas, baseColor, rect, startAngle, sweepAngle, radius);
    }
  }

  // Classic: 단색 + 흰 테두리
  void _drawClassicSector(Canvas canvas, Color color, Rect rect,
      double startAngle, double sweepAngle) {
    canvas.drawArc(rect, startAngle, sweepAngle, true,
        Paint()..color = color..style = PaintingStyle.fill);
    canvas.drawArc(rect, startAngle, sweepAngle, true,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
  }

  // Gradient: 중심 밝음 → 외곽 어둠 방사형 그라디언트
  void _drawGradientSector(Canvas canvas, Color color, Rect rect,
      double startAngle, double sweepAngle, double radius) {
    final lighter = Color.lerp(color, Colors.white, 0.45)!;
    final darker = Color.lerp(color, Colors.black, 0.30)!;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [lighter, color, darker],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));
    canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
    canvas.drawArc(rect, startAngle, sweepAngle, true,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2);
  }

  // NeonGlow: 단색 섹터 + 네온 경계선 발광
  void _drawNeonSector(Canvas canvas, Color color, Rect rect,
      double startAngle, double sweepAngle) {
    // 기본 채우기 (약간 어둡게)
    canvas.drawArc(rect, startAngle, sweepAngle, true,
        Paint()..color = Color.lerp(color, Colors.black, 0.20)!..style = PaintingStyle.fill);
    // 글로우 스트로크 (MaskFilter blur)
    canvas.drawArc(rect, startAngle, sweepAngle, true,
        Paint()
          ..color = color.withValues(alpha: 0.85)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
    // 흰 내부선 (선명도 강조)
    canvas.drawArc(rect, startAngle, sweepAngle, true,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8);
  }

  // Metallic: 섹터 위에 45도 방향 하이라이트 스트라이프
  void _drawMetallicSector(Canvas canvas, Color color, Rect rect,
      double startAngle, double sweepAngle) {
    canvas.drawArc(rect, startAngle, sweepAngle, true,
        Paint()..color = color..style = PaintingStyle.fill);
    // 하이라이트 (상단 밝은 반사)
    canvas.drawArc(rect, startAngle, sweepAngle, true,
        Paint()
          ..shader = LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.35),
              Colors.white.withValues(alpha: 0.0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(rect));
    canvas.drawArc(rect, startAngle, sweepAngle, true,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
  }

  // Crystal: 단색 + 섹터 중앙에 작은 마름모 별 장식
  void _drawCrystalSector(Canvas canvas, Color color, Rect rect,
      double startAngle, double sweepAngle, double radius) {
    canvas.drawArc(rect, startAngle, sweepAngle, true,
        Paint()..color = color..style = PaintingStyle.fill);
    // 반투명 오버레이 (보석 투명감)
    canvas.drawArc(rect, startAngle, sweepAngle, true,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.15)
          ..style = PaintingStyle.fill);
    canvas.drawArc(rect, startAngle, sweepAngle, true,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.60)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
    // 섹터 중앙에 다이아몬드 별 스파클
    final midAngle = startAngle + sweepAngle / 2;
    final sparkR = radius * 0.55;
    final cx = cos(midAngle) * sparkR;
    final cy = sin(midAngle) * sparkR;
    _drawSparkle(canvas, Offset(cx, cy), radius * 0.045);
  }

  void _drawSparkle(Canvas canvas, Offset center, double size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.80)
      ..style = PaintingStyle.fill;
    // 십자형 4개 점 다이아몬드
    for (int k = 0; k < 4; k++) {
      final a = k * pi / 2;
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(center.dx + cos(a) * size * 2.2, center.dy + sin(a) * size * 2.2)
        ..lineTo(center.dx + cos(a + pi / 2) * size * 0.6,
            center.dy + sin(a + pi / 2) * size * 0.6)
        ..close();
      canvas.drawPath(path, paint);
      final sym = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(center.dx + cos(a) * size * 2.2, center.dy + sin(a) * size * 2.2)
        ..lineTo(center.dx + cos(a - pi / 2) * size * 0.6,
            center.dy + sin(a - pi / 2) * size * 0.6)
        ..close();
      canvas.drawPath(sym, paint);
    }
  }

  // ── 베젤 (메탈릭 링 + 글로우) ─────────────────────────────────

  void _drawBezel(Canvas canvas, Offset center, double radius) {
    // 레이어 1: 심층 다크 아우터 베이스
    canvas.drawCircle(
      center,
      radius + 15,
      Paint()
        ..color = const Color(0xFF141428)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 22,
    );

    // 레이어 2: 스틸 블루-그레이 메탈릭 링
    canvas.drawCircle(
      center,
      radius + 12,
      Paint()
        ..color = const Color(0xFF2E2E48)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14,
    );

    // 레이어 3: 상단-좌측 하이라이트 아크 (광택 느낌)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + 12),
      -pi * 1.15,
      pi * 0.90,
      false,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.14)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );

    // 레이어 4: 하단-우측 섀도우 아크 (입체감)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + 12),
      -pi * 0.15,
      pi * 0.90,
      false,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );

    // 레이어 5: 테마 컬러 내부 글로우 링
    canvas.drawCircle(
      center,
      radius + 4,
      Paint()
        ..color =
            (primaryColor ?? const Color(0xFF7C3AED)).withValues(alpha: 0.40)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );

    // 레이어 6: 내부 화이트 림 (섹터 경계선 역할)
    canvas.drawCircle(
      center,
      radius + 1.5,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  // ── 중앙 허브 (좌표계: canvas.translate 후 Offset.zero = 중심) ─────

  void _drawHub(Canvas canvas, double radius) {
    // 바깥 다크 링
    canvas.drawCircle(
      Offset.zero,
      radius * 0.17,
      Paint()..color = const Color(0xFF1E1E32),
    );
    // 메탈릭 실버 링
    canvas.drawCircle(
      Offset.zero,
      radius * 0.13,
      Paint()..color = const Color(0xFFC0C0D0),
    );
    // 내부 화이트
    canvas.drawCircle(
      Offset.zero,
      radius * 0.09,
      Paint()..color = Colors.white,
    );
    // 골드 중앙 핀
    canvas.drawCircle(
      Offset.zero,
      radius * 0.04,
      Paint()..color = const Color(0xFFFFD700),
    );
    // 하이라이트 스팟 (상단-좌측)
    canvas.drawCircle(
      Offset(-radius * 0.03, -radius * 0.05),
      radius * 0.025,
      Paint()..color = Colors.white.withValues(alpha: 0.80),
    );
  }

  // ── 섹터 텍스트 ─────────────────────────────────────────────────

  void _drawSectorText(
    Canvas canvas,
    String text,
    double startAngle,
    double sweepAngle,
    double radius,
  ) {
    final midAngle = startAngle + sweepAngle / 2;
    final textRadius = radius * 0.62;
    final textX = cos(midAngle) * textRadius;
    final textY = sin(midAngle) * textRadius;

    final maxWidth = (radius * sweepAngle).clamp(40.0, 150.0);
    final label = text.length > 8 ? '${text.substring(0, 7)}…' : text;

    // 기본 폰트 크기 → 넘치면 자동 축소
    var fontSize = (18.0 - items.length * 0.2).clamp(10.0, 18.0);

    TextPainter textPainter;
    for (;;) {
      textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            shadows: const [
              Shadow(color: Colors.black54, blurRadius: 2, offset: Offset(1, 1)),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout(maxWidth: maxWidth);
      if (!textPainter.didExceedMaxLines && textPainter.width <= maxWidth) break;
      fontSize -= 1;
      if (fontSize < 8) break;
    }

    canvas.save();
    canvas.translate(textX, textY);
    canvas.rotate(midAngle + pi / 2);
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(RouletteWheelPainter old) =>
      old.rotationAngle != rotationAngle ||
      old.items != items ||
      old.primaryColor != primaryColor ||
      old.wheelTheme?.id != wheelTheme?.id;
}

// ── 포인터 (12시, 휠 상단에 고정) ────────────────────────────────

class RoulettePointer extends StatelessWidget {
  const RoulettePointer({super.key});

  @override
  Widget build(BuildContext context) {
    // 20% 확대: 30×48 → 36×58 + 골드 halo
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        // 포인터 아래쪽 골드 빛 번짐 halo
        Positioned(
          top: 30,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFB800).withValues(alpha: 0.35),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),
        CustomPaint(
          size: const Size(36, 58),
          painter: _PointerPainter(
            color: const Color(0xFFFFBF00),
            shadowColor: const Color(0xFFFFB800),
          ),
        ),
      ],
    );
  }
}

class _PointerPainter extends CustomPainter {
  final Color color;
  final Color shadowColor;

  const _PointerPainter({required this.color, required this.shadowColor});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 테어드롭 패스: 상단 둥근 부분 → 하단 첨점
    final path = Path()
      ..moveTo(w / 2, h) // 아래 첨점
      ..cubicTo(0, h * 0.55, 0, 0, w / 2, 0) // 좌측 곡선
      ..cubicTo(w, 0, w, h * 0.55, w / 2, h) // 우측 곡선
      ..close();

    // 골드 드롭 섀도우 — 강화 (#FFB800 70%, blur 12)
    canvas.drawPath(
      path.shift(const Offset(0, 5)),
      Paint()
        ..color = shadowColor.withValues(alpha: 0.70)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );

    // 본체 — 골드 그라데이션 (상→하: 밝은 골드→짙은 골드)
    final bodyRect = Rect.fromLTWH(0, 0, w, h);
    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFD54F), Color(0xFFFFB800), Color(0xFFFF8C00)],
          stops: [0.0, 0.5, 1.0],
        ).createShader(bodyRect),
    );

    // 외곽 어두운 테두리 (입체감)
    canvas.drawPath(
      path,
      Paint()
        ..color = Color.lerp(color, Colors.black, 0.30) ?? color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // 내부 하이라이트 (상단 좌측 — 광택)
    final highlight = Path()
      ..moveTo(w * 0.50, h * 0.04)
      ..cubicTo(w * 0.18, h * 0.12, w * 0.18, h * 0.42, w * 0.36, h * 0.52)
      ..cubicTo(w * 0.20, h * 0.38, w * 0.20, h * 0.10, w * 0.50, h * 0.04)
      ..close();
    canvas.drawPath(
      highlight,
      Paint()..color = Colors.white.withValues(alpha: 0.30),
    );

    // 중앙 하이라이트 원
    canvas.drawCircle(
      Offset(w / 2, h * 0.22),
      w * 0.16,
      Paint()..color = Colors.white.withValues(alpha: 0.55),
    );
  }

  @override
  bool shouldRepaint(_PointerPainter old) =>
      old.color != color || old.shadowColor != shadowColor;
}
