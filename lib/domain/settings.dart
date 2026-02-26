enum SpinDuration { short, normal, long }
enum SoundPack { basic, clicky, party }
enum HapticStrength { off, light, strong }

class Settings {
  final bool soundEnabled;
  final SoundPack soundPack;
  final HapticStrength hapticStrength;
  final SpinDuration spinDuration;
  final String? lastUsedRouletteId;
  final String themeId;
  /// 'system' | 'en' | 'ko' | 'es' | 'pt-BR' | 'ja' | 'zh-Hans'
  final String localeCode;
  /// 룰렛 휠 테마 ID (RouletteWheelThemes 참조)
  final String wheelThemeId;
  /// Atmosphere 배경 프리셋 ID
  final String atmosphereId;

  const Settings({
    this.soundEnabled = true,
    this.soundPack = SoundPack.basic,
    this.hapticStrength = HapticStrength.light,
    this.spinDuration = SpinDuration.normal,
    this.lastUsedRouletteId,
    this.themeId = 'indigo',
    this.localeCode = 'system',
    this.wheelThemeId = 'classic',
    this.atmosphereId = 'deep_space',
  });

  Settings copyWith({
    bool? soundEnabled,
    SoundPack? soundPack,
    HapticStrength? hapticStrength,
    SpinDuration? spinDuration,
    String? lastUsedRouletteId,
    String? themeId,
    bool clearLastUsed = false,
    String? localeCode,
    String? wheelThemeId,
    String? atmosphereId,
  }) {
    return Settings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      soundPack: soundPack ?? this.soundPack,
      hapticStrength: hapticStrength ?? this.hapticStrength,
      spinDuration: spinDuration ?? this.spinDuration,
      lastUsedRouletteId:
          clearLastUsed ? null : (lastUsedRouletteId ?? this.lastUsedRouletteId),
      themeId: themeId ?? this.themeId,
      localeCode: localeCode ?? this.localeCode,
      wheelThemeId: wheelThemeId ?? this.wheelThemeId,
      atmosphereId: atmosphereId ?? this.atmosphereId,
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
      'localeCode': localeCode,
      'wheelThemeId': wheelThemeId,
      'atmosphereId': atmosphereId,
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
      localeCode: json['localeCode'] as String? ?? 'system',
      wheelThemeId: json['wheelThemeId'] as String? ?? 'classic',
      atmosphereId: json['atmosphereId'] as String? ?? 'deep_space',
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
}
