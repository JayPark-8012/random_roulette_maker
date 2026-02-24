import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Dark mode: deep purple-black / Light mode: clean near-white
    final Color bgColor =
        isDark ? const Color(0xFF0D0818) : const Color(0xFFFAFAFA);

    return Container(
      color: bgColor,
      child: Stack(
        children: [
          if (isDark) ...[
            // ── 보케 블롭 (dark only) ───────────────────────────
            // blob 1: Primary purple, top-left
            Positioned(
              left: -80,
              top: -60,
              child: _BokehBlob(
                size: 320,
                color: cs.primary.withValues(alpha: 0.20),
              ),
            ),
            // blob 2: Indigo, top-right
            Positioned(
              right: -50,
              top: 60,
              child: _BokehBlob(
                size: 260,
                color: const Color(0xFF4F46E5).withValues(alpha: 0.13),
              ),
            ),
            // blob 3: Cyan, bottom-left
            Positioned(
              left: 10,
              bottom: 120,
              child: _BokehBlob(
                size: 200,
                color: const Color(0xFF06B6D4).withValues(alpha: 0.09),
              ),
            ),
            // blob 4: Pink, bottom-right
            Positioned(
              right: -30,
              bottom: 180,
              child: _BokehBlob(
                size: 230,
                color: const Color(0xFFEC4899).withValues(alpha: 0.07),
              ),
            ),
          ] else ...[
            // ── Light mode: 상단 중앙 radial tint ───────────────
            Positioned(
              top: -MediaQuery.of(context).size.height * 0.2,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.0,
                    colors: [
                      cs.primary.withValues(alpha: 0.05),
                      Colors.transparent,
                    ],
                    stops: const [0.1, 1.0],
                  ),
                ),
              ),
            ),
          ],

          // Content
          child,
        ],
      ),
    );
  }
}

/// 방사형 그라디언트로 부드러운 보케 효과를 만드는 블롭 위젯
class _BokehBlob extends StatelessWidget {
  final double size;
  final Color color;

  const _BokehBlob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }
}
