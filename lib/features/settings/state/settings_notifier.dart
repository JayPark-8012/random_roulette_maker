import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Locale;
import '../../../core/app_themes.dart';
import '../../../core/utils.dart';
import '../../../data/settings_repository.dart';
import '../../../domain/settings.dart';

class SettingsNotifier extends ChangeNotifier {
  static final SettingsNotifier instance = SettingsNotifier._();
  SettingsNotifier._();

  final SettingsRepository _repo = SettingsRepository.instance;

  Settings _settings = const Settings();

  Settings get settings => _settings;
  bool get soundEnabled => _settings.soundEnabled;
  SoundPack get soundPack => _settings.soundPack;
  HapticStrength get hapticStrength => _settings.hapticStrength;
  SpinDuration get spinDuration => _settings.spinDuration;
  String? get lastUsedRouletteId => _settings.lastUsedRouletteId;
  String get themeId => _settings.themeId;
  String get localeCode => _settings.localeCode;
  String get wheelThemeId => _settings.wheelThemeId;
  String get atmosphereId => _settings.atmosphereId;

  /// localeCode → Flutter Locale 변환 (MaterialApp.locale에서 사용)
  /// null이면 시스템 언어를 따름
  Locale? get appLocale => switch (_settings.localeCode) {
        'en' => const Locale('en'),
        'ko' => const Locale('ko'),
        'es' => const Locale('es'),
        'pt-BR' => const Locale('pt', 'BR'),
        'ja' => const Locale('ja'),
        'zh-Hans' => const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
        _ => null,
      };

  Future<void> load() async {
    _settings = await _repo.load();
    _applyPalette();
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool value) async {
    _settings = _settings.copyWith(soundEnabled: value);
    await _repo.save(_settings);
    notifyListeners();
  }

  Future<void> setSoundPack(SoundPack value) async {
    _settings = _settings.copyWith(soundPack: value);
    await _repo.save(_settings);
    notifyListeners();
  }

  Future<void> setHapticStrength(HapticStrength value) async {
    _settings = _settings.copyWith(hapticStrength: value);
    await _repo.save(_settings);
    notifyListeners();
  }

  Future<void> setSpinDuration(SpinDuration value) async {
    _settings = _settings.copyWith(spinDuration: value);
    await _repo.save(_settings);
    notifyListeners();
  }

  Future<void> setThemeId(String id) async {
    _settings = _settings.copyWith(themeId: id);
    _applyPalette();
    await _repo.save(_settings);
    notifyListeners();
  }

  Future<void> setLocaleCode(String code) async {
    _settings = _settings.copyWith(localeCode: code);
    await _repo.save(_settings);
    notifyListeners();
  }

  Future<void> setWheelThemeId(String id) async {
    _settings = _settings.copyWith(wheelThemeId: id);
    await _repo.save(_settings);
    notifyListeners();
  }

  Future<void> setAtmosphereId(String id) async {
    _settings = _settings.copyWith(atmosphereId: id);
    await _repo.save(_settings);
    notifyListeners();
  }

  /// UI 알림 없이 조용히 저장 (Play 화면에서 lastUsed 갱신용)
  Future<void> setLastUsedRouletteId(String id) async {
    _settings = _settings.copyWith(lastUsedRouletteId: id);
    await _repo.save(_settings);
  }

  void _applyPalette() {
    AppUtils.activePalette = AppThemes.findById(_settings.themeId).palette;
  }
}
