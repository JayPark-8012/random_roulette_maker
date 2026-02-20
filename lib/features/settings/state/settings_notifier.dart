import 'package:flutter/foundation.dart';
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
  bool get hapticEnabled => _settings.hapticEnabled;
  SpinSpeed get spinSpeed => _settings.spinSpeed;
  String? get lastUsedRouletteId => _settings.lastUsedRouletteId;
  String get themeId => _settings.themeId;

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

  Future<void> setHapticEnabled(bool value) async {
    _settings = _settings.copyWith(hapticEnabled: value);
    await _repo.save(_settings);
    notifyListeners();
  }

  Future<void> setSpinSpeed(SpinSpeed value) async {
    _settings = _settings.copyWith(spinSpeed: value);
    await _repo.save(_settings);
    notifyListeners();
  }

  Future<void> setThemeId(String id) async {
    _settings = _settings.copyWith(themeId: id);
    _applyPalette();
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
