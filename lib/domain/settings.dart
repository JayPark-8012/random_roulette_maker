enum SpinDuration { short, normal, long }
enum SoundPack { basic, clicky, party }
enum HapticStrength { off, light, strong }

/// 앱 화면 모드 (Flutter ThemeMode에 매핑됨)
enum AppThemeMode { system, light, dark }

class Settings {
  final bool soundEnabled;
  final SoundPack soundPack;
  final HapticStrength hapticStrength;
  final SpinDuration spinDuration;
  final String? lastUsedRouletteId;
  final String themeId;
  final AppThemeMode appThemeMode;

  const Settings({
    this.soundEnabled = true,
    this.soundPack = SoundPack.basic,
    this.hapticStrength = HapticStrength.light,
    this.spinDuration = SpinDuration.normal,
    this.lastUsedRouletteId,
    this.themeId = 'indigo',
    this.appThemeMode = AppThemeMode.system,
  });

  Settings copyWith({
    bool? soundEnabled,
    SoundPack? soundPack,
    HapticStrength? hapticStrength,
    SpinDuration? spinDuration,
    String? lastUsedRouletteId,
    String? themeId,
    AppThemeMode? appThemeMode,
    bool clearLastUsed = false,
  }) {
    return Settings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      soundPack: soundPack ?? this.soundPack,
      hapticStrength: hapticStrength ?? this.hapticStrength,
      spinDuration: spinDuration ?? this.spinDuration,
      lastUsedRouletteId:
          clearLastUsed ? null : (lastUsedRouletteId ?? this.lastUsedRouletteId),
      themeId: themeId ?? this.themeId,
      appThemeMode: appThemeMode ?? this.appThemeMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'soundEnabled': soundEnabled,
      'soundPack': soundPack.name,
      'hapticStrength': hapticStrength.name,
      'spinDuration': spinDuration.name,
      'lastUsedRouletteId': lastUsedRouletteId,
      'themeId': themeId,
      'appThemeMode': appThemeMode.name,
      'schemaVersion': 2,
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      soundPack: _parseSoundPack(json['soundPack'] as String?),
      hapticStrength: _parseHapticStrength(json),
      spinDuration: _parseSpinDuration(json),
      lastUsedRouletteId: json['lastUsedRouletteId'] as String?,
      themeId: json['themeId'] as String? ?? 'indigo',
      appThemeMode: _parseAppThemeMode(json['appThemeMode'] as String?),
    );
  }

  static SoundPack _parseSoundPack(String? raw) {
    return SoundPack.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => SoundPack.basic,
    );
  }

  static HapticStrength _parseHapticStrength(Map<String, dynamic> json) {
    final raw = json['hapticStrength'] as String?;
    if (raw != null) {
      return HapticStrength.values.firstWhere(
        (e) => e.name == raw,
        orElse: () => HapticStrength.light,
      );
    }
    // 이전 버전 호환: hapticEnabled bool
    final legacy = json['hapticEnabled'] as bool?
        ?? json['vibrationEnabled'] as bool?
        ?? true;
    return legacy ? HapticStrength.light : HapticStrength.off;
  }

  static SpinDuration _parseSpinDuration(Map<String, dynamic> json) {
    final raw = json['spinDuration'] as String?;
    if (raw != null) {
      return SpinDuration.values.firstWhere(
        (e) => e.name == raw,
        orElse: () => SpinDuration.normal,
      );
    }
    // 이전 버전 호환: spinSpeed 'fast' → short
    if ((json['spinSpeed'] as String?) == 'fast') return SpinDuration.short;
    return SpinDuration.normal;
  }

  static AppThemeMode _parseAppThemeMode(String? raw) {
    return AppThemeMode.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => AppThemeMode.system,
    );
  }
}
