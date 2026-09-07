import '../models/app_settings/app_settings.dart';
import '../repositories/i_settings_local_repository.dart';

/// Persists a full [AppSettings] record.
class SaveSettingsUseCase {
  final ISettingsLocalRepository _repository;

  const SaveSettingsUseCase(this._repository);

  Future<void> call(AppSettings settings) => _repository.save(settings);
}
