import 'package:flutter/material.dart';

/// 룰렛 아이콘 — 원 + 중앙 점 + 바늘선
class RouletteIcon extends StatelessWidget {
  final double size;
  final Color color;
  const RouletteIcon({super.key, this.size = 24, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _RoulettePainter(color)),
    );
  }
}

class _RoulettePainter extends CustomPainter {
  final Color color;
  _RoulettePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8 * s
      ..strokeCap = StrokeCap.round;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // 외곽 원
    canvas.drawCircle(Offset(12 * s, 12 * s), 9 * s, stroke);
    // 중앙 점
    canvas.drawCircle(Offset(12 * s, 12 * s), 3 * s, fill);
    // 바늘 선
    canvas.drawLine(Offset(12 * s, 3 * s), Offset(12 * s, 12 * s), stroke);
    // 보조 선
    final sub = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(19.5 * s, 7.5 * s), Offset(12 * s, 12 * s), sub);
  }

  @override
  bool shouldRepaint(_RoulettePainter old) => old.color != color;
}

/// 코인 아이콘 — 원 + 십자 홈 + 중앙 점
class CoinIcon extends StatelessWidget {
  final double size;
  final Color color;
  const CoinIcon({super.key, this.size = 24, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _CoinPainter(color)),
    );
  }
}

class _CoinPainter extends CustomPainter {
  final Color color;
  _CoinPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8 * s
      ..strokeCap = StrokeCap.round;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // 외곽 원
    canvas.drawCircle(Offset(12 * s, 12 * s), 8 * s, stroke);
    // 십자 홈 (상하좌우)
    canvas.drawLine(Offset(12 * s, 4 * s), Offset(12 * s, 8 * s), stroke);
    canvas.drawLine(Offset(12 * s, 16 * s), Offset(12 * s, 20 * s), stroke);
    canvas.drawLine(Offset(4 * s, 12 * s), Offset(8 * s, 12 * s), stroke);
    canvas.drawLine(Offset(16 * s, 12 * s), Offset(20 * s, 12 * s), stroke);
    // 중앙 점
    canvas.drawCircle(Offset(12 * s, 12 * s), 2.5 * s, fill);
  }

  @override
  bool shouldRepaint(_CoinPainter old) => old.color != color;
}

/// 주사위 아이콘 — 둥근 사각형 + 4개 점
class DiceIcon extends StatelessWidget {
  final double size;
  final Color color;
  const DiceIcon({super.key, this.size = 24, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _DicePainter(color)),
    );
  }
}

class _DicePainter extends CustomPainter {
  final Color color;
  _DicePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8 * s;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // 둥근 사각형
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(4 * s, 4 * s, 16 * s, 16 * s),
        Radius.circular(4 * s),
      ),
      stroke,
    );
    // 점 4개
    for (final p in [
      Offset(9 * s, 9 * s),
      Offset(15 * s, 9 * s),
      Offset(9 * s, 15 * s),
      Offset(15 * s, 15 * s),
    ]) {
      canvas.drawCircle(p, 1.5 * s, fill);
    }
  }

  @override
  bool shouldRepaint(_DicePainter old) => old.color != color;
}

/// 숫자 아이콘 — # 문자
class NumberIcon extends StatelessWidget {
  final double size;
  final Color color;
  const NumberIcon({super.key, this.size = 24, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _NumberPainter(color)),
    );
  }
}

class _NumberPainter extends CustomPainter {
  final Color color;
  _NumberPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 * s
      ..strokeCap = StrokeCap.round;

    // # 형태: 세로선 2개 + 가로선 2개, 약간 기울임
    // 세로선 (살짝 기울임)
    canvas.drawLine(Offset(9.5 * s, 5 * s), Offset(8.5 * s, 19 * s), stroke);
    canvas.drawLine(Offset(15.5 * s, 5 * s), Offset(14.5 * s, 19 * s), stroke);
    // 가로선
    canvas.drawLine(Offset(5 * s, 10 * s), Offset(19 * s, 10 * s), stroke);
    canvas.drawLine(Offset(5 * s, 15 * s), Offset(19 * s, 15 * s), stroke);
  }

  @override
  bool shouldRepaint(_NumberPainter old) => old.color != color;
}

/// 사다리 아이콘 — 세로 기둥 2개 + 가로선 3개
class LadderIcon extends StatelessWidget {
  final double size;
  final Color color;
  const LadderIcon({super.key, this.size = 24, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _LadderPainter(color)),
    );
  }
}

class _LadderPainter extends CustomPainter {
  final Color color;
  _LadderPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    final pillar = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 * s
      ..strokeCap = StrokeCap.round;
    final rung = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8 * s
      ..strokeCap = StrokeCap.round;

    // 세로 기둥
    canvas.drawLine(Offset(7 * s, 3 * s), Offset(7 * s, 21 * s), pillar);
    canvas.drawLine(Offset(17 * s, 3 * s), Offset(17 * s, 21 * s), pillar);
    // 가로선
    canvas.drawLine(Offset(7 * s, 8 * s), Offset(17 * s, 8 * s), rung);
    canvas.drawLine(Offset(7 * s, 13 * s), Offset(17 * s, 13 * s), rung);
    canvas.drawLine(Offset(7 * s, 18 * s), Offset(17 * s, 18 * s), rung);
  }

  @override
  bool shouldRepaint(_LadderPainter old) => old.color != color;
}
