import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../../core/utils.dart';
import '../../../data/roulette_repository.dart';
import '../../../data/settings_repository.dart';
import '../../../domain/history.dart';
import '../../../domain/item.dart';
import '../../../domain/roulette.dart';
import '../../../domain/settings.dart';

enum SpinState { idle, spinning, done }

class PlayNotifier extends ChangeNotifier {
  final RouletteRepository _repo = RouletteRepository.instance;
  final SettingsRepository _settingsRepo = SettingsRepository.instance;

  Roulette? _roulette;
  SpinState _spinState = SpinState.idle;
  Item? _result;
  List<History> _history = [];
  Settings _settings = const Settings();

  Roulette? get roulette => _roulette;
  SpinState get spinState => _spinState;
  Item? get result => _result;
  List<History> get history => List.unmodifiable(_history);
  bool get isSpinning => _spinState == SpinState.spinning;
  Settings get settings => _settings;

  Future<void> load(String rouletteId) async {
    _roulette = await _repo.getById(rouletteId);
    _settings = await _settingsRepo.load();
    _spinState = SpinState.idle;
    _result = null;
    _history = await _repo.getHistory(rouletteId);
    notifyListeners();
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
    notifyListeners();

    // 햅틱 피드백 (Settings 연동)
    if (_settings.hapticEnabled) {
      HapticFeedback.mediumImpact();
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

      // lastUsedRouletteId 갱신
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
