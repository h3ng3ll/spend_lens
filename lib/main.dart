import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/bloc/app_observer.dart';
import 'core/di/injection.dart';
import 'core/hive/hive_initializer.dart';
import 'core/resources/app_locale.dart';
import 'core/resources/app_theme.dart';
import 'core/services/ui_message_service.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// M1 bootstrap: Hive + DI + `.env` load, both themes wired, a themed blank
/// screen. No router yet (that lands in M5 with `go_router_builder`); no
/// splash/onboarding (M10); no Firebase (M9, Crashlytics + optional auth
/// only) — see design_spendlens.md §10 for the full phasing table.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await initHive();
  await initDependencies();

  Bloc.observer = AppObserver.instance();

  UiMessageService.attach(rootNavigatorKey);

  runApp(const SpendLensApp());
}

class SpendLensApp extends StatelessWidget {
  const SpendLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: rootNavigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.light,
      darkTheme: AppThemeData.dark,
      themeMode: ThemeMode.system,
      locale: AppLocale.startLocale,
      supportedLocales: AppLocale.supportedLocales,
      home: const _BootstrapScreen(),
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
