import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/routes/init_router/init_router.dart';
import '../../../../settings/presentation/bloc/settings_bloc/settings_bloc.dart';
import 'widgets/onboarding_body.dart';

/// `OnboardingPageRoute` `/onboarding` (design_spendlens.md §5) — a top-level
/// route, reached from Splash's `redirect` when
/// `!settings.onboardingCompleted`.
///
/// M4 minimal placeholder — the real multi-step carousel (3 steps, design's
/// `onb0`/`onb1`/`onb2` copy) is M10. This stub proves the ONE behavior the
/// router/redirect contract actually depends on: navigation happens only
/// AFTER the persistence write has actually landed, per the splash
/// contract's "await before navigating or a fast kill loses the write" rule
/// (`splash_screen_rules.md`, ported here since this app has no
/// NavTutorialCubit — `SettingsBloc.completeOnboarding()` is the equivalent
/// write).
///
/// The wait is a [BlocListener] on the persisted flag, NOT an
/// `await bloc.stream.firstWhere(...)` in the tap handler. That await could
/// hang forever: `_onCompleteOnboarding` returns early WITHOUT emitting when
/// the flag is already `true`, so re-entering this route with onboarding
/// already complete left the button permanently dead — no error, no timeout,
/// no second chance. Reacting to state instead cannot deadlock, because the
/// listener fires on the state the bloc actually holds.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  void _onGetStarted(BuildContext context) {
    context.read<SettingsBloc>().add(
      const SettingsEvent.completeOnboarding(),
    );
  }

  void _onOnboardingCompleted(BuildContext context, SettingsState state) {
    HomePageRoute().go(context);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return BlocListener<SettingsBloc, SettingsState>(
      // Fires on the TRANSITION into the persisted state. `listenWhen` is
      // invoked on each state CHANGE, not at subscribe time, so this alone
      // does not cover arriving with the flag already `true` — the router's
      // `resolveRedirect` is what keeps a completed user off this route in
      // the first place. What this DOES remove is the deadlock: the tap no
      // longer awaits an emit that the early-return path never produces.
      listenWhen: (previous, current) =>
          !previous.settings.onboardingCompleted &&
          current.settings.onboardingCompleted,
      listener: _onOnboardingCompleted,
      child: Scaffold(
        backgroundColor: scheme.bg,
        body: OnboardingBody(
          onGetStarted: () => _onGetStarted(context),
          getStartedLabel: lo.getStarted,
        ),
      ),
    );
  }
}
