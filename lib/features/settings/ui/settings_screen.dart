import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/app_themes.dart';
import '../../../core/atmosphere_presets.dart';
import '../../../core/constants.dart';
import '../../../core/design_tokens.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/section_label.dart';
import '../../../data/premium_service.dart';
import '../../../domain/premium_state.dart';
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
  /// false로 설정하면 Atmosphere 배경 프리셋 섹션이 숨겨짐.
  /// 다시 켜려면 true로 변경.
  static const _showAtmosphereSection = false;

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

  Widget _buildSegment<T>({
    required List<(T, String)> items,
    required T selected,
    required ValueChanged<T> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A1020),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: items.map((item) {
          final isSelected = item.$1 == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(item.$1),
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0F1C30) : Colors.transparent,
                  border: isSelected
                      ? Border.all(color: const Color(0xFF00D4FF).withValues(alpha: 0.4))
                      : null,
                  borderRadius: BorderRadius.circular(7),
                ),
                alignment: Alignment.center,
                child: Text(
                  item.$2,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF00D4FF)
                        : Colors.white.withValues(alpha: 0.35),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
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

          // ── Atmosphere 배경 (숨김 처리 — _showAtmosphereSection = true 로 복원 가능) ──
          if (_showAtmosphereSection) ...[
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
          ],
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
          // ── 언어 ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SectionLabel(text: l10n.sectionLanguage),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0E1628),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                borderRadius: BorderRadius.circular(12),
              ),
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
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0E1628),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                borderRadius: BorderRadius.circular(12),
              ),
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
                    activeThumbColor: const Color(0xFF00D4FF),
                    activeTrackColor: const Color(0xFF00D4FF).withValues(alpha: 0.3),
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
                          _buildSegment<SoundPack>(
                            items: [
                              (SoundPack.basic, l10n.packBasic),
                              (SoundPack.clicky, l10n.packClicky),
                              (SoundPack.party, l10n.packParty),
                            ],
                            selected: _notifier.soundPack,
                            onChanged: (v) => _notifier.setSoundPack(v),
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
                    child: _buildSegment<HapticStrength>(
                      items: [
                        (HapticStrength.off, l10n.hapticOff),
                        (HapticStrength.light, l10n.hapticLight),
                        (HapticStrength.strong, l10n.hapticStrong),
                      ],
                      selected: _notifier.hapticStrength,
                      onChanged: (v) => _notifier.setHapticStrength(v),
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
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0E1628),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: _buildSegment<SpinDuration>(
                items: [
                  (SpinDuration.short, l10n.spinShort),
                  (SpinDuration.normal, l10n.spinNormal),
                  (SpinDuration.long, l10n.spinLong),
                ],
                selected: _notifier.spinDuration,
                onChanged: (v) => _notifier.setSpinDuration(v),
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
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0E1628),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                borderRadius: BorderRadius.circular(12),
              ),
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
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF00D4FF).withValues(alpha: 0.5)
                      : Colors.white.withValues(alpha: 0.07),
                  width: isSelected ? 2 : 1,
                ),
                color: Colors.white.withValues(alpha: 0.055),
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
                          decoration: const BoxDecoration(
                            color: Color(0xFF00D4FF),
                            shape: BoxShape.circle,
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


