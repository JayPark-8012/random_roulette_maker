import 'dart:math';
import 'package:flutter/material.dart';
import '../../../domain/item.dart';

/// 룰렛 휠 CustomPainter (Phase 1: 정적 그리기 뼈대)
/// Phase 2에서 AnimationController 연결 + 회전 구현
class RouletteWheelPainter extends CustomPainter {
  final List<Item> items;
  final double rotationAngle; // 라디안, 0 = 시작 위치

  const RouletteWheelPainter({
    required this.items,
    this.rotationAngle = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 8;
    final sweepAngle = 2 * pi / items.length;

    // 중심 이동 + 회전 적용
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationAngle);

    for (int i = 0; i < items.length; i++) {
      final startAngle = i * sweepAngle - pi / 2; // 12시 방향이 시작
      final paint = Paint()
        ..color = items[i].color
        ..style = PaintingStyle.fill;

      // 섹터 그리기
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // 섹터 테두리
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: radius),
        startAngle,
        sweepAngle,
        true,
        borderPaint,
      );

      // 텍스트 그리기
      _drawSectorText(canvas, items[i].label, startAngle, sweepAngle, radius);
    }

    // 중앙 원
    canvas.drawCircle(
      Offset.zero,
      radius * 0.12,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset.zero,
      radius * 0.12,
      Paint()
        ..color = Colors.black12
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    canvas.restore();
  }

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
      old.rotationAngle != rotationAngle || old.items != items;
}

/// 포인터 삼각형 (고정, 12시 방향)
class RoulettePointer extends StatelessWidget {
  const RoulettePointer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(30, 40),
      painter: _PointerPainter(
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

class _PointerPainter extends CustomPainter {
  final Color color;
  const _PointerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(_PointerPainter old) => old.color != color;
}
