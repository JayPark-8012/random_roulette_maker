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
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                const Divider(indent: 20, endIndent: 20),
                SwitchListTile(
                  title: const Text('진동(햅틱)'),
                  subtitle: const Text('결과 발표 시 진동'),
                  secondary: const Icon(Icons.vibration),
                  value: _notifier.hapticEnabled,
                  onChanged: _notifier.setHapticEnabled,
                ),
              ],
            ),
          ),
          // ── 스핀 속도 ────────────────────────────────
          _SectionHeader(title: '스핀 속도'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SegmentedButton<SpinSpeed>(
                expandedInsets: EdgeInsets.zero,
                segments: const [
                  ButtonSegment(
                    value: SpinSpeed.normal,
                    label: Text('기본 (3~5초)'),
                    icon: Icon(Icons.speed),
                  ),
                  ButtonSegment(
                    value: SpinSpeed.fast,
                    label: Text('빠름 (1~2초)'),
                    icon: Icon(Icons.flash_on_outlined),
                  ),
                ],
                selected: {_notifier.spinSpeed},
                onSelectionChanged: (set) => _notifier.setSpinSpeed(set.first),
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
