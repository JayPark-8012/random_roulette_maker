import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return ClipRect(
      child: Stack(
        children: [
          // Layer 1 — 베이스 단색
          Positioned.fill(
            child: const ColoredBox(color: Color(0xFF070B14)),
          ),
          // Layer 2 — 사이언 빛 번짐 (좌상단)
          Positioned(
            top: -80,
            left: -50,
            child: IgnorePointer(
              child: Container(
                width: 260,
                height: 260,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Color(0x1700D4FF), Colors.transparent],
                  ),
                ),
              ),
            ),
          ),
          // Layer 3 — 퍼플 빛 번짐 (우하단)
          Positioned(
            bottom: -70,
            right: -40,
            child: IgnorePointer(
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Color(0x127B61FF), Colors.transparent],
                  ),
                ),
              ),
            ),
          ),
          // Layer 4 — 중앙 미세 글로우
          Positioned(
            top: screenHeight * 0.3,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Color(0x0A00D4FF), Colors.transparent],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Layer 5 — 자식 위젯
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}
