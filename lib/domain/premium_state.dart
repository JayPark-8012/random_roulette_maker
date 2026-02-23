import 'package:flutter/foundation.dart';

/// 프리미엄 구독 상태 모델
@immutable
class PremiumState {
  /// 프리미엄 구독 여부
  final bool isPremium;

  /// 구매 일시 (프리미엄인 경우만 설정)
  final DateTime? purchaseDate;

  const PremiumState({
    required this.isPremium,
    this.purchaseDate,
  });

  /// 팩토리: 무료 상태
  factory PremiumState.free() {
    return const PremiumState(isPremium: false);
  }

  /// 팩토리: 프리미엄 상태
  factory PremiumState.premium({DateTime? purchaseDate}) {
    return PremiumState(
      isPremium: true,
      purchaseDate: purchaseDate ?? DateTime.now(),
    );
  }

  /// JSON 직렬화
  Map<String, dynamic> toJson() => {
        'isPremium': isPremium,
        'purchaseDate': purchaseDate?.toIso8601String(),
      };

  /// JSON 역직렬화
  factory PremiumState.fromJson(Map<String, dynamic> json) {
    final isPremium = json['isPremium'] as bool? ?? false;
    final purchaseDateStr = json['purchaseDate'] as String?;
    return PremiumState(
      isPremium: isPremium,
      purchaseDate: purchaseDateStr != null ? DateTime.parse(purchaseDateStr) : null,
    );
  }

  @override
  String toString() => 'PremiumState(isPremium: $isPremium, purchaseDate: $purchaseDate)';
}
