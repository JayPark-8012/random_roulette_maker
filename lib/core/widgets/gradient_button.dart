import 'package:flutter/material.dart';
import '../design_tokens.dart';

/// 그라데이션 버튼 — Primary 또는 Gold 그라데이션 + 글로우 그림자
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Gradient gradient;
  final BoxShadow? shadow;
  final double height;
  final double? width;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.gradient = AppColors.primaryGradient,
    this.shadow,
    this.height = AppDimens.buttonHeight,
    this.width,
  });

  /// Gold 스타일 팩토리
  const GradientButton.gold({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.shadow,
    this.height = AppDimens.buttonHeight,
    this.width,
  })  : gradient = AppColors.goldGradient;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: enabled ? 1.0 : 0.45,
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
          boxShadow: enabled ? [shadow ?? AppShadows.primaryGlow] : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
          child: Stack(
            children: [
              // 상단 40% 하이라이트 오버레이
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: height * 0.4,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDimens.buttonRadius),
                      topRight: Radius.circular(AppDimens.buttonRadius),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // 하단 2px primaryDeep 엣지 라인
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 2,
                child: ColoredBox(color: AppColors.primaryDeep),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onPressed,
                  borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
                  splashColor: Colors.white.withValues(alpha: 0.15),
                  highlightColor: Colors.white.withValues(alpha: 0.05),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
