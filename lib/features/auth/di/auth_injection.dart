import '../../../core/di/injection.dart';
import '../presentation/bloc/auth_bloc/auth_bloc.dart';

/// Registers [AuthBloc] as the app-lifetime singleton design_spendlens.md §5
/// names (`registerLazySingleton`). Unlike `SettingsBloc`/`CategoriesBloc`/
/// `StoresBloc`, this bloc has no repository to seed from yet — it is
/// dispatched from nowhere because it has no events yet (M4 skeleton; M9
/// adds the real sign-in flow, still registered here).
void initAuthFeature() {
  getIt.registerLazySingleton<AuthBloc>(() => AuthBloc());
}
