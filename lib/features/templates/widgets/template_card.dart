import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class TemplateCard extends StatelessWidget {
  final String emoji;
  final String name;
  final String category;
  final List<String> items;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const TemplateCard({
    super.key,
    required this.emoji,
    required this.name,
    required this.category,
    required this.items,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0E1628),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.07),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 미니 룰렛 휠 영역
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1.5,
                        ),
                      ),
                      child: ClipOval(
                        child: CustomPaint(
                          painter: _MiniWheelPainter(items: items),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // 메타 정보 영역
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        emoji,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D4FF).withValues(alpha: 0.1),
                      border: Border.all(
                        color: const Color(0xFF00D4FF).withValues(alpha: 0.25),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF67E8F9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 미니 룰렛 휠 페인터 ──────────────────────────────────────

class _MiniWheelPainter extends CustomPainter {
  final List<String> items;

  const _MiniWheelPainter({required this.items});

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final count = items.length;
    final sectorAngle = 2 * math.pi / count;

    // 섹터 채우기
    final sectorPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < count; i++) {
      sectorPaint.color = kDefaultPalette[i % kDefaultPalette.length];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2 + i * sectorAngle,
        sectorAngle,
        true,
        sectorPaint,
      );
    }

    // 섹터 구분선
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < count; i++) {
      final angle = -math.pi / 2 + i * sectorAngle;
      canvas.drawLine(
        center,
        Offset(
          center.dx + radius * math.cos(angle),
          center.dy + radius * math.sin(angle),
        ),
        linePaint,
      );
    }

    // 외곽 링
    canvas.drawCircle(
      center,
      radius - 1,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.9)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke,
    );

    // 중심 허브
    canvas.drawCircle(
      center,
      radius * 0.12,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_MiniWheelPainter old) => false;
}
