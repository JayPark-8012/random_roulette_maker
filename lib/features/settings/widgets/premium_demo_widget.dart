import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../data/premium_service.dart';
import '../../../l10n/app_localizations.dart';

/// 프리미엠 상태 확인 및 테스트용 위젯
/// 
/// Settings 화면에 통합되어 프리미엄 상태를 표시하고
/// Mock 구매/복구를 테스트할 수 있음
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
    // Paywall 화면으로 이동
    final purchased = await Navigator.of(context).pushNamed(AppRoutes.paywall);
    if (purchased == true && mounted) {
      // 구매 성공 시 UI 업데이트 (ValueNotifier로 자동 처리됨)
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
        SnackBar(content: Text('${AppLocalizations.of(context)!.paywallError}: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return ValueListenableBuilder<dynamic>(
      valueListenable: _premiumService.stateNotifier,
      builder: (context, state, _) {
        final isPremium = state.isPremium;
        final purchaseDate = state.purchaseDate;

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isPremium
                ? colorScheme.primaryContainer
                : colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPremium
                  ? colorScheme.primary.withValues(alpha: 0.3)
                  : colorScheme.outlineVariant,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상태 표시
              Row(
                children: [
                  Icon(
                    isPremium ? Icons.verified_user : Icons.lock_outline,
                    color: isPremium ? colorScheme.primary : colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isPremium ? l10n.premiumStatusActive : l10n.premiumStatusFree,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isPremium
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                        ),
                      ),
                      if (purchaseDate != null)
                        Text(
                          l10n.premiumPurchaseDate(purchaseDate.toLocal().toString()),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 기능 목록
              if (isPremium)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FeatureRow('✅ ${l10n.premiumFeatureAds}'),
                    _FeatureRow('✅ ${l10n.premiumFeatureSets}'),
                    _FeatureRow('✅ ${l10n.premiumFeaturePalettes}'),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FeatureRow('❌ ${l10n.paywallAds}'),
                    _FeatureRow('❌ ${l10n.paywallRouletteSets} 3'),
                    _FeatureRow('❌ ${l10n.paywallColorPalettes} 2'),
                  ],
                ),

              const SizedBox(height: 16),

              // 버튼
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: _onPurchase,
                      child: Text(isPremium
                          ? l10n.premiumPurchaseButtonActive
                          : l10n.premiumPurchaseButtonInactive),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _onRestore,
                      child: Text(l10n.premiumRestoreButton),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Text(
                l10n.premiumMockNotice,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 기능 표시 행
class _FeatureRow extends StatelessWidget {
  final String text;

  const _FeatureRow(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
