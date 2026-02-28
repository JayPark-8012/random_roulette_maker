import 'package:flutter/material.dart';
import '../../../core/widgets/app_background.dart';
import '../../../data/premium_service.dart';
import '../../../l10n/app_localizations.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  late PremiumService _premiumService;
  bool _isPurchasing = false;
  bool _isRestoring = false;

  @override
  void initState() {
    super.initState();
    _premiumService = PremiumService.instance;
  }

  Future<void> _onPurchase() async {
    setState(() => _isPurchasing = true);
    try {
      final success = await _premiumService.purchase();
      if (!mounted) return;

      if (success) {
        // 성공 메시지
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.paywallPurchaseSuccess),
            duration: const Duration(seconds: 2),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        // 화면 닫기
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) Navigator.of(context).pop(true);
        });
      } else {
        // 실패 다이얼로그
        _showErrorDialog(
          context,
          AppLocalizations.of(context)!.paywallPurchaseFailed,
          AppLocalizations.of(context)!.paywallTryAgain,
        );
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog(
        context,
        AppLocalizations.of(context)!.paywallError,
        '${e.toString()}\n\n${AppLocalizations.of(context)!.paywallTryAgain}',
      );
    } finally {
      if (mounted) setState(() => _isPurchasing = false);
    }
  }

  Future<void> _onRestore() async {
    setState(() => _isRestoring = true);
    try {
      final success = await _premiumService.restorePurchases();
      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.paywallRestoreSuccess,
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) Navigator.of(context).pop(true);
        });
      } else {
        _showErrorDialog(
          context,
          AppLocalizations.of(context)!.paywallNoRestorableItems,
          AppLocalizations.of(context)!.paywallNoPreviousPurchase,
        );
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog(
        context,
        AppLocalizations.of(context)!.paywallError,
        e.toString(),
      );
    } finally {
      if (mounted) setState(() => _isRestoring = false);
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppLocalizations.of(context)!.actionCancel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.paywallTitle,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(false),
                      tooltip: l10n.actionCancel,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.paywallSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),

                const SizedBox(height: 32),

                // ── 비교 섹션 ────────────────────────────────────────
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.outlineVariant,
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // ── 헤더 행 (무료/프리미엄) ──
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '',
                              style:
                                  Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                l10n.paywallFree,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  l10n.paywallPremium,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onPrimary,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Divider(color: colorScheme.outlineVariant),
                      const SizedBox(height: 16),

                      // ── 비교 항목들 (5행) ──
                      _ComparisonRow(
                        label: l10n.paywallAdsRow,
                        free: false,
                        premium: true,
                      ),
                      const SizedBox(height: 12),
                      _ComparisonRow(
                        label: l10n.paywallRouletteRow,
                        freeText: l10n.paywallFreeRoulette,
                        premiumText: l10n.paywallPremiumRoulette,
                      ),
                      const SizedBox(height: 12),
                      _ComparisonRow(
                        label: l10n.paywallLadderRow,
                        freeText: l10n.paywallFreeLadder,
                        premiumText: l10n.paywallPremiumLadder,
                      ),
                      const SizedBox(height: 12),
                      _ComparisonRow(
                        label: l10n.paywallDiceRow,
                        freeText: l10n.paywallFreeDice,
                        premiumText: l10n.paywallPremiumDice,
                      ),
                      const SizedBox(height: 12),
                      _ComparisonRow(
                        label: l10n.paywallNumberRow,
                        freeText: l10n.paywallFreeNumber,
                        premiumText: l10n.paywallPremiumNumber,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ── 가격 정보 ────────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary.withValues(alpha: 0.1),
                        colorScheme.tertiary.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        l10n.paywallOneTimePrice,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.paywallForever,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ── CTA 버튼들 ────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isPurchasing || _isRestoring ? null : _onPurchase,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isPurchasing
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(
                            l10n.paywallPurchaseButton,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 12),

                // ── 복구 버튼 ──
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _isPurchasing || _isRestoring ? null : _onRestore,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isRestoring
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                colorScheme.primary,
                              ),
                            ),
                          )
                        : Text(
                            l10n.paywallRestoreButton,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 12),

                // ── 취소/닫기 텍스트 버튼 ──
                Center(
                  child: TextButton(
                    onPressed:
                        _isPurchasing || _isRestoring
                            ? null
                            : () => Navigator.of(context).pop(false),
                    child: Text(
                      l10n.actionCancel,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── 하단 고지사항 ────────────────────────────────────────
                Center(
                  child: Text(
                    l10n.paywallMockNotice,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}

// ── 비교 행 위젯 ──────────────────────────────────────────
class _ComparisonRow extends StatelessWidget {
  final String label;
  final bool? free;
  final bool? premium;
  final String? freeText;
  final String? premiumText;

  const _ComparisonRow({
    required this.label,
    this.free,
    this.premium,
    this.freeText,
    this.premiumText,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        // Free
        Expanded(
          child: Center(
            child: free != null
                ? Icon(
                    free! ? Icons.check_circle : Icons.block,
                    color: free! ? colorScheme.primary : colorScheme.error,
                    size: 24,
                  )
                : Text(
                    freeText ?? '-',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
          ),
        ),
        // Premium
        Expanded(
          child: Center(
            child: premium != null
                ? Icon(
                    premium! ? Icons.check_circle : Icons.block,
                    color: premium! ? colorScheme.primary : colorScheme.error,
                    size: 24,
                  )
                : Text(
                    premiumText ?? '-',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                    textAlign: TextAlign.center,
                  ),
          ),
        ),
      ],
    );
  }
}
