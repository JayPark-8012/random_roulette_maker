import 'package:flutter/material.dart';
import '../../../core/app_themes.dart';
import '../../../core/constants.dart';
import '../../../data/premium_service.dart';
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
    final premiumService = PremiumService.instance;

    // Premium 제한 체크: 팔레트 사용
    if (!premiumService.canUsePalette(theme.id)) {
      _showPaletteLockDialog(context, theme, l10n);
      return;
    }

    // 기존 isLocked 체크 (호환성용)
    if (theme.isLocked) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.premiumThemeTitle),
          content: Text(l10n.premiumThemeContent),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.actionConfirm),
            ),
          ],
        ),
      );
      return;
    }

    _notifier.setThemeId(theme.id);
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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // ── 프리미엄 데모 위젯 ────────────────────────
          const PremiumDemoWidget(),

          // ── 테마 ──────────────────────────────────────
          _SectionHeader(title: l10n.sectionTheme),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── 화면 모드 (다크/라이트/시스템) ──────────
                  Text(
                    l10n.screenModeLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<AppThemeMode>(
                    expandedInsets: EdgeInsets.zero,
                    segments: [
                      ButtonSegment(
                        value: AppThemeMode.system,
                        label: Text(l10n.themeModeSystem),
                        icon: const Icon(Icons.brightness_auto_rounded),
                      ),
                      ButtonSegment(
                        value: AppThemeMode.light,
                        label: Text(l10n.themeModeLight),
                        icon: const Icon(Icons.light_mode_outlined),
                      ),
                      ButtonSegment(
                        value: AppThemeMode.dark,
                        label: Text(l10n.themeModeDark),
                        icon: const Icon(Icons.dark_mode_outlined),
                      ),
                    ],
                    selected: {_notifier.appThemeMode},
                    onSelectionChanged: (set) =>
                        _notifier.setAppThemeMode(set.first),
                    showSelectedIcon: false,
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  // ── 색상 팔레트 ──────────────────────────────
                  Text(
                    l10n.colorPaletteLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: AppThemes.all.length,
                    itemBuilder: (ctx, i) {
                      final theme = AppThemes.all[i];
                      return _ThemePreviewCard(
                        themeData: theme,
                        isSelected: theme.id == _notifier.themeId,
                        onTap: () => _selectTheme(context, theme),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // ── 언어 ──────────────────────────────────────
          _SectionHeader(title: l10n.sectionLanguage),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.language_rounded),
              title: Text(l10n.sectionLanguage),
              subtitle: Text(_currentLanguageName(l10n)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showLanguagePicker(context),
            ),
          ),
          // ── 피드백 ──────────────────────────────────
          _SectionHeader(title: l10n.sectionFeedback),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(l10n.soundLabel),
                  subtitle: Text(l10n.soundSubtitle),
                  secondary: Icon(
                    _notifier.soundEnabled
                        ? Icons.volume_up_outlined
                        : Icons.volume_off_outlined,
                  ),
                  value: _notifier.soundEnabled,
                  onChanged: _notifier.setSoundEnabled,
                ),
                if (_notifier.soundEnabled) ...[
                  const Divider(indent: 20, endIndent: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.soundPackLabel,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                const Divider(indent: 20, endIndent: 20),
                ListTile(
                  leading: const Icon(Icons.vibration),
                  title: Text(l10n.vibrationLabel),
                  subtitle: Text(l10n.vibrationSubtitle),
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
          // ── 스핀 시간 ────────────────────────────────
          _SectionHeader(title: l10n.sectionSpinTime),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                onSelectionChanged: (set) => _notifier.setSpinDuration(set.first),
                showSelectedIcon: false,
              ),
            ),
          ),
          // ── 앱 정보 ──────────────────────────────────
          _SectionHeader(title: l10n.sectionAppInfo),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.versionLabel),
                  trailing: Text(
                    '1.0.0 (MVP)',
                    style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
                const Divider(indent: 20, endIndent: 20),
                ListTile(
                  leading: const Icon(Icons.article_outlined),
                  title: Text(l10n.openSourceLabel),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: '랜덤 룰렛 메이커',
                    applicationVersion: '1.0.0',
                  ),
                ),
                const Divider(indent: 20, endIndent: 20),
                ListTile(
                  leading: const Icon(Icons.mail_outline),
                  title: Text(l10n.contactLabel),
                  trailing: const Icon(Icons.chevron_right),
                  // TODO(Phase3): url_launcher로 이메일 앱 실행
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.comingSoon)),
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

// ── 테마 프리뷰 카드 ─────────────────────────────────────
class _ThemePreviewCard extends StatelessWidget {
  final AppThemeData themeData;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemePreviewCard({
    required this.themeData,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outlineVariant,
            width: isSelected ? 2.5 : 1,
          ),
          color: isSelected
              ? cs.primary.withValues(alpha: 0.06)
              : cs.surfaceContainerLowest,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 색상 스와치 (팔레트 앞 5개)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: themeData.palette.take(5).map((c) {
                return Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  decoration: BoxDecoration(color: c, shape: BoxShape.circle),
                );
              }).toList(),
            ),
            const SizedBox(height: 6),
            if (themeData.isLocked)
              Icon(Icons.lock_outline, size: 13, color: cs.onSurfaceVariant)
            else if (isSelected)
              Icon(Icons.check_circle_rounded, size: 13, color: cs.primary)
            else
              const SizedBox(height: 13),
          ],
        ),
      ),
    );
  }
}

// ── 섹션 헤더 ────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
