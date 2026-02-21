import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../data/local_storage.dart';
import '../../../data/roulette_repository.dart';
import '../../../data/settings_repository.dart';
import '../../../domain/history.dart';
import '../../../domain/item.dart';
import '../../../domain/roulette.dart';
import '../../../domain/settings.dart';

enum SpinState { idle, spinning, done }

/// 스핀 모드: 추첨/탈락전/라운드/Custom
enum SpinMode { lottery, elimination, round, custom }

class PlayNotifier extends ChangeNotifier {
  final RouletteRepository _repo = RouletteRepository.instance;
  final SettingsRepository _settingsRepo = SettingsRepository.instance;

  Roulette? _roulette;
  SpinState _spinState = SpinState.idle;
  Item? _result;
  List<History> _history = [];
  Settings _settings = const Settings();

  // ── 중복 제외 모드 ────────────────────────────────────
  bool _noRepeat = false;
  bool _autoReset = false;
  Set<String> _excludedIds = {};
  SpinMode _spinMode = SpinMode.lottery;
  int _roundNum = 1;

  Roulette? get roulette => _roulette;
  SpinState get spinState => _spinState;
  Item? get result => _result;
  List<History> get history => List.unmodifiable(_history);
  bool get isSpinning => _spinState == SpinState.spinning;
  Settings get settings => _settings;
  bool get noRepeat => _noRepeat;
  bool get autoReset => _autoReset;
  SpinMode get spinMode => _spinMode;
  int get roundNum => _roundNum;
  int get remainingCount =>
      (_roulette?.items.length ?? 0) - _excludedIds.length;

  /// noRepeat ON이면 뽑힌 항목 제외, OFF면 전체 반환
  List<Item> get availableItems {
    if (!_noRepeat || _roulette == null) return _roulette?.items ?? [];
    return _roulette!.items
        .where((i) => !_excludedIds.contains(i.id))
        .toList();
  }

  /// noRepeat ON이고 모든 항목이 뽑혔으면 true
  bool get allPicked =>
      _noRepeat &&
      _roulette != null &&
      _excludedIds.length >= _roulette!.items.length;

  SpinMode _modeFromToggles() {
    if (!_noRepeat && !_autoReset) return SpinMode.lottery;
    if (_noRepeat && _autoReset) return SpinMode.round;
    return SpinMode.custom; // noRepeat=true,autoReset=false 포함
  }

  Future<void> load(String rouletteId) async {
    _roulette = await _repo.getById(rouletteId);
    _settings = await _settingsRepo.load();
    _spinState = SpinState.idle;
    _result = null;
    _history = await _repo.getHistory(rouletteId);

    // 스핀 모드 로드 (재시작 후에도 유지)
    final modeData = await LocalStorage.instance
        .getJsonMap(StorageKeys.spinModeKey(rouletteId));
    if (modeData != null) {
      _noRepeat = modeData['noRepeat'] as bool? ?? false;
      _autoReset = modeData['autoReset'] as bool? ?? false;
      final ids = (modeData['excludedIds'] as List?)?.cast<String>() ?? [];
      _excludedIds = Set.from(ids);
      _roundNum = modeData['roundNum'] as int? ?? 1;
    } else {
      _noRepeat = false;
      _autoReset = false;
      _excludedIds = {};
      _roundNum = 1;
    }
    _spinMode = _modeFromToggles();

    notifyListeners();
  }

  /// 모드 선택: lottery/round는 토글 동기화 + 초기화, custom은 토글 유지
  void setSpinMode(SpinMode mode) {
    if (mode == SpinMode.custom) {
      _spinMode = SpinMode.custom;
      _saveSpinMode();
      notifyListeners();
      return;
    }
    _spinMode = mode;
    if (mode == SpinMode.lottery) {
      _noRepeat = false;
      _autoReset = false;
    } else if (mode == SpinMode.elimination) {
      _noRepeat = true;
      _autoReset = false;
    } else if (mode == SpinMode.round) {
      _noRepeat = true;
      _autoReset = true;
    }
    _excludedIds.clear();
    _roundNum = 1;
    _saveSpinMode();
    notifyListeners();
  }

  void setNoRepeat(bool v) {
    _noRepeat = v;
    if (!v) _autoReset = false;
    _spinMode = _modeFromToggles();
    _saveSpinMode();
    notifyListeners();
  }

  void setAutoReset(bool v) {
    _autoReset = v;
    _spinMode = _modeFromToggles();
    _saveSpinMode();
    notifyListeners();
  }

  Future<void> resetExcluded() async {
    _excludedIds.clear();
    _roundNum = 1;
    await _saveSpinMode();
    notifyListeners();
  }

  Future<void> _saveSpinMode() async {
    if (_roulette == null) return;
    await LocalStorage.instance.setJsonMap(
      StorageKeys.spinModeKey(_roulette!.id),
      {
        'noRepeat': _noRepeat,
        'autoReset': _autoReset,
        'excludedIds': _excludedIds.toList(),
        'roundNum': _roundNum,
      },
    );
  }

  void startSpin() {
    if (_spinState == SpinState.spinning) return;
    _spinState = SpinState.spinning;
    _result = null;
    notifyListeners();
  }

  Future<void> finishSpin(Item winner) async {
    _result = winner;
    _spinState = SpinState.done;

    // 중복 제외: 당첨 항목 추가
    if (_noRepeat) {
      _excludedIds.add(winner.id);
      // 자동 리셋: 모두 뽑혔으면 즉시 초기화 + 라운드 카운트 증가
      if (_autoReset &&
          _excludedIds.length >= (_roulette?.items.length ?? 0)) {
        _excludedIds.clear();
        _roundNum++;
      }
      await _saveSpinMode();
    }

    notifyListeners();

    // TODO(Phase2): audioplayers 패키지 추가 후 _settings.soundPack 기반 효과음 재생
    // 햅틱 피드백
    if (_settings.hapticStrength == HapticStrength.light) {
      HapticFeedback.lightImpact();
    } else if (_settings.hapticStrength == HapticStrength.strong) {
      HapticFeedback.heavyImpact();
    }

    // 히스토리 저장 + lastPlayedAt 갱신
    if (_roulette != null) {
      final entry = History(
        id: AppUtils.generateId(),
        rouletteId: _roulette!.id,
        resultLabel: winner.label,
        resultColorValue: winner.colorValue,
        playedAt: DateTime.now(),
      );
      await _repo.addHistory(entry);
      await _repo.updateLastPlayed(_roulette!.id);

      final updated =
          _settings.copyWith(lastUsedRouletteId: _roulette!.id);
      await _settingsRepo.save(updated);

      _history = await _repo.getHistory(_roulette!.id);
      notifyListeners();
    }
  }

  void resetSpin() {
    _spinState = SpinState.idle;
    _result = null;
    notifyListeners();
  }
}
