import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/bloc/app_observer.dart';
import 'core/di/injection.dart';
import 'core/hive/hive_initializer.dart';
import 'core/resources/app_locale.dart';
import 'core/resources/app_theme.dart';
import 'core/resources/localization/gen/app_localizations.dart';
import 'core/services/ui_message_service.dart';
import 'features/settings/di/settings_injection.dart';
import 'features/settings/domain/use_cases/save_settings_use_case.dart';
import 'features/settings/domain/use_cases/watch_settings_use_case.dart';
import 'features/settings/presentation/bloc/settings_bloc/settings_bloc.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// M2 bootstrap: Hive + DI + `.env` load, both themes wired, `SettingsBloc`
/// seeded SYNCHRONOUSLY before `runApp` (recorded global bug
/// `splash-first-frame-default-theme-async-settings` — the persisted
/// locale/theme MUST be resolved before the first frame, never left to
/// arrive only via an awaited stream after the app is already showing).
///
/// No router yet (lands in M5 with `go_router_builder`); no splash/
/// onboarding (M10); no Firebase (M9, Crashlytics + optional auth only) —
/// see design_spendlens.md §10 for the full phasing table.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await initHive();
  await initDependencies();

  // Resolved BEFORE runApp — this is the value SettingsBloc is seeded with,
  // never left for an async fetch to deliver after the first frame.
  final initialSettings = await initSettingsFeature();

  final settingsBloc = SettingsBloc(
    initialSettings: initialSettings,
    watchSettingsUseCase: getIt<WatchSettingsUseCase>(),
    saveSettingsUseCase: getIt<SaveSettingsUseCase>(),
  )..add(const SettingsEvent.watch());
  getIt.registerLazySingleton<SettingsBloc>(() => settingsBloc);

  Bloc.observer = AppObserver.instance();

  UiMessageService.attach(rootNavigatorKey);

  runApp(SpendLensApp(settingsBloc: settingsBloc));
}

class SpendLensApp extends StatelessWidget {
  final SettingsBloc settingsBloc;

  const SpendLensApp({super.key, required this.settingsBloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>.value(
      value: settingsBloc,
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            navigatorKey: rootNavigatorKey,
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
            home: const _BootstrapScreen(),
          );
        },
      ),
    );
  }
}

/// Placeholder home until the router (M5) and splash/onboarding (M10) land.
class _BootstrapScreen extends StatelessWidget {
  const _BootstrapScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox.shrink(),
    );
  }
}
