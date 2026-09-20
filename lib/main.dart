import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';

import 'core/bloc/app_observer.dart';
import 'core/di/injection.dart';
import 'features/sync/di/sync_injection.dart';
import 'features/sync/presentation/bloc/sync_bloc/sync_bloc.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/firebase/firebase_firestore_service.dart';
import 'core/services/logger_service.dart';
import 'core/hive/hive_initializer.dart';
import 'core/resources/app_locale.dart';
import 'core/resources/app_theme.dart';
import 'core/resources/localization/gen/app_localizations.dart';
import 'core/routes/init_router/init_router.dart';
import 'core/services/subscription/i_subscription_repository.dart';
import 'core/services/ui_message_service.dart';
import 'core/utils/env/env.dart';
import 'features/analytics/di/analytics_injection.dart';
import 'features/auth/di/auth_injection.dart';
import 'features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'features/backup/di/backup_injection.dart';
import 'features/report/di/report_injection.dart';
import 'features/subscription/di/subscription_injection.dart';
import 'features/category/di/category_injection.dart';
import 'features/category/domain/repositories/i_category_local_repository.dart';
import 'features/category/domain/use_cases/seed_categories_use_case.dart';
import 'features/category/presentation/bloc/categories_bloc/categories_bloc.dart';
import 'features/expense/di/expense_injection.dart';
import 'features/expense/domain/repositories/i_expense_local_repository.dart';
import 'features/product/di/product_injection.dart';
import 'features/receipt/di/receipt_injection.dart';
import 'features/scanner/di/scanner_injection.dart';
import 'features/settings/di/settings_injection.dart';
import 'features/settings/domain/use_cases/delete_all_records_use_case.dart';
import 'features/settings/domain/use_cases/save_settings_use_case.dart';
import 'features/settings/domain/use_cases/watch_settings_use_case.dart';
import 'features/settings/presentation/bloc/settings_bloc/settings_bloc.dart';
import 'features/store/di/store_injection.dart';
import 'features/store/domain/repositories/i_store_local_repository.dart';
import 'features/store/domain/use_cases/delete_store_use_case.dart';
import 'features/analytics/domain/repositories/i_price_observation_local_repository.dart';
import 'core/services/product_image_store/product_image_store.dart';
import 'features/product/domain/repositories/i_product_local_repository.dart';
import 'features/product/domain/use_cases/save_product_image_use_case.dart';
import 'features/product/domain/use_cases/split_legacy_products_use_case.dart';
import 'features/settings/domain/repositories/i_settings_local_repository.dart';
import 'features/product/presentation/bloc/products_bloc/products_bloc.dart';
import 'features/store/presentation/bloc/stores_bloc/stores_bloc.dart';
import 'firebase_options.dart';

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
/// M10 → post-M10 correction: the native splash is preserved here in
/// `main()`, and released exactly once from `_SpendLensAppState.initState()`
/// below (`~/.claude/rules/splash_screen_rules.md`).
///
/// DEVIATION FROM THE RULES FILE'S LETTER, IN SERVICE OF ITS INTENT: the
/// rules file names the splash SCREEN's `initState()` as `remove()`'s home,
/// on the assumption that screen is actually built. In this project it is
/// not — `resolveRedirect` (`init_router/init_router.dart`) is a PURE,
/// synchronous function of `onboardingCompleted`, evaluated by GoRouter on
/// its very first navigation to `initialLocation: '/'`, and it redirects
/// away in BOTH branches before `SplashPageRoute.buildPage` (and therefore
/// any splash widget's `initState`) is ever invoked. A `remove()` placed
/// there is provably unreachable: the native splash would never lift, and
/// the Android launch image would hang forever with a clean logcat — this
/// was confirmed on-device (`dumpsys SurfaceFlinger` still showing the
/// splash layer on top 20+ seconds after launch, with Flutter's SurfaceView
/// present but never revealed underneath).
///
/// `SpendLensApp` is the correct owner instead: it is the ROOT widget passed
/// to `runApp`, so its `initState()` is the earliest point in the widget
/// tree that is GUARANTEED to run on every cold start, before GoRouter
/// evaluates any redirect and before the first frame paints — identical in
/// spirit to the rules file's requirement, just anchored one level higher
/// because this project's splash route can never be the one that runs.
/// `resolveRedirect` remains the app's ONE navigation authority; this file
/// makes no routing decision of its own. See `_SpendLensAppState.initState`
/// below for the call itself, and
/// `test/regression/splash_native_remove_test.dart` for the updated gate
/// that now asserts THIS contract.
///
/// This file calls `preserve()` and ONLY `preserve()` — `remove()` lives
/// solely in `_SpendLensAppState.initState()`.
void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(
    widgetsBinding: widgetsBinding,
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: '.env');

  await initHive();
  await initDependencies();

  // Firestore's local write queue, enabled explicitly so the offline
  // contract is a recorded decision rather than a platform default: a write
  // made with no connection is queued and replayed on reconnect.
  getIt<FirebaseFirestoreService>().configure();

  // Seeded BEFORE runApp so the first frame already knows the real network
  // state and the sync row cannot flash a false "Offline" on a cold start.
  await getIt<ConnectivityService>().init();

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
  initBackupFeature();
  initReportFeature();
  initSubscriptionFeature();

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

  // One-shot per-store product split. Products gained an owning store, but
  // every product created before that stayed store-less and was therefore
  // listed under every store it was ever bought at, mixing several stores'
  // prices into one page and one inflation curve.
  //
  // Guarded by a flag purely to avoid re-reading whole collections on every
  // launch — the use case is idempotent on its own, so a lost flag costs a
  // wasted pass, never a double split. A failure here must not block launch:
  // the app is fully usable on unsplit data, just with the old mixing.
  if (!initialSettings.productsSplitCompleted) {
    try {
      await getIt<SplitLegacyProductsUseCase>().call();
      await getIt<ISettingsLocalRepository>().save(
        (await getIt<ISettingsLocalRepository>().get()).copyWith(
          productsSplitCompleted: true,
        ),
      );
    } catch (error, stackTrace) {
      getIt<LoggerService>().error(
        'Per-store product split failed',
        error: error,
        stackTrace: stackTrace,
        name: 'Migration',
      );
    }
  }

  // M9: the app-lifetime auth bloc (design_spendlens.md §5/§9). Firebase
  // init failure is caught INSIDE initAuthFeature() — this never throws.
  final isFirebaseReady = await initAuthFeature();

  // AFTER the seven record slices (whose repositories it resolves) and after
  // auth (whose Firebase probe decides the remote repository).
  initSyncFeature(isFirebaseReady: isFirebaseReady);

  // M9: Apphud subscription check (design_spendlens.md §6/§9). An empty
  // API key is a disabled feature — `init()` never throws.
  final subscriptionRepository = getIt<ISubscriptionRepository>();
  await subscriptionRepository.init(getIt<Env>());

  // BEFORE any bloc is constructed. Installed after them, the observer
  // missed `AuthBloc` and `SyncBloc` entirely — both are built here and
  // dispatch their `watch()` immediately, so every event and transition
  // they made was invisible in the logs. That cost real diagnostic signal:
  // a silent sync looked identical to a dead one.
  Bloc.observer = AppObserver.instance();

  final settingsBloc = SettingsBloc(
    initialSettings: initialSettings,
    watchSettingsUseCase: getIt<WatchSettingsUseCase>(),
    saveSettingsUseCase: getIt<SaveSettingsUseCase>(),
    deleteAllRecordsUseCase: getIt<DeleteAllRecordsUseCase>(),
    expenseLocalRepository: getIt<IExpenseLocalRepository>(),
    storeLocalRepository: getIt<IStoreLocalRepository>(),
    categoryLocalRepository: getIt<ICategoryLocalRepository>(),
  )..add(const SettingsEvent.watch());
  getIt.registerLazySingleton<SettingsBloc>(() => settingsBloc);

  final categoriesBloc = CategoriesBloc(
    categoryLocalRepository: getIt<ICategoryLocalRepository>(),
  )..add(const CategoriesEvent.watch());
  getIt.registerLazySingleton<CategoriesBloc>(() => categoriesBloc);

  final storesBloc = StoresBloc(
    storeLocalRepository: getIt<IStoreLocalRepository>(),
    deleteStore: getIt<DeleteStoreUseCase>(),
  )..add(const StoresEvent.watch());
  getIt.registerLazySingleton<StoresBloc>(() => storesBloc);

  final productsBloc = ProductsBloc(
    productLocalRepository: getIt<IProductLocalRepository>(),
    priceObservationLocalRepository:
        getIt<IPriceObservationLocalRepository>(),
    imageStore: getIt<ProductImageStore>(),
    saveProductImage: getIt<SaveProductImageUseCase>(),
  )..add(const ProductsEvent.watch());
  getIt.registerLazySingleton<ProductsBloc>(() => productsBloc);

  final authBloc = getIt<AuthBloc>()
    ..add(const AuthEvent.watch())
    ..add(const AuthEvent.watchProfile())
    ..add(const AuthEvent.watchAvatar());
  final syncBloc = getIt<SyncBloc>()..add(const SyncEvent.watch());

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
      productsBloc: productsBloc,
      authBloc: authBloc,
      syncBloc: syncBloc,
      router: router,
    ),
  );
}

