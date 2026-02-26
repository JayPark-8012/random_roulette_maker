import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/app_themes.dart';
import '../../../core/atmosphere_presets.dart';
import '../../../core/constants.dart';
import '../../../core/design_tokens.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/roulette_wheel_themes.dart';
import '../../../data/premium_service.dart';
import '../../../domain/premium_state.dart';
import '../../../domain/roulette_wheel_theme.dart';
import '../../../domain/settings.dart';
import '../../../l10n/app_localizations.dart';
import '../state/settings_notifier.dart';
import '../widgets/premium_demo_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsNotifier _notifier = SettingsNotifier.instance;

  @override
  void initState() {
    super.initState();
    _notifier.addListener(_rebuild);
  }

  @override
  void dispose() {
    _notifier.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  void _selectTheme(BuildContext context, AppThemeData theme) {
    final l10n = AppLocalizations.of(context)!;

    // 팔레트 사용 가능 여부: PremiumService 단일 판단
    if (!PremiumService.instance.canUsePalette(theme.id)) {
      _showPaletteLockDialog(context, theme, l10n);
      return;
    }

    _notifier.setThemeId(theme.id);
  }

  void _selectWheelTheme(BuildContext context, RouletteWheelTheme wt) {
    if (!PremiumService.instance.canUseWheelTheme(wt.id)) {
      _showWheelThemeLockDialog(context, wt);
      return;
    }
    _notifier.setWheelThemeId(wt.id);
  }

  void _selectAtmosphere(BuildContext context, AtmospherePreset atm) {
    if (!PremiumService.instance.canUseAtmosphere(atm.id)) {
      _showAtmosphereLockDialog(context, atm);
      return;
    }
    _notifier.setAtmosphereId(atm.id);
  }

  void _showAtmosphereLockDialog(BuildContext context, AtmospherePreset atm) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(Icons.lock_rounded, size: 40, color: cs.primary),
        title: Text(l10n.paywallAtmosphereLockTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.paywallAtmosphereLockContent(atm.name),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // 분위기 미리보기
            Container(
              height: 40,
              decoration: BoxDecoration(
                gradient: atm.gradient,
                color: atm.gradient == null ? atm.solidColor : null,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushNamed(AppRoutes.paywall);
            },
            child: Text(l10n.paywallUnlockButton),
          ),
        ],
      ),
    );
  }

  void _showWheelThemeLockDialog(BuildContext context, RouletteWheelTheme wt) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(Icons.lock_rounded, size: 40, color: cs.primary),
        title: Text(l10n.paywallPaletteLockTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.paywallPaletteLockContent(wt.name),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // 휠 테마 색상 스와치 미리보기
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: wt.palette.take(6).map((c) {
                return Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration:
                      BoxDecoration(color: c, shape: BoxShape.circle),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushNamed(AppRoutes.paywall);
            },
            child: Text(l10n.paywallUnlockButton),
          ),
        ],
      ),
    );
  }

  /// 팔레트 잠금 다이얼로그
  void _showPaletteLockDialog(
    BuildContext context,
    AppThemeData theme,
    AppLocalizations l10n,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(Icons.lock_rounded, size: 40, color: colorScheme.primary),
        title: Text(l10n.paywallPaletteLockTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.paywallPaletteLockContent(theme.name),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // 팔레트 미리보기
            Container(
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: theme.palette.take(3).toList(),
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushNamed(AppRoutes.paywall);
            },
            child: Text(l10n.paywallUnlockButton),
          ),
        ],
      ),
    );
  }

  String _currentLanguageName(AppLocalizations l10n) {
    return switch (_notifier.localeCode) {
      'en' => l10n.langEn,
      'ko' => l10n.langKo,
      'es' => l10n.langEs,
      'pt-BR' => l10n.langPtBr,
      'ja' => l10n.langJa,
      'zh-Hans' => l10n.langZhHans,
      _ => l10n.langSystem,
    };
  }

  void _showLanguagePicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final codes = ['system', 'en', 'ko', 'es', 'pt-BR', 'ja', 'zh-Hans'];
    final names = [
      l10n.langSystem,
      l10n.langEn,
      l10n.langKo,
      l10n.langEs,
      l10n.langPtBr,
      l10n.langJa,
      l10n.langZhHans,
    ];

    showDialog<void>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.sectionLanguage),
        children: List.generate(codes.length, (i) {
          final isSelected = _notifier.localeCode == codes[i];
          return ListTile(
            leading: isSelected
                ? Icon(Icons.check_rounded,
                    color: Theme.of(ctx).colorScheme.primary)
                : const SizedBox(width: 24),
            title: Text(
              names[i],
              style: isSelected
                  ? TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(ctx).colorScheme.primary,
                    )
                  : null,
            ),
            onTap: () {
              _notifier.setLocaleCode(codes[i]);
              Navigator.of(ctx).pop();
            },
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text(l10n.settingsTitle)),
        body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // ── 프리미엄 데모 위젯 ────────────────────────
          const PremiumDemoWidget(),

          // ── Atmosphere 배경 ──────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: SectionLabel(text: l10n.atmosphereLabel),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ValueListenableBuilder<PremiumState>(
              valueListenable: PremiumService.instance.stateNotifier,
              builder: (ctx, ps, child) => GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: kAtmospherePresets.length,
                itemBuilder: (ctx, i) {
                  final atm = kAtmospherePresets[i];
                  return _AtmospherePreviewCard(
                    atmosphere: atm,
                    isSelected: atm.id == _notifier.atmosphereId,
                    isLocked: !ps.isPremium && atm.isLocked,
                    onTap: () => _selectAtmosphere(context, atm),
                  );
                },
              ),
            ),
          ),

          // ── 섹션 구분선 ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Divider(height: 1, color: Colors.white.withValues(alpha: 0.06)),
          ),
          // ── 색상 팔레트 ──────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SectionLabel(text: l10n.colorPaletteLabel),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ValueListenableBuilder<PremiumState>(
              valueListenable: PremiumService.instance.stateNotifier,
              builder: (ctx, ps, child) => GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: AppThemes.all.length,
                itemBuilder: (ctx, i) {
                  final theme = AppThemes.all[i];
                  return _ThemePreviewCard(
                    themeData: theme,
                    isSelected: theme.id == _notifier.themeId,
                    isLocked: !ps.isPremium && theme.isLocked,
                    onTap: () => _selectTheme(context, theme),
                  );
                },
              ),
            ),
          ),

          // ── 섹션 구분선 ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Divider(height: 1, color: Colors.white.withValues(alpha: 0.06)),
          ),
          // ── 룰렛 휠 테마 ─────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SectionLabel(text: l10n.wheelThemeLabel),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ValueListenableBuilder<PremiumState>(
              valueListenable: PremiumService.instance.stateNotifier,
              builder: (ctx, ps, child) => GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: kRouletteWheelThemes.length,
                itemBuilder: (ctx, i) {
                  final wt = kRouletteWheelThemes[i];
                  return _WheelThemePreviewCard(
                    wheelTheme: wt,
                    isSelected: wt.id == _notifier.wheelThemeId,
                    isLocked: !ps.isPremium && wt.isLocked,
                    onTap: () => _selectWheelTheme(context, wt),
                  );
                },
              ),
            ),
          ),

          // ── 섹션 구분선 ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Divider(height: 1, color: Colors.white.withValues(alpha: 0.06)),
          ),
          // ── 언어 ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SectionLabel(text: l10n.sectionLanguage),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GlassCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(Icons.language_rounded,
                    color: AppColors.textPrimary),
                title: Text(l10n.sectionLanguage,
                    style: const TextStyle(color: AppColors.textPrimary)),
                subtitle: Text(_currentLanguageName(l10n),
                    style: TextStyle(color: AppColors.textSecondary)),
                trailing: Icon(Icons.chevron_right,
                    color: AppColors.textSecondary),
                onTap: () => _showLanguagePicker(context),
              ),
            ),
          ),

          // ── 섹션 구분선 ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Divider(height: 1, color: Colors.white.withValues(alpha: 0.06)),
          ),
          // ── 피드백 ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SectionLabel(text: l10n.sectionFeedback),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(l10n.soundLabel,
                        style: const TextStyle(color: AppColors.textPrimary)),
                    subtitle: Text(l10n.soundSubtitle,
                        style: TextStyle(color: AppColors.textSecondary)),
                    secondary: Icon(
                      _notifier.soundEnabled
                          ? Icons.volume_up_outlined
                          : Icons.volume_off_outlined,
                      color: AppColors.textPrimary,
                    ),
                    value: _notifier.soundEnabled,
                    onChanged: _notifier.setSoundEnabled,
                  ),
                  if (_notifier.soundEnabled) ...[
                    Divider(
                        indent: 20,
                        endIndent: 20,
                        color: AppColors.surfaceBorder),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.soundPackLabel,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SegmentedButton<SoundPack>(
                            expandedInsets: EdgeInsets.zero,
                            segments: [
                              ButtonSegment(
                                value: SoundPack.basic,
                                label: Text(l10n.packBasic),
                              ),
                              ButtonSegment(
                                value: SoundPack.clicky,
                                label: Text(l10n.packClicky),
                              ),
                              ButtonSegment(
                                value: SoundPack.party,
                                label: Text(l10n.packParty),
                              ),
                            ],
                            selected: {_notifier.soundPack},
                            onSelectionChanged: (set) =>
                                _notifier.setSoundPack(set.first),
                            showSelectedIcon: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                  Divider(
                      indent: 20,
                      endIndent: 20,
                      color: AppColors.surfaceBorder),
                  ListTile(
                    leading: const Icon(Icons.vibration,
                        color: AppColors.textPrimary),
                    title: Text(l10n.vibrationLabel,
                        style: const TextStyle(color: AppColors.textPrimary)),
                    subtitle: Text(l10n.vibrationSubtitle,
                        style: TextStyle(color: AppColors.textSecondary)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: SegmentedButton<HapticStrength>(
                      expandedInsets: EdgeInsets.zero,
                      segments: [
                        ButtonSegment(
                          value: HapticStrength.off,
                          label: Text(l10n.hapticOff),
                        ),
                        ButtonSegment(
                          value: HapticStrength.light,
                          label: Text(l10n.hapticLight),
                        ),
                        ButtonSegment(
                          value: HapticStrength.strong,
                          label: Text(l10n.hapticStrong),
                        ),
                      ],
                      selected: {_notifier.hapticStrength},
                      onSelectionChanged: (set) =>
                          _notifier.setHapticStrength(set.first),
                      showSelectedIcon: false,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── 섹션 구분선 ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Divider(height: 1, color: Colors.white.withValues(alpha: 0.06)),
          ),
          // ── 스핀 시간 ────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SectionLabel(text: l10n.sectionSpinTime),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GlassCard(
              child: SegmentedButton<SpinDuration>(
                expandedInsets: EdgeInsets.zero,
                segments: [
                  ButtonSegment(
                    value: SpinDuration.short,
                    label: Text(l10n.spinShort),
                    icon: const Icon(Icons.flash_on_outlined),
                  ),
                  ButtonSegment(
                    value: SpinDuration.normal,
                    label: Text(l10n.spinNormal),
                    icon: const Icon(Icons.speed),
                  ),
                  ButtonSegment(
                    value: SpinDuration.long,
                    label: Text(l10n.spinLong),
                    icon: const Icon(Icons.hourglass_empty_rounded),
                  ),
                ],
                selected: {_notifier.spinDuration},
                onSelectionChanged: (set) =>
                    _notifier.setSpinDuration(set.first),
                showSelectedIcon: false,
              ),
            ),
          ),

          // ── 섹션 구분선 ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Divider(height: 1, color: Colors.white.withValues(alpha: 0.06)),
          ),
          // ── 앱 정보 ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SectionLabel(text: l10n.sectionAppInfo),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline,
                        color: AppColors.textPrimary),
                    title: Text(l10n.versionLabel,
                        style: const TextStyle(color: AppColors.textPrimary)),
                    trailing: Text(
                      '1.0.0 (MVP)',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  Divider(
                      indent: 20,
                      endIndent: 20,
                      color: AppColors.surfaceBorder),
                  ListTile(
                    leading: const Icon(Icons.article_outlined,
                        color: AppColors.textPrimary),
                    title: Text(l10n.openSourceLabel,
                        style: const TextStyle(color: AppColors.textPrimary)),
                    trailing: Icon(Icons.chevron_right,
                        color: AppColors.textSecondary),
                    onTap: () => showLicensePage(
                      context: context,
                      applicationName: '랜덤 룰렛 메이커',
                      applicationVersion: '1.0.0',
                    ),
                  ),
                  Divider(
                      indent: 20,
                      endIndent: 20,
                      color: AppColors.surfaceBorder),
                  ListTile(
                    leading: const Icon(Icons.mail_outline,
                        color: AppColors.textPrimary),
                    title: Text(l10n.contactLabel,
                        style: const TextStyle(color: AppColors.textPrimary)),
                    trailing: Icon(Icons.chevron_right,
                        color: AppColors.textSecondary),
                    // TODO(Phase3): url_launcher로 이메일 앱 실행
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.comingSoon)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}

