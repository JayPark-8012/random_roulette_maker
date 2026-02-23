import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Base colors
    final Color bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFA);
    
    // Tint color (Primary with very low opacity)
    // Light: 3-6% range -> 0.04
    // Dark: 4% or less -> 0.03
    final Color tintColor = cs.primary.withValues(alpha: isDark ? 0.03 : 0.04);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
      ),
      child: Stack(
        children: [
          // Radial Gradient Layer
          if (isDark)
            // Dark Mode: Subtle radial glow
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.6), // Slightly above center
                    radius: 1.2,
                    colors: [
                      tintColor,
                      Colors.transparent,
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            )
          else
            // Light Mode: Subtle radial tint from top center
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
                      tintColor,
                      Colors.transparent,
                    ],
                    stops: const [0.1, 1.0],
                  ),
                ),
              ),
            ),
          
          // Content
          child,
        ],
      ),
    );
  }
}
