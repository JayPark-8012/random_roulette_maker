import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../data/premium_service.dart';
import '../../../l10n/app_localizations.dart';

/// 프리미엄 상태 확인 위젯 — 정적 카드 + 배지 + 버튼
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
    final l10n = AppLocalizations.of(context)!;

    return ValueListenableBuilder<dynamic>(
      valueListenable: _premiumService.stateNotifier,
      builder: (context, state, _) {
        final isPremium = state.isPremium;
        final purchaseDate = state.purchaseDate;

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1C30),
            border: Border.all(
              color: const Color(0xFF00D4FF).withValues(alpha: 0.3),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16),
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
                    color: const Color(0xFF00D4FF).withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: const Color(0xFF00D4FF).withValues(alpha: 0.30),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    '\u2726 PREMIUM ACTIVE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: Color(0xFF00D4FF),
                    ),
                  ),
                ),

              // ── Status row ──
              Row(
                children: [
                  Icon(
                    isPremium ? Icons.verified_user : Icons.lock_rounded,
                    color: const Color(0xFFFFB800),
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (purchaseDate != null)
                        Text(
                          l10n.premiumPurchaseDate(
                              purchaseDate.toLocal().toString()),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.5),
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
              ] else ...[
                _FeatureRow(text: l10n.paywallAds, locked: true),
                _FeatureRow(
                    text: '${l10n.paywallRouletteSets} 3', locked: true),
              ],

              const SizedBox(height: 16),

              // ── Buttons ──
              Row(
                children: [
                  // Purchase button
                  Expanded(
                    child: GestureDetector(
                      onTap: _onPurchase,
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0284C7), Color(0xFF00D4FF)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          isPremium
                              ? l10n.premiumPurchaseButtonActive
                              : l10n.premiumPurchaseButtonInactive,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Restore button
                  Expanded(
                    child: GestureDetector(
                      onTap: _isLoading ? null : _onRestore,
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E1628),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: _isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white54,
                                ),
                              )
                            : Text(
                                l10n.premiumRestoreButton,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
                  : const Color(0xFF00D4FF).withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              locked ? Icons.close_rounded : Icons.check_rounded,
              size: 14,
              color: locked
                  ? Colors.white.withValues(alpha: 0.35)
                  : const Color(0xFF00D4FF),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: locked
                  ? Colors.white.withValues(alpha: 0.5)
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
