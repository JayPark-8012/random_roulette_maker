import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../data/premium_service.dart';

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
          content: Text(success ? '✅ 복구 성공!' : '❌ 구매 기록 없음'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        isPremium ? '프리미엄 구독 중' : '무료 버전',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isPremium
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                        ),
                      ),
                      if (purchaseDate != null)
                        Text(
                          '구매: ${purchaseDate.toLocal()}',
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
                    _FeatureRow('✅ 광고 제거'),
                    _FeatureRow('✅ 룰렛 무제한'),
                    _FeatureRow('✅ 전체 팔레트'),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FeatureRow('❌ 광고 표시'),
                    _FeatureRow('❌ 룰렛 3개 제한'),
                    _FeatureRow('❌ 팔레트 2개만'),
                  ],
                ),

              const SizedBox(height: 16),

              // 버튼
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: _onPurchase,
                      child: Text(isPremium ? '구매 완료' : '프리미엄 구매'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _onRestore,
                      child: const Text('복구'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Text(
                '(Mock 구현: 실제 결제 아님)',
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
