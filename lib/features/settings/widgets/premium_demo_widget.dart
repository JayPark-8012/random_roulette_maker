import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/design_tokens.dart';
import '../../../data/premium_service.dart';
import '../../../l10n/app_localizations.dart';

/// 프리미엄 상태 확인 위젯 — 무료/프리미엄 분기 렌더링
class PremiumDemoWidget extends StatefulWidget {
  const PremiumDemoWidget({super.key});

  @override
  State<PremiumDemoWidget> createState() => _PremiumDemoWidgetState();
}

class _PremiumDemoWidgetState extends State<PremiumDemoWidget> {
  late PremiumService _premiumService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _premiumService = PremiumService.instance;
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
    return ValueListenableBuilder<dynamic>(
      valueListenable: _premiumService.stateNotifier,
      builder: (context, state, _) {
        final isPremium = state.isPremium;
        if (isPremium) {
          return _ProPremiumBox(purchaseDate: state.purchaseDate);
        }
        return _FreePremiumBox(
          isLoading: _isLoading,
          onPurchase: _onPurchase,
          onRestore: _onRestore,
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── FREE PLAN BOX ────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════

class _FreePremiumBox extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPurchase;
  final VoidCallback onRestore;

  const _FreePremiumBox({
    required this.isLoading,
    required this.onPurchase,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F1C30), Color(0xFF1A1040)],
        ),
        border: Border.all(
          color: AppColors.spark.withValues(alpha: 0.3),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // ── Glow circles ──
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.spark.withValues(alpha: 0.15),
                    AppColors.spark.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.stopRed.withValues(alpha: 0.1),
                    AppColors.stopRed.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // ── Content ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header: lock icon + title + FREE chip ──
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.stopRed.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.lock_rounded,
                        color: AppColors.stopRed,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.settingsPremiumFreeTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.stopRed.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: AppColors.stopRed.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Text(
                        'FREE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                          color: AppColors.stopRed,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Limit rows with ✕ badges ──
                _LimitRow(
                  icon: Icons.close_rounded,
                  iconColor: AppColors.stopRed,
                  bgColor: AppColors.stopRed.withValues(alpha: 0.1),
                  text: l10n.settingsPremiumFreeLimitRoulette(3),
                ),
                const SizedBox(height: 8),
                _LimitRow(
                  icon: Icons.close_rounded,
                  iconColor: AppColors.stopRed,
                  bgColor: AppColors.stopRed.withValues(alpha: 0.1),
                  text: l10n.settingsPremiumFreeLimitLadder(
                      PremiumService.maxFreeLadderParticipants),
                ),
                const SizedBox(height: 8),
                _LimitRow(
                  icon: Icons.close_rounded,
                  iconColor: AppColors.stopRed,
                  bgColor: AppColors.stopRed.withValues(alpha: 0.1),
                  text: l10n.settingsPremiumFreeLimitDice,
                ),
                const SizedBox(height: 8),
                _LimitRow(
                  icon: Icons.close_rounded,
                  iconColor: AppColors.stopRed,
                  bgColor: AppColors.stopRed.withValues(alpha: 0.1),
                  text: l10n.settingsPremiumFreeLimitNumber(
                      '9,999'),
                ),

                const SizedBox(height: 16),

                // ── Benefit chips (Wrap) ──
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _BenefitChip(text: l10n.settingsPremiumBenefitNoAds),
                    _BenefitChip(text: l10n.settingsPremiumBenefitUnlimitedSets),
                    _BenefitChip(text: l10n.settingsPremiumBenefitAllDice),
                    _BenefitChip(text: l10n.settingsPremiumBenefitExtRange),
                    _BenefitChip(text: l10n.settingsPremiumBenefitAllBg),
                  ],
                ),

                const SizedBox(height: 20),

                // ── Purchase button (spark gradient) ──
                GestureDetector(
                  onTap: onPurchase,
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.spark, Color(0xFFB44AFF)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.spark.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      l10n.settingsPremiumUnlockAll,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ── Restore button (outline) ──
                GestureDetector(
                  onTap: isLoading ? null : onRestore,
                  child: Container(
                    width: double.infinity,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white54,
                            ),
                          )
                        : Text(
                            l10n.settingsPremiumRestore,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── PRO PREMIUM BOX ──────────────────────────────────────────
// ══════════════════════════════════════════════════════════════

class _ProPremiumBox extends StatelessWidget {
  final DateTime? purchaseDate;

  const _ProPremiumBox({this.purchaseDate});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F2218), Color(0xFF0A1C30)],
        ),
        border: Border.all(
          color: AppColors.colorNumber.withValues(alpha: 0.3),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // ── Glow circle ──
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.colorNumber.withValues(alpha: 0.15),
                    AppColors.colorNumber.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // ── Content ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header: crown icon + title + ACTIVE chip ──
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.colorNumber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          '👑',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.settingsPremiumProTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: Colors.white,
                            ),
                          ),
                          if (purchaseDate != null)
                            Text(
                              l10n.premiumPurchaseDate(
                                  purchaseDate!.toLocal().toString().split(' ').first),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.colorNumber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: AppColors.colorNumber.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Text(
                        'ACTIVE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                          color: AppColors.colorNumber,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Benefit rows with ✓ badges ──
                _LimitRow(
                  icon: Icons.check_rounded,
                  iconColor: AppColors.colorNumber,
                  bgColor: AppColors.colorNumber.withValues(alpha: 0.1),
                  text: l10n.settingsPremiumProBenefitAds,
                ),
                const SizedBox(height: 8),
                _LimitRow(
                  icon: Icons.check_rounded,
                  iconColor: AppColors.colorNumber,
                  bgColor: AppColors.colorNumber.withValues(alpha: 0.1),
                  text: l10n.settingsPremiumProBenefitSets,
                ),
                const SizedBox(height: 8),
                _LimitRow(
                  icon: Icons.check_rounded,
                  iconColor: AppColors.colorNumber,
                  bgColor: AppColors.colorNumber.withValues(alpha: 0.1),
                  text: l10n.settingsPremiumProBenefitTools,
                ),
                const SizedBox(height: 8),
                _LimitRow(
                  icon: Icons.check_rounded,
                  iconColor: AppColors.colorNumber,
                  bgColor: AppColors.colorNumber.withValues(alpha: 0.1),
                  text: l10n.settingsPremiumProBenefitBg,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── SHARED SUB-WIDGETS ───────────────────────────────────────
// ══════════════════════════════════════════════════════════════

/// Row with icon badge + text (used for both limit & benefit rows)
class _LimitRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String text;

  const _LimitRow({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 14, color: iconColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ),
      ],
    );
  }
}

/// Benefit chip (spark outlined pill)
class _BenefitChip extends StatelessWidget {
  final String text;

  const _BenefitChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.spark.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: AppColors.spark.withValues(alpha: 0.25),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.spark.withValues(alpha: 0.85),
        ),
      ),
    );
  }
}
