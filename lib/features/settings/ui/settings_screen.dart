import 'package:flutter/material.dart';
import '../../../domain/settings.dart';
import '../state/settings_notifier.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsNotifier _notifier = SettingsNotifier();

  @override
  void initState() {
    super.initState();
    _notifier.load();
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: AnimatedBuilder(
        animation: _notifier,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
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
                    onSelectionChanged: (set) =>
                        _notifier.setSpinSpeed(set.first),
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
                            color: Theme.of(context).colorScheme.onSurfaceVariant),
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
          );
        },
      ),
    );
  }
}

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
