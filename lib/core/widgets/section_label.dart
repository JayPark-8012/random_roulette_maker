import 'package:flutter/material.dart';
import '../design_tokens.dart';

/// 섹션 라벨 — 대문자 + 넓은 자간 + trailing 텍스트 옵션
class SectionLabel extends StatelessWidget {
  final String text;
  final String? trailing;
  final VoidCallback? onTrailingTap;
  final EdgeInsetsGeometry padding;

  const SectionLabel({
    super.key,
    required this.text,
    this.trailing,
    this.onTrailingTap,
    this.padding = const EdgeInsets.only(bottom: 10),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Text(
            text.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
          if (trailing != null) ...[
            const Spacer(),
            GestureDetector(
              onTap: onTrailingTap,
              child: Text(
                trailing!,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
