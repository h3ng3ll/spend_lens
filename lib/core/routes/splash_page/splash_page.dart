import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';

import '../../../features/settings/presentation/bloc/settings_bloc/settings_bloc.dart';
import '../../resources/colors/app_color_scheme.dart';
import '../init_router/init_router.dart';
import '../presentation/loading_data_widget.dart';

/// `SplashPageRoute` `/` (design_spendlens.md §5 + M10 —
/// `~/.claude/rules/splash_screen_rules.md`).
///
/// **How this project's navigation is actually split** (see the Developer
/// M10 handoff's "coexistence" note): [resolveRedirect] in `init_router.dart`
/// is a PURE, synchronous function of `onboardingCompleted` — a value that is
/// already known before `runApp` (`SettingsBloc` is seeded with
/// `initialSettings` in `main()`, never left to an async fetch — see that
/// bloc's own doc comment on `splash-first-frame-default-theme-async-settings`
/// / `onboarding-completed-flag-async-fetch-race-splash-reshows-onboarding`).
/// Because `GoRouter` evaluates `redirect` synchronously against that
/// already-resolved value on its very first navigation to `initialLocation:
/// '/'`, this page's `build()` is not reachable on a normal cold start in
/// EITHER branch — the redirect has already sent the user to `/onboarding`
/// or `/home` before this widget is ever built. That is intentional, not a
/// bug: `resolveRedirect` is the ONE navigation authority for this decision,
/// so this page does NOT duplicate it with a second, competing decision path
/// that could race the redirect (e.g. firing `_goHome()` a frame after the
/// redirect already fired `_goOnboard()`).
///
/// What THIS file still owns, and must own regardless of which branch
/// actually runs the visible frame:
/// - `FlutterNativeSplash.remove()` — called exactly once, unconditionally,
///   as the very first statement of `initState()` (the splash rules' hard
///   rule). This is NOT gated on the redirect at all; it must run whether or
///   not `build()` ever paints a meaningful frame, or the native splash would
///   never lift.
/// - A visible dwell (`_kSplashDwell`) plus the two NAMED destination
///   methods the rules require, kept as a SAFETY NET only: if this page is
///   ever reached with the redirect for some reason not having already
///   fired (e.g. a future change removes the eager redirect check, or this
///   route is pushed directly in a test), the dwell elapses and one of
///   `_goHome()` / `_goOnboard()` fires — each guarded so it is a no-op if
///   the router has already navigated away by then. This keeps exactly ONE
///   navigation authority in the steady state while still satisfying "two
///   destinations, two named methods, an `if` with a reachable `else`" as an
///   independently testable contract.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  /// How long the splash dwells before its safety-net decision fires. In
  /// the steady state `resolveRedirect` has already navigated away well
  /// before this elapses.
  static const Duration _kSplashDwell = Duration(seconds: 2);

  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    // FIRST statement after super.initState() — unconditional, synchronous,
    // never after an await/guard/if (splash_screen_rules.md hard rule).
    FlutterNativeSplash.remove();
    _processSplash();
  }

  Future<void> _processSplash() async {
    // Hoisted BEFORE the dwell — reading an InheritedWidget off `context`
    // after a suspension point is unsafe if the element unmounts meanwhile.
    final settingsBloc = context.read<SettingsBloc>();

    await Future.delayed(_kSplashDwell);

    if (!mounted) return;

    if (settingsBloc.state.settings.onboardingCompleted) {
      _goHome();
    } else {
      _goOnboard();
    }
  }

  void _goHome() {
    if (_navigated || !mounted) return;
    _navigated = true;
    // No-op if `resolveRedirect` already moved the router elsewhere — this
    // is the safety net, not a second authority (see class doc comment).
    if (GoRouterState.of(context).matchedLocation !=
        SplashPageRoute().location) {
      return;
    }
    HomePageRoute().go(context);
  }

  void _goOnboard() {
    if (_navigated || !mounted) return;
    _navigated = true;
    if (GoRouterState.of(context).matchedLocation !=
        SplashPageRoute().location) {
      return;
    }
    OnboardingPageRoute().go(context);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      body: const LoadingDataWidget(),
    );
  }
}
