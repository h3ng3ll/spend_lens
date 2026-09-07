import 'package:hive_ce/hive.dart';

import '../../domain/models/app_settings/app_settings.dart';
import '../../domain/repositories/i_settings_local_repository.dart';

/// Hive-backed [ISettingsLocalRepository].
///
/// Box name is plural lowercase (`'settings'`) per hive_rules.md §5; the box
/// is never cached — every operation calls `Hive.openBox` directly (Hive
/// de-duplicates opens, so this costs nothing and keeps `box.watch()`
/// reactive — recorded global bug `hive-getbox-cache-breaks-watch`).
///
/// Registered as a lazy singleton by hand in `settings_injection.dart` — this
/// project's DI is plain `get_it` (no `injectable` codegen), matching M1's
/// `core/di/injection.dart`.
class SettingsLocalRepository implements ISettingsLocalRepository {
  static const _boxName = 'settings';

  Future<Box<AppSettings>> get _box => Hive.openBox<AppSettings>(_boxName);

  @override
  Future<AppSettings> get() async {
    final box = await _box;
    return box.get(ISettingsLocalRepository.settingsKey) ?? const AppSettings();
  }

  @override
  Stream<AppSettings> watch() async* {
    final box = await _box;
    yield box.get(ISettingsLocalRepository.settingsKey) ?? const AppSettings();
    yield* box
        .watch(key: ISettingsLocalRepository.settingsKey)
        .map(
          (_) =>
              box.get(ISettingsLocalRepository.settingsKey) ??
              const AppSettings(),
        );
  }

  @override
  Future<void> save(AppSettings settings) async {
    final box = await _box;
    await box.put(ISettingsLocalRepository.settingsKey, settings);
  }
}