// ── Atmosphere 프리뷰 카드 ────────────────────────────────
class _AtmospherePreviewCard extends StatelessWidget {
  final AtmospherePreset atmosphere;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback onTap;

  const _AtmospherePreviewCard({
    required this.atmosphere,
    required this.isSelected,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: atmosphere.gradient,
          color: atmosphere.gradient == null ? atmosphere.solidColor : null,
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.white.withValues(alpha: 0.15),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: Stack(
            children: [
              // ── Locked overlay: 50% black + blur + lock icon ──
              if (isLocked) ...[
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.50),
                    ),
                  ),
                ),
                const Center(
                  child: Icon(Icons.lock_rounded,
                      size: 20, color: Colors.white70),
                ),
              ],
              // ── Name label ──
              Positioned(
                left: 10,
                bottom: 8,
                child: Text(
                  atmosphere.name,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              // ── Selected check badge ──
              if (isSelected)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.check_rounded,
                        size: 13, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 테마 프리뷰 카드 ─────────────────────────────────────
class _ThemePreviewCard extends StatelessWidget {
  final AppThemeData themeData;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback onTap;

  const _ThemePreviewCard({
    required this.themeData,
    required this.isSelected,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // ── Card ──
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.white.withValues(alpha: 0.12),
                  width: isSelected ? 2 : 1,
                ),
                color: Colors.white.withValues(alpha: 0.055),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Stack(
                  children: [
                    // 색상 스와치 (팔레트 앞 5개)
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: themeData.palette.take(5).map((c) {
                          return Container(
                            width: 14,
                            height: 14,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 1.5),
                            decoration: BoxDecoration(
                                color: c, shape: BoxShape.circle),
                          );
                        }).toList(),
                      ),
                    ),
                    // ── Locked overlay ──
                    if (isLocked) ...[
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.50),
                          ),
                        ),
                      ),
                      const Center(
                        child: Icon(Icons.lock_rounded,
                            size: 18, color: Colors.white70),
                      ),
                    ],
                    // ── Selected check badge ──
                    if (isSelected)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.check_rounded,
                              size: 13, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // ── Label below card ──
          const SizedBox(height: 4),
          Text(
            themeData.name,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── 룰렛 휠 테마 프리뷰 카드 ─────────────────────────────
class _WheelThemePreviewCard extends StatelessWidget {
  final RouletteWheelTheme wheelTheme;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback onTap;

  const _WheelThemePreviewCard({
    required this.wheelTheme,
    required this.isSelected,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // ── Card ──
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.white.withValues(alpha: 0.12),
                  width: isSelected ? 2 : 1,
                ),
                color: Colors.white.withValues(alpha: 0.055),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Stack(
                  children: [
                    Center(
                      child: CustomPaint(
                        painter: _MiniWheelPreviewPainter(
                          palette: wheelTheme.palette,
                          style: wheelTheme.style,
                        ),
                        size: const Size(44, 44),
                      ),
                    ),
                    // ── Locked overlay ──
                    if (isLocked) ...[
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.50),
                          ),
                        ),
                      ),
                      const Center(
                        child: Icon(Icons.lock_rounded,
                            size: 18, color: Colors.white70),
                      ),
                    ],
                    // ── Selected check badge ──
                    if (isSelected)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.check_rounded,
                              size: 13, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // ── Label below card ──
          const SizedBox(height: 4),
          Text(
            wheelTheme.name,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── 미니 휠 프리뷰 페인터 (설정 화면용) ───────────────────
class _MiniWheelPreviewPainter extends CustomPainter {
  final List<Color> palette;
  final WheelStyle style;

  const _MiniWheelPreviewPainter({
    required this.palette,
    required this.style,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;
    const count = 6;
    final sectorAngle = 2 * pi / count;

    for (int i = 0; i < count; i++) {
      final color = palette[i % palette.length];
      final start = -pi / 2 + i * sectorAngle;
      final rect = Rect.fromCircle(center: center, radius: radius);

      switch (style) {
        case WheelStyle.gradient:
          final lighter = Color.lerp(color, Colors.white, 0.4)!;
          canvas.drawArc(
            rect, start, sectorAngle, true,
            Paint()
              ..shader = RadialGradient(
                colors: [lighter, color],
              ).createShader(rect),
          );
        case WheelStyle.neonGlow:
          canvas.drawArc(rect, start, sectorAngle, true,
              Paint()..color = Color.lerp(color, Colors.black, 0.15)!);
          canvas.drawArc(rect, start, sectorAngle, true,
              Paint()
                ..color = color.withValues(alpha: 0.9)
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2
                ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
        case WheelStyle.metallic:
          canvas.drawArc(rect, start, sectorAngle, true,
              Paint()..color = color);
          canvas.drawArc(rect, start, sectorAngle, true,
              Paint()
                ..shader = LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.30),
                    Colors.transparent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(rect));
        case WheelStyle.crystal:
          canvas.drawArc(rect, start, sectorAngle, true,
              Paint()..color = color);
          canvas.drawArc(rect, start, sectorAngle, true,
              Paint()..color = Colors.white.withValues(alpha: 0.18));
        case WheelStyle.classic:
          canvas.drawArc(rect, start, sectorAngle, true,
              Paint()..color = color);
      }

      // 섹터 구분선
      canvas.drawArc(rect, start, sectorAngle, true,
          Paint()
            ..color = Colors.white.withValues(alpha: 0.6)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.8);
    }

    // 외곽 링
    canvas.drawCircle(
      center, radius,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // 중앙 허브
    canvas.drawCircle(center, radius * 0.18, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_MiniWheelPreviewPainter old) =>
      old.palette != palette || old.style != style;
}

