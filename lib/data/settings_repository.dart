import '../core/constants.dart';
import '../domain/settings.dart';
import 'local_storage.dart';

class SettingsRepository {
  SettingsRepository._();
  static final SettingsRepository instance = SettingsRepository._();

  final LocalStorage _storage = LocalStorage.instance;

  Future<Settings> load() async {
    final map = await _storage.getJsonMap(StorageKeys.settings);
    if (map == null) return const Settings();
    return Settings.fromJson(map);
  }

  Future<void> save(Settings settings) async {
    await _storage.setJsonMap(StorageKeys.settings, settings.toJson());
  }
}