class SpendLensApp extends StatefulWidget {
  final SettingsBloc settingsBloc;
  final CategoriesBloc categoriesBloc;
  final StoresBloc storesBloc;
  final ProductsBloc productsBloc;
  final AuthBloc authBloc;
  final SyncBloc syncBloc;
  final GoRouter router;

  const SpendLensApp({
    super.key,
    required this.settingsBloc,
    required this.categoriesBloc,
    required this.storesBloc,
    required this.productsBloc,
    required this.authBloc,
    required this.syncBloc,
    required this.router,
  });

  @override
  State<SpendLensApp> createState() => _SpendLensAppState();
}

class _SpendLensAppState extends State<SpendLensApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // FIRST statement after super.initState() — unconditional, synchronous,
    // never after an await/guard/if. `SpendLensApp` is the root widget
    // passed to `runApp`, so this is the earliest point GUARANTEED to run
    // on every cold start, before GoRouter evaluates `resolveRedirect` and
    // before the first frame paints. See the doc comment on `main()` above
    // for why this replaces the (unreachable) splash-screen-owned call.
    FlutterNativeSplash.remove();

    WidgetsBinding.instance.addObserver(this);

    // A RESTORED session reaches `signedIn` before this widget mounts —
    // Firebase resolves a cached credential in milliseconds, and `AuthBloc`
    // is constructed in `main()` ahead of `runApp`. `listenWhen` only sees
    // transitions that happen AFTER subscribing, so `_onSignedIn` never
    // fires on a cold start or hot restart, and `needsSync` cannot cover it
    // either (it requires pending work, and a device that already pushed
    // everything has none). Without this, an app relaunched while signed in
    // ran NO sync cycle at all: it sat at `idle` and never pulled the
    // account's records down.
    if (widget.authBloc.state.isSignedIn) {
      widget.syncBloc.add(const SyncEvent.syncNow());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onSyncNeeded(BuildContext context, SyncState state) {
    context.read<SyncBloc>().add(const SyncEvent.syncNow());
  }

  /// Signing in is the moment an account's records become reachable, so it
  /// must start a cycle explicitly.
  ///
  /// `SyncBloc.needsSync` deliberately fires only on PENDING work, so it
  /// cannot cover this: a device signing in with nothing outstanding has a
  /// pending count of 0 and would sit idle while the account's records stay
  /// on the server. This listener is what pulls them down.
  ///
  /// It only catches a LIVE transition, which is why `initState` below also
  /// dispatches for a session that was already restored — see there.
  void _onSignedIn(BuildContext context, AuthState state) {
    context.read<SyncBloc>().add(const SyncEvent.syncNow());
  }

  /// Coming back to the foreground is a reconnect opportunity the
  /// connectivity stream can miss (the OS may not re-emit if the transition
  /// happened while the process was suspended).
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      widget.syncBloc.add(const SyncEvent.syncNow());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>.value(
          value: widget.settingsBloc,
        ),
        BlocProvider<CategoriesBloc>.value(
          value: widget.categoriesBloc,
        ),
        BlocProvider<StoresBloc>.value(
          value: widget.storesBloc,
        ),
        BlocProvider<ProductsBloc>.value(
          value: widget.productsBloc,
        ),
        BlocProvider<SyncBloc>.value(
          value: widget.syncBloc,
        ),
        BlocProvider<AuthBloc>.value(
          value: widget.authBloc,
        ),
      ],
      // Auto-sync trigger.
      //
      // A LISTENER, not a handler: this project's BLoC rules forbid calling
      // `add()` from inside a bloc handler, so `SyncBloc` exposes
      // `needsSync` on its state and the dispatch happens here. Do not
      // "simplify" this into an `add()` inside `_onWatch` — that is the
      // rule violation, and it also re-enters the handler that is emitting.
      child: MultiBlocListener(
        listeners: [
          BlocListener<SyncBloc, SyncState>(
            listenWhen: (previous, current) =>
                !previous.needsSync && current.needsSync,
            listener: _onSyncNeeded,
          ),
          // Fires on the TRANSITION into signed-in only, so a rebuild or a
          // token refresh cannot re-trigger a cycle.
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, current) =>
                !previous.isSignedIn && current.isSignedIn,
            listener: _onSignedIn,
          ),
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
              routerConfig: widget.router,
            );
          },
        ),
      ),
    );
  }
}
