import 'package:flutter/material.dart';
import '../../../core/app_themes.dart';
import '../../../domain/settings.dart';
import '../state/settings_notifier.dart';

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

  void _selectTheme(AppThemeData theme) {
    if (theme.isLocked) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('프리미엄 테마'),
          content: const Text('이 테마는 프리미엄 기능입니다.\n업그레이드 후 사용하실 수 있습니다.'),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('확인'),
            ),
          ],
        ),
      );
      return;
    }
    _notifier.setThemeId(theme.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // ── 테마 ──────────────────────────────────────
          _SectionHeader(title: '테마'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── 화면 모드 (다크/라이트/시스템) ──────────
                  Text(
                    '화면 모드',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<AppThemeMode>(
                    expandedInsets: EdgeInsets.zero,
                    segments: const [
                      ButtonSegment(
                        value: AppThemeMode.system,
                        label: Text('시스템'),
                        icon: Icon(Icons.brightness_auto_rounded),
                      ),
                      ButtonSegment(
                        value: AppThemeMode.light,
                        label: Text('라이트'),
                        icon: Icon(Icons.light_mode_outlined),
                      ),
                      ButtonSegment(
                        value: AppThemeMode.dark,
                        label: Text('다크'),
                        icon: Icon(Icons.dark_mode_outlined),
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
                    '색상 팔레트',
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
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: AppThemes.all.length,
                    itemBuilder: (ctx, i) {
                      final theme = AppThemes.all[i];
                      return _ThemePreviewCard(
                        themeData: theme,
                        isSelected: theme.id == _notifier.themeId,
                        onTap: () => _selectTheme(theme),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // ── 피드백 ──────────────────────────────────
          _SectionHeader(title: '피드백'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('사운드'),
                  subtitle: const Text('스핀 및 결과 효과음'),
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
                          '사운드 팩',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 8),
                        SegmentedButton<SoundPack>(
                          expandedInsets: EdgeInsets.zero,
                          segments: const [
                            ButtonSegment(
                              value: SoundPack.basic,
                              label: Text('기본'),
                            ),
                            ButtonSegment(
                              value: SoundPack.clicky,
                              label: Text('클리키'),
                            ),
                            ButtonSegment(
                              value: SoundPack.party,
                              label: Text('파티'),
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
                const ListTile(
                  leading: Icon(Icons.vibration),
                  title: Text('진동(햅틱)'),
                  subtitle: Text('결과 발표 시 진동'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: SegmentedButton<HapticStrength>(
                    expandedInsets: EdgeInsets.zero,
                    segments: const [
                      ButtonSegment(
                        value: HapticStrength.off,
                        label: Text('없음'),
                      ),
                      ButtonSegment(
                        value: HapticStrength.light,
                        label: Text('약하게'),
                      ),
                      ButtonSegment(
                        value: HapticStrength.strong,
                        label: Text('강하게'),
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
          _SectionHeader(title: '스핀 시간'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SegmentedButton<SpinDuration>(
                expandedInsets: EdgeInsets.zero,
                segments: const [
                  ButtonSegment(
                    value: SpinDuration.short,
                    label: Text('짧게 (2초)'),
                    icon: Icon(Icons.flash_on_outlined),
                  ),
                  ButtonSegment(
                    value: SpinDuration.normal,
                    label: Text('기본 (4.5초)'),
                    icon: Icon(Icons.speed),
                  ),
                  ButtonSegment(
                    value: SpinDuration.long,
                    label: Text('길게 (7초)'),
                    icon: Icon(Icons.hourglass_empty_rounded),
                  ),
                ],
                selected: {_notifier.spinDuration},
                onSelectionChanged: (set) => _notifier.setSpinDuration(set.first),
                showSelectedIcon: false,
              ),
            ),
          ),
          // ── 앱 정보 ──────────────────────────────────
          _SectionHeader(title: '앱 정보'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('버전'),
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
                  title: const Text('오픈소스 라이선스'),
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
                  title: const Text('문의하기'),
                  trailing: const Icon(Icons.chevron_right),
                  // TODO(Phase3): url_launcher로 이메일 앱 실행
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('준비 중입니다.')),
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
            Text(
              themeData.name,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 2),
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
