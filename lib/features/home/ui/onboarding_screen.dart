import 'package:flutter/material.dart';
import '../../../core/design_tokens.dart';
import '../../../l10n/app_localizations.dart';

/// 온보딩 슬라이드 데이터
class _SlideData {
  final String emoji;
  final String Function(AppLocalizations) title;
  final String Function(AppLocalizations) desc;
  final Color accentColor;

  const _SlideData({
    required this.emoji,
    required this.title,
    required this.desc,
    required this.accentColor,
  });
}

final _slides = [
  _SlideData(
    emoji: '🎯',
    title: (l) => l.onboardingSlide1Title,
    desc: (l) => l.onboardingSlide1Desc,
    accentColor: AppColors.colorRoulette,
  ),
  _SlideData(
    emoji: '🪜',
    title: (l) => l.onboardingSlide2Title,
    desc: (l) => l.onboardingSlide2Desc,
    accentColor: AppColors.colorLadder,
  ),
  _SlideData(
    emoji: '✦',
    title: (l) => l.onboardingSlide3Title,
    desc: (l) => l.onboardingSlide3Desc,
    accentColor: AppColors.colorNumber,
  ),
];

/// 앱 첫 실행 시 표시되는 온보딩 슬라이드 (3장)
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onComplete() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _onNext() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLast = _currentPage == _slides.length - 1;
    final currentSlide = _slides[_currentPage];

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Stack(
          children: [
            // ── PageView (슬라이드) ──
            PageView.builder(
              controller: _pageController,
              itemCount: _slides.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, index) {
                final slide = _slides[index];
                return _SlidePage(slide: slide, l10n: l10n);
              },
            ),

            // ── 상단 우측: 건너뛰기 ──
            Positioned(
              top: 20,
              right: 16,
              child: IgnorePointer(
                ignoring: isLast,
                child: AnimatedOpacity(
                  opacity: isLast ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  child: TextButton(
                    onPressed: _onComplete,
                    child: Text(
                      l10n.onboardingSkip,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── 하단: 도트 인디케이터 + 버튼 ──
            Positioned(
              left: 24,
              right: 24,
              bottom: 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 도트 인디케이터
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (i) {
                      final isActive = i == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isActive ? 20 : 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: isActive
                              ? currentSlide.accentColor
                              : Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),

                  // 다음/시작 버튼
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: GestureDetector(
                      onTap: _onNext,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              currentSlide.accentColor,
                              currentSlide.accentColor.withValues(alpha: 0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  currentSlide.accentColor.withValues(alpha: 0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          isLast ? l10n.onboardingStart : l10n.onboardingNext,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 개별 슬라이드 페이지 ──────────────────────────────────────

class _SlidePage extends StatelessWidget {
  final _SlideData slide;
  final AppLocalizations l10n;

  const _SlidePage({required this.slide, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.3),
          radius: 1.2,
          colors: [
            slide.accentColor.withValues(alpha: 0.08),
            AppColors.bgBase,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 이모지
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
              builder: (context, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },
              child: Text(
                slide.emoji,
                style: const TextStyle(fontSize: 80),
              ),
            ),
            const SizedBox(height: 32),

            // 타이틀
            Text(
              slide.title(l10n),
              style: const TextStyle(
                fontFamily: 'Syne',
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // 설명
            Text(
              slide.desc(l10n),
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // 하단 버튼 영역 확보
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
