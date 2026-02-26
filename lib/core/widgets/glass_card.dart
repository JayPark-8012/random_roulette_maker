import 'package:flutter/material.dart';
import '../design_tokens.dart';

/// 글래스모피즘 카드 — 반투명 배경 + 테두리 + 퍼플 오버레이
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry? borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppDimens.padding),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(AppDimens.cardRadius);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceFill,
        borderRadius: radius,
        border: Border.all(color: AppColors.surfaceBorder, width: 1),
        boxShadow: [AppShadows.card],
      ),
      child: ClipRRect(
        borderRadius: radius as BorderRadius,
        child: Stack(
          children: [
            // 상단 좌측 퍼플 5% 그라데이션 오버레이
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 120,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // 1px 상단 하이라이트 (white 20% → 0%)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.20),
                      Colors.white.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            Padding(padding: padding, child: child),
          ],
        ),
      ),
    );
  }
}
