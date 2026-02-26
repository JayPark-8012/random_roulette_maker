import 'package:flutter/material.dart';
import '../atmosphere_presets.dart';
import '../design_tokens.dart';
import '../../features/settings/state/settings_notifier.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SettingsNotifier.instance,
      builder: (context, _) {
        final atmosphere =
            findAtmosphereById(SettingsNotifier.instance.atmosphereId);

        return Stack(
          children: [
            // Layer 0: Atmosphere base (gradient or solid)
            Positioned.fill(
              child: atmosphere.gradient != null
                  ? DecoratedBox(
                      decoration: BoxDecoration(gradient: atmosphere.gradient),
                    )
                  : ColoredBox(color: atmosphere.solidColor),
            ),
            // Layer 1: Purple radial glow (center-left, upper)
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(-0.3, -0.2),
                      radius: 0.8,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.10),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Layer 2: Gold radial glow (bottom-right corner)
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(1.2, 1.3),
                      radius: 0.5,
                      colors: [
                        AppColors.gold.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Optional starfield pattern
            if (atmosphere.hasPattern)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: StarfieldPainter()),
                ),
              ),
            // Child content
            child,
          ],
        );
      },
    );
  }
}
