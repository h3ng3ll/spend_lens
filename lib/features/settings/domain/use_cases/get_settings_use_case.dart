import '../models/app_settings/app_settings.dart';
import '../repositories/i_settings_local_repository.dart';

/// One-shot read of the persisted [AppSettings] record.
class GetSettingsUseCase {
  final ISettingsLocalRepository _repository;

  const GetSettingsUseCase(this._repository);

  Future<AppSettings> call() => _repository.get();
}
