import 'dart:math' show pi;
import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/design_tokens.dart';
import '../../../data/premium_service.dart';
import '../../../l10n/app_localizations.dart';

/// 프리미엄 상태 확인 위젯 — 그라데이션 테두리 + 배지 + GradientButton 스타일
class PremiumDemoWidget extends StatefulWidget {
  const PremiumDemoWidget({super.key});

  @override
  State<PremiumDemoWidget> createState() => _PremiumDemoWidgetState();
}

class _PremiumDemoWidgetState extends State<PremiumDemoWidget>
    with SingleTickerProviderStateMixin {
  late PremiumService _premiumService;
  bool _isLoading = false;
  late final AnimationController _shimmerCtrl;

  @override
  void initState() {
    super.initState();
    _premiumService = PremiumService.instance;
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  Future<void> _onPurchase() async {
    final purchased = await Navigator.of(context).pushNamed(AppRoutes.paywall);
    if (purchased == true && mounted) {
      setState(() {});
    }
  }

  Future<void> _onRestore() async {
    setState(() => _isLoading = true);
    try {
      final success = await _premiumService.restorePurchases();
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? AppLocalizations.of(context)!.premiumRestoreSuccess
              : AppLocalizations.of(context)!.premiumRestoreEmpty),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('${AppLocalizations.of(context)!.paywallError}: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ValueListenableBuilder<dynamic>(
      valueListenable: _premiumService.stateNotifier,
      builder: (context, state, _) {
        final isPremium = state.isPremium;
        final purchaseDate = state.purchaseDate;

        // ── Animated shimmer gradient border wrapper ──
        return AnimatedBuilder(
          animation: _shimmerCtrl,
          builder: (_, child) {
            final angle = _shimmerCtrl.value * 2 * pi;
            return Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: SweepGradient(
                  center: Alignment.center,
                  startAngle: angle,
                  endAngle: angle + 2 * pi,
                  colors: const [
                    AppColors.primaryDeep,
                    AppColors.primaryLight,
                    AppColors.primary,
                    AppColors.primaryDeep,
                  ],
                  stops: const [0.0, 0.33, 0.66, 1.0],
                ),
              ),
              child: child,
            );
          },
          child: Container(
            margin: const EdgeInsets.all(1.5), // 1.5px gradient border
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceFill,
              borderRadius: BorderRadius.circular(16.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Premium badge pill ──
                if (isPremium)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.30),
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      '\u2726 PREMIUM ACTIVE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                // ── Status row ──
                Row(
                  children: [
                    Icon(
                      isPremium ? Icons.verified_user : Icons.lock_outline,
                      color: isPremium
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isPremium
                              ? l10n.premiumStatusActive
                              : l10n.premiumStatusFree,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isPremium
                                ? AppColors.textPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                        if (purchaseDate != null)
                          Text(
                            l10n.premiumPurchaseDate(
                                purchaseDate.toLocal().toString()),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Feature list ──
                if (isPremium) ...[
                  _FeatureRow(text: l10n.premiumFeatureAds),
                  _FeatureRow(text: l10n.premiumFeatureSets),
                  _FeatureRow(text: l10n.premiumFeaturePalettes),
                ] else ...[
                  _FeatureRow(text: l10n.paywallAds, locked: true),
                  _FeatureRow(
                      text: '${l10n.paywallRouletteSets} 3', locked: true),
                  _FeatureRow(
                      text: '${l10n.paywallColorPalettes} 2', locked: true),
                ],

                const SizedBox(height: 16),

                // ── Buttons ──
                Row(
                  children: [
                    // Purchase: GradientButton style
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius:
                              BorderRadius.circular(AppDimens.buttonRadius),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.primary.withValues(alpha: 0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _onPurchase,
                            borderRadius:
                                BorderRadius.circular(AppDimens.buttonRadius),
                            splashColor:
                                Colors.white.withValues(alpha: 0.15),
                            child: Center(
                              child: Text(
                                isPremium
                                    ? l10n.premiumPurchaseButtonActive
                                    : l10n.premiumPurchaseButtonInactive,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Restore: white 20% border, transparent bg
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius:
                              BorderRadius.circular(AppDimens.buttonRadius),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.20),
                            width: 1.5,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _isLoading ? null : _onRestore,
                            borderRadius:
                                BorderRadius.circular(AppDimens.buttonRadius),
                            splashColor:
                                Colors.white.withValues(alpha: 0.08),
                            child: Center(
                              child: _isLoading
                                  ? SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.textSecondary,
                                      ),
                                    )
                                  : Text(
                                      l10n.premiumRestoreButton,
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Feature row — check icon in Primary 10% box
class _FeatureRow extends StatelessWidget {
  final String text;
  final bool locked;

  const _FeatureRow({required this.text, this.locked = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: locked
                  ? Colors.white.withValues(alpha: 0.06)
                  : AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              locked ? Icons.close_rounded : Icons.check_rounded,
              size: 14,
              color: locked ? AppColors.textSecondary : AppColors.primary,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: locked
                  ? AppColors.textSecondary
                  : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
