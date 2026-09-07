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
/// router/redirect contract actually depends on: the Get Started action
/// AWAITS the persistence write before navigating, per the splash contract's
/// "await before navigating or a fast kill loses the write" rule
/// (`splash_screen_rules.md`, ported here since this app has no
/// NavTutorialCubit — `SettingsBloc.completeOnboarding()` is the equivalent
/// write).
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  Future<void> _onGetStarted(BuildContext context) async {
    final settingsBloc = context.read<SettingsBloc>();
    settingsBloc.add(const SettingsEvent.completeOnboarding());

    // Wait for the write to actually reach Hive before navigating — a
    // synchronous `emit` above is not enough; `_saveSettingsUseCase` is
    // awaited by the handler, not by this dispatch call.
    await settingsBloc.stream.firstWhere(
      (state) => state.settings.onboardingCompleted,
    );

    if (!context.mounted) return;
    HomePageRoute().go(context);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      body: OnboardingBody(
        onGetStarted: () => _onGetStarted(context),
        getStartedLabel: lo.getStarted,
      ),
    );
  }
}
