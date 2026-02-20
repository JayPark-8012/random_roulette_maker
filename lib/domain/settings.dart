enum SpinSpeed { normal, fast }

class Settings {
  final bool soundEnabled;
  final bool hapticEnabled;
  final SpinSpeed spinSpeed;
  final String? lastUsedRouletteId;
  final String themeId;

  const Settings({
    this.soundEnabled = true,
    this.hapticEnabled = true,
    this.spinSpeed = SpinSpeed.normal,
    this.lastUsedRouletteId,
    this.themeId = 'indigo',
  });

  Settings copyWith({
    bool? soundEnabled,
    bool? hapticEnabled,
    SpinSpeed? spinSpeed,
    String? lastUsedRouletteId,
    String? themeId,
    bool clearLastUsed = false,
  }) {
    return Settings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      spinSpeed: spinSpeed ?? this.spinSpeed,
      lastUsedRouletteId:
          clearLastUsed ? null : (lastUsedRouletteId ?? this.lastUsedRouletteId),
      themeId: themeId ?? this.themeId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'soundEnabled': soundEnabled,
      'hapticEnabled': hapticEnabled,
      'spinSpeed': spinSpeed.name,           // 'normal' | 'fast'
      'lastUsedRouletteId': lastUsedRouletteId,
      'themeId': themeId,
      'schemaVersion': 1,
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      hapticEnabled: json['hapticEnabled'] as bool?
          ?? json['vibrationEnabled'] as bool? // 이전 키 하위 호환
          ?? true,
      spinSpeed: _parseSpinSpeed(json['spinSpeed'] as String?),
      lastUsedRouletteId: json['lastUsedRouletteId'] as String?,
      themeId: json['themeId'] as String? ?? 'indigo',
    );
  }

  static SpinSpeed _parseSpinSpeed(String? raw) {
    return SpinSpeed.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => SpinSpeed.normal,
    );
  }
}
