import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/app_themes.dart';
import '../../../core/atmosphere_presets.dart';
import '../../../core/constants.dart';
import '../../../core/widgets/app_background.dart';
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

          // ── 테마 ──────────────────────────────────────
          _SectionHeader(title: l10n.sectionTheme),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Atmosphere 배경 ──────────────────────────
                  Text(
                    l10n.atmosphereLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<PremiumState>(
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
                  // 프리미엄 전환 직후 즉시 갱신을 위해 ValueListenableBuilder 사용
                  ValueListenableBuilder<PremiumState>(
                    valueListenable: PremiumService.instance.stateNotifier,
                    builder: (ctx, ps, child) => GridView.builder(
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
                          // 프리미엄이면 잠금 없음, 무료면 정적 플래그로 판단
                          isLocked: !ps.isPremium && theme.isLocked,
                          onTap: () => _selectTheme(context, theme),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  // ── 룰렛 휠 테마 ─────────────────────────────
                  Text(
                    l10n.wheelThemeLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<PremiumState>(
                    valueListenable: PremiumService.instance.stateNotifier,
                    builder: (ctx, ps, child) => GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 0.82,
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
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: atmosphere.gradient,
          color: atmosphere.gradient == null ? atmosphere.solidColor : null,
          border: Border.all(
            color: isSelected ? cs.primary : Colors.white.withValues(alpha: 0.15),
            width: isSelected ? 2.5 : 1,
          ),
        ),
        child: Stack(
          children: [
            // 이름 + 상태 아이콘
            Positioned(
              left: 10,
              bottom: 8,
              child: Text(
                atmosphere.name,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: isLocked
                  ? Icon(Icons.lock_outline,
                      size: 14, color: Colors.white.withValues(alpha: 0.5))
                  : isSelected
                      ? Icon(Icons.check_circle_rounded,
                          size: 14, color: cs.primary)
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 테마 프리뷰 카드 ─────────────────────────────────────
class _ThemePreviewCard extends StatelessWidget {
  final AppThemeData themeData;
  final bool isSelected;
  /// 동적 잠금 여부: !isPremium && theme.isLocked 로 caller가 전달
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
            if (isLocked)
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
            CustomPaint(
              painter: _MiniWheelPreviewPainter(
                palette: wheelTheme.palette,
                style: wheelTheme.style,
              ),
              size: const Size(44, 44),
            ),
            const SizedBox(height: 4),
            Text(
              wheelTheme.name,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? cs.primary : cs.onSurface,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
            if (isLocked)
              Icon(Icons.lock_outline, size: 11, color: cs.onSurfaceVariant)
            else if (isSelected)
              Icon(Icons.check_circle_rounded, size: 11, color: cs.primary)
            else
              const SizedBox(height: 11),
          ],
        ),
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
