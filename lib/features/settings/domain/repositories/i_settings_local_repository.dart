import '../models/app_settings/app_settings.dart';

/// Contract for the single persisted [AppSettings] record.
///
/// One repository per model (hive_rules.md §5) — this repository owns
/// `AppSettings` only.
abstract interface class ISettingsLocalRepository {
  /// The fixed key every read/write uses. There is exactly one
  /// [AppSettings] record app-wide.
  static const settingsKey = 'app_settings';

  /// One-shot read, defaulting to `const AppSettings()` when nothing has
  /// been persisted yet (fresh install).
  Future<AppSettings> get();

  /// Reactive read — current value, then re-emits on every write. Bloc
  /// subscribes via `emit.forEach` (hive_rules.md §6/§9).
  Stream<AppSettings> watch();

  Future<void> save(AppSettings settings);
}
