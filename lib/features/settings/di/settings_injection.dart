import '../../../core/di/injection.dart';
import '../data/repositories/settings_local_repository.dart';
import '../domain/models/app_settings/app_settings.dart';
import '../domain/repositories/i_settings_local_repository.dart';
import '../domain/use_cases/get_settings_use_case.dart';
import '../domain/use_cases/save_settings_use_case.dart';
import '../domain/use_cases/watch_settings_use_case.dart';
import '../presentation/bloc/settings_bloc/settings_bloc.dart';

/// Registers the settings slice's repository and use cases, and resolves
/// the persisted [AppSettings] SYNCHRONOUSLY (relative to `runApp`) so
/// `main()` can seed [SettingsBloc]'s initial state before the first frame —
/// see `settings_bloc.dart`'s doc comment for why this ordering matters.
///
/// `SettingsBloc` itself is registered by `main()` directly (not here),
/// because its constructor needs the already-resolved [AppSettings] value
/// that only `main()` has at that point.
Future<AppSettings> initSettingsFeature() async {
  getIt.registerLazySingleton<ISettingsLocalRepository>(
    () => SettingsLocalRepository(),
  );

  getIt.registerLazySingleton(
    () => GetSettingsUseCase(getIt<ISettingsLocalRepository>()),
  );
  getIt.registerLazySingleton(
    () => WatchSettingsUseCase(getIt<ISettingsLocalRepository>()),
  );
  getIt.registerLazySingleton(
    () => SaveSettingsUseCase(getIt<ISettingsLocalRepository>()),
  );

  return getIt<GetSettingsUseCase>().call();
}
