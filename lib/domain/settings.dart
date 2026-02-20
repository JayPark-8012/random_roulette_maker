enum SpinSpeed { normal, fast }

class Settings {
  final bool soundEnabled;
  final bool hapticEnabled;
  final SpinSpeed spinSpeed;
  final String? lastUsedRouletteId;

  const Settings({
    this.soundEnabled = true,
    this.hapticEnabled = true,
    this.spinSpeed = SpinSpeed.normal,
    this.lastUsedRouletteId,
  });

  Settings copyWith({
    bool? soundEnabled,
    bool? hapticEnabled,
    SpinSpeed? spinSpeed,
    String? lastUsedRouletteId,
    bool clearLastUsed = false,
  }) {
    return Settings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      spinSpeed: spinSpeed ?? this.spinSpeed,
      lastUsedRouletteId:
          clearLastUsed ? null : (lastUsedRouletteId ?? this.lastUsedRouletteId),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'soundEnabled': soundEnabled,
      'hapticEnabled': hapticEnabled,
      'spinSpeed': spinSpeed.name,           // 'normal' | 'fast'
      'lastUsedRouletteId': lastUsedRouletteId,
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
    );
  }

  static SpinSpeed _parseSpinSpeed(String? raw) {
    return SpinSpeed.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => SpinSpeed.normal,
    );
  }
}
