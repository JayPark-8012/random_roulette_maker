import 'dart:math';
import 'package:flutter/material.dart';
import '../../../domain/item.dart';

/// 룰렛 휠 CustomPainter
class RouletteWheelPainter extends CustomPainter {
  final List<Item> items;
  final double rotationAngle;
  final Color? primaryColor; // 테마 컬러 → 베젤 glow에 사용

  const RouletteWheelPainter({
    required this.items,
    this.rotationAngle = 0,
    this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    // -18: 외곽 베젤(~18px) 공간 확보
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

      // 섹터 채우기
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: radius),
        startAngle,
        sweepAngle,
        true,
        Paint()
          ..color = items[i].color
          ..style = PaintingStyle.fill,
      );

      // 섹터 테두리
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: radius),
        startAngle,
        sweepAngle,
        true,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );

      _drawSectorText(canvas, items[i].label, startAngle, sweepAngle, radius);
      currentAngle += sweepAngle;
    }

    // ③ 중앙 허브 (메탈릭 멀티레이어)
    _drawHub(canvas, radius);

    canvas.restore();
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
        ..color = (primaryColor ?? const Color(0xFF7C3AED)).withValues(alpha: 0.40)
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

    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.white,
          fontSize: (18.0 - items.length * 0.2).clamp(10.0, 18.0),
          fontWeight: FontWeight.bold,
          shadows: const [
            Shadow(color: Colors.black54, blurRadius: 2, offset: Offset(1, 1)),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(maxWidth: maxWidth);

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
      old.primaryColor != primaryColor;
}

// ── 포인터 (12시, 휠 상단에 고정) ────────────────────────────────

class RoulettePointer extends StatelessWidget {
  const RoulettePointer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      // 22×36 → 30×48 (더 크고 눈에 띄게)
      size: const Size(30, 48),
      painter: _PointerPainter(
        color: const Color(0xFFFFBF00), // 앰버 골드 — 게임 느낌
        shadowColor: Theme.of(context).colorScheme.shadow,
      ),
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

    // 그림자 (더 강하고 부드럽게)
    canvas.drawPath(
      path.shift(const Offset(0, 3)),
      Paint()
        ..color = shadowColor.withValues(alpha: 0.45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // 본체
    canvas.drawPath(path, Paint()..color = color);

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
