import 'dart:io' show Platform;

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'premium_service.dart';

// ─────────────────────────────────────────────────────────────
// ★★★ 출시 전 AdMob 콘솔에서 발급한 실제 Unit ID로 교체 ★★★
//
// 현재 값 : Google 공식 테스트 Unit ID (개발/QA 전용)
//           → 실제 수익 없음, 실제 광고 미노출
// 교체 방법: https://apps.admob.com → 앱 → 광고 단위
// ─────────────────────────────────────────────────────────────
class _AdUnitIds {
  static String get interstitial => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712' // Android 테스트
      : 'ca-app-pub-3940256099942544/4411468910'; // iOS 테스트

  static String get banner => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111' // Android 테스트
      : 'ca-app-pub-3940256099942544/2934735716'; // iOS 테스트

  static String get rewarded => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917' // Android 테스트
      : 'ca-app-pub-3940256099942544/1712485313'; // iOS 테스트
}

/// 광고 서비스 — Android/iOS 전용 실제 구현
///
/// 웹에서는 ad_service_web.dart의 stub이 사용됨.
/// 외부에서는 ad_service.dart(conditional export)를 통해서만 접근.
class AdService {
  AdService._();
  static final AdService instance = AdService._();

  bool _isInitialized = false;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  // ── 통합 도구 사용 카운트 → 광고 트리거 ──────────────────
  static const int adTriggerCount = 5;
  static const int ladderAdWeight = 3;

  int _useCount = 0;

  // ── 전면 광고 쿨타임/빈도 제어 ─────────────────────────────
  static const Duration _kCooldown = Duration(seconds: 60);
  static const int _kDailyMax = 8;

  DateTime? _lastInterstitialShownAt;
  int _todayInterstitialCount = 0;
  String _todayDateKey = '';

  bool get _isPremium => PremiumService.instance.isPremium;

  // ── 초기화 ──────────────────────────────────────────────

  Future<void> initialize() async {
    if (_isPremium) {
      debugPrint('[AdService] initialize: skipped (premium user)');
      return;
    }
    await MobileAds.instance.initialize();
    _isInitialized = true;
    debugPrint('[AdService] MobileAds initialized ✓');
    _loadInterstitial();
    _loadRewarded();
  }

  // ── 전면 광고 ────────────────────────────────────────────

  void _loadInterstitial() {
    if (_isPremium || !_isInitialized) return;

    InterstitialAd.load(
      adUnitId: _AdUnitIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _loadInterstitial();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('[AdService] interstitial show failed: $error');
              ad.dispose();
              _interstitialAd = null;
              _loadInterstitial();
            },
          );
          debugPrint('[AdService] interstitial loaded ✓');
        },
        onAdFailedToLoad: (error) {
          debugPrint('[AdService] interstitial load failed: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  Future<void> showInterstitial() async {
    if (_isPremium) {
      debugPrint('[AdService] showInterstitial: skipped (premium)');
      return;
    }
    if (_interstitialAd == null) {
      debugPrint('[AdService] showInterstitial: not ready, queuing load');
      _loadInterstitial();
      return;
    }
    await _interstitialAd!.show();
  }

  /// 도구 사용 기록 — 통합 카운트 방식
  ///
  /// [toolType]: 'roulette' | 'coin' | 'dice' | 'number' | 'ladder'
  /// 사다리는 1회 = [ladderAdWeight]회 카운트.
  /// [adTriggerCount]회 누적 시 전면 광고 표시 후 카운트 리셋.
  Future<void> recordToolUse(String toolType) async {
    if (_isPremium || !_isInitialized) {
      if (_isPremium) {
        debugPrint('[AdService] recordToolUse: skipped (premium)');
      }
      return;
    }

    final weight = toolType == 'ladder' ? ladderAdWeight : 1;
    _useCount += weight;
    debugPrint(
        '[AdService] recordToolUse($toolType +$weight): $_useCount/$adTriggerCount');

    if (_useCount < adTriggerCount) return;

    // ── 쿨타임 / 일일 상한 체크 ──
    final now = DateTime.now();
    if (_lastInterstitialShownAt != null &&
        now.difference(_lastInterstitialShownAt!) < _kCooldown) {
      debugPrint('[AdService] recordToolUse: cooldown — skip ad');
      return;
    }

    final todayKey =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    if (_todayDateKey != todayKey) {
      _todayDateKey = todayKey;
      _todayInterstitialCount = 0;
    }
    if (_todayInterstitialCount >= _kDailyMax) {
      debugPrint(
          '[AdService] recordToolUse: daily max ($_kDailyMax) reached — skip');
      return;
    }

    _useCount = 0;
    _lastInterstitialShownAt = now;
    _todayInterstitialCount++;
    debugPrint(
        '[AdService] recordToolUse: showing ad (today: $_todayInterstitialCount/$_kDailyMax)');
    await showInterstitial();
  }

  /// 하위 호환: 기존 룰렛 PlayScreen 호출용
  Future<void> tryShowInterstitialAfterSpin() =>
      recordToolUse('roulette');

  // ── 배너 광고 ────────────────────────────────────────────

  Widget bannerWidget({AdSize size = AdSize.banner}) {
    if (_isPremium || !_isInitialized) {
      if (_isPremium) {
        debugPrint('[AdService] bannerWidget: skipped (premium)');
      }
      return const SizedBox.shrink();
    }
    return _BannerAdWidget(adUnitId: _AdUnitIds.banner, size: size);
  }

  // ── 보상형 광고 ──────────────────────────────────────────

  void _loadRewarded() {
    if (_isPremium || !_isInitialized) return;

    RewardedAd.load(
      adUnitId: _AdUnitIds.rewarded,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              _loadRewarded();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('[AdService] rewarded show failed: $error');
              ad.dispose();
              _rewardedAd = null;
              _loadRewarded();
            },
          );
          debugPrint('[AdService] rewarded loaded ✓');
        },
        onAdFailedToLoad: (error) {
          debugPrint('[AdService] rewarded load failed: $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  Future<bool> showRewarded() async {
    if (_isPremium) {
      debugPrint('[AdService] showRewarded: skipped (premium) → true');
      return true;
    }
    if (_rewardedAd == null) {
      debugPrint('[AdService] showRewarded: not ready, queuing load');
      _loadRewarded();
      return false;
    }
    bool rewarded = false;
    await _rewardedAd!.show(
      onUserEarnedReward: (_, reward) {
        rewarded = true;
        debugPrint(
            '[AdService] rewarded earned: ${reward.amount} ${reward.type}');
      },
    );
    return rewarded;
  }

  // ── 프리미엄 전환 시 정리 ────────────────────────────────

  void onPremiumActivated() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isInitialized = false;
    debugPrint('[AdService] ads cleared (premium activated)');
  }
}

// ── 내부 배너 위젯 ──────────────────────────────────────────

class _BannerAdWidget extends StatefulWidget {
  final String adUnitId;
  final AdSize size;

  const _BannerAdWidget({required this.adUnitId, required this.size});

  @override
  State<_BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<_BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _bannerAd = BannerAd(
      adUnitId: widget.adUnitId,
      size: widget.size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _isLoaded = true);
          debugPrint('[AdService] banner loaded ✓');
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('[AdService] banner load failed: $error');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) return const SizedBox.shrink();
    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
