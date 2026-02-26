import 'package:flutter/material.dart';
import '../atmosphere_presets.dart';
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

        Widget bg;
        if (atmosphere.gradient != null) {
          bg = DecoratedBox(
            decoration: BoxDecoration(gradient: atmosphere.gradient),
            child: child,
          );
        } else {
          bg = ColoredBox(color: atmosphere.solidColor, child: child);
        }

        if (atmosphere.hasPattern) {
          return Stack(
            children: [
              bg,
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: StarfieldPainter()),
                ),
              ),
            ],
          );
        }

        return bg;
      },
    );
  }
}
