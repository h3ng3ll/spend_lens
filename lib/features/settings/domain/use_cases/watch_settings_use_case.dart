import '../models/app_settings/app_settings.dart';
import '../repositories/i_settings_local_repository.dart';

/// Reactive stream of the persisted [AppSettings] record — current value,
/// then every subsequent write.
class WatchSettingsUseCase {
  final ISettingsLocalRepository _repository;

  const WatchSettingsUseCase(this._repository);

  Stream<AppSettings> call() => _repository.watch();
}
