import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

import 'core/bloc/app_observer.dart';
import 'core/di/injection.dart';
import 'core/hive/hive_initializer.dart';
import 'core/resources/app_locale.dart';
import 'core/resources/app_theme.dart';
import 'core/resources/localization/gen/app_localizations.dart';
import 'core/routes/init_router/init_router.dart';
import 'core/services/ui_message_service.dart';
import 'features/analytics/di/analytics_injection.dart';
import 'features/auth/di/auth_injection.dart';
import 'features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'features/category/di/category_injection.dart';
import 'features/category/domain/repositories/i_category_local_repository.dart';
import 'features/category/domain/use_cases/seed_categories_use_case.dart';
import 'features/category/presentation/bloc/categories_bloc/categories_bloc.dart';
import 'features/expense/di/expense_injection.dart';
import 'features/product/di/product_injection.dart';
import 'features/receipt/di/receipt_injection.dart';
import 'features/scanner/di/scanner_injection.dart';
import 'features/settings/di/settings_injection.dart';
import 'features/settings/domain/use_cases/save_settings_use_case.dart';
import 'features/settings/domain/use_cases/watch_settings_use_case.dart';
import 'features/settings/presentation/bloc/settings_bloc/settings_bloc.dart';
import 'features/store/di/store_injection.dart';
import 'features/store/domain/repositories/i_store_local_repository.dart';
import 'features/store/presentation/bloc/stores_bloc/stores_bloc.dart';

/// M4 bootstrap: the router lands (design_spendlens.md §5, 13 brick slices +
/// rename pass + one build_runner; DI resolves) and the four app-lifetime
/// blocs the spec names — `SettingsBloc` (M2), `CategoriesBloc`,
/// `StoresBloc`, `AuthBloc` — are all `registerLazySingleton` and dispatched
/// exactly once, HERE, never re-dispatched from a screen's `initState`
/// (BLoC rule A3.8). `SubscriptionBloc` is NOT registered yet — it lives
/// under `core/services/subscription/` and lands at M9 with the real Apphud
/// wiring (design_spendlens.md §6), so registering an empty shell of it now
/// would be dead infrastructure.
///
/// No splash/onboarding native assets yet (M10) — see `splash_page.dart`'s
/// doc comment for the exact M4→M10 boundary.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await initHive();
  await initDependencies();

  // Resolved BEFORE runApp — this is the value SettingsBloc is seeded with,
  // never left for an async fetch to deliver after the first frame.
  final initialSettings = await initSettingsFeature();

  // M3: the remaining data-layer slices. Each registers a repository only.
  await initCategoryFeature();
  initStoreFeature();
  initProductFeature();
  initReceiptFeature();
  initExpenseFeature();
  initAnalyticsFeature();
  initScannerFeature();

  // First-launch category seed (design_spendlens.md §7). THE GUARD IS
  // isEmpty && !dataCleared — never isEmpty alone, or a store the user
  // deliberately emptied via "Delete all records" would silently
  // repopulate on the next cold start
  // (~/.claude/rules/delete_all_records_rules.md).
  final categoryRepository = getIt<ICategoryLocalRepository>();
  final existingCategories = await categoryRepository.getAll();
  await getIt<SeedCategoriesUseCase>().call(
    isEmpty: existingCategories.isEmpty,
    dataCleared: initialSettings.dataCleared,
  );

  // M4: the app-lifetime blocs (design_spendlens.md §5).
  initAuthFeature();

  final settingsBloc = SettingsBloc(
    initialSettings: initialSettings,
    watchSettingsUseCase: getIt<WatchSettingsUseCase>(),
    saveSettingsUseCase: getIt<SaveSettingsUseCase>(),
  )..add(const SettingsEvent.watch());
  getIt.registerLazySingleton<SettingsBloc>(() => settingsBloc);

  final categoriesBloc = CategoriesBloc(
    categoryLocalRepository: getIt<ICategoryLocalRepository>(),
  )..add(const CategoriesEvent.watch());
  getIt.registerLazySingleton<CategoriesBloc>(() => categoriesBloc);

  final storesBloc = StoresBloc(
    storeLocalRepository: getIt<IStoreLocalRepository>(),
  )..add(const StoresEvent.watch());
  getIt.registerLazySingleton<StoresBloc>(() => storesBloc);

  final authBloc = getIt<AuthBloc>();

  Bloc.observer = AppObserver.instance();

  final router = initRouter(
    refreshListenable: GoRouterRefreshListenable(
      settingsBloc.stream.map((state) => state.settings.onboardingCompleted),
      onboardingCompleted: initialSettings.onboardingCompleted,
    ),
  );

  UiMessageService.attach(rootNavigatorKey);

  runApp(
    SpendLensApp(
      settingsBloc: settingsBloc,
      categoriesBloc: categoriesBloc,
      storesBloc: storesBloc,
      authBloc: authBloc,
      router: router,
    ),
  );
}

class SpendLensApp extends StatelessWidget {
  final SettingsBloc settingsBloc;
  final CategoriesBloc categoriesBloc;
  final StoresBloc storesBloc;
  final AuthBloc authBloc;
  final GoRouter router;

  const SpendLensApp({
    super.key,
    required this.settingsBloc,
    required this.categoriesBloc,
    required this.storesBloc,
    required this.authBloc,
    required this.router,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>.value(value: settingsBloc),
        BlocProvider<CategoriesBloc>.value(value: categoriesBloc),
        BlocProvider<StoresBloc>.value(value: storesBloc),
        BlocProvider<AuthBloc>.value(value: authBloc),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppThemeData.light,
            darkTheme: AppThemeData.dark,
            // Bound to persisted settings — never a hardcoded ThemeMode.
            // Recorded global bug: a picker that writes state nothing reads
            // leaves the UI looking wired while nothing actually changes.
            themeMode: state.resolvedThemeMode,
            // Bound to persisted settings; `null` correctly falls through to
            // WidgetsApp's own device-locale resolution (recorded global bug
            // `language-picker-writes-domain-field-materialapp-locale-never-bound`
            // — `locale:` must actually be wired, not merely have
            // `supportedLocales` declared beside an unrelated domain field).
            locale: state.resolvedLocale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocale.supportedLocales,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
