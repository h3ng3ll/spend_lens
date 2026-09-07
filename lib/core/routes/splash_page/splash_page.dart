import 'package:flutter/material.dart';

import '../../resources/colors/app_color_scheme.dart';
import '../presentation/loading_data_widget.dart';

/// `SplashPageRoute` `/` (design_spendlens.md §5). `redirect` in
/// `init_router.dart` is the ONLY decision path off this route — it reads
/// `settings.onboardingCompleted` and sends the user to `/onboarding` or
/// `/home` before this page ever has to render a meaningful frame.
///
/// M4 SCOPE BOUNDARY (see the Developer handoff's Deviations section): this
/// is the router's placeholder destination only. It intentionally does NOT
/// implement `splash_screen_rules.md`'s native-splash contract
/// (`FlutterNativeSplash.preserve()`/`.remove()`, the dwell constant, the
/// native splash assets) — that whole contract, plus the real native splash
/// image and `flutter_native_splash.yaml`, is design_spendlens.md's M10
/// ("Splash, onboarding, transitions, ... icons and native splash"). Building
/// it now would be native-asset work outside M4's stated deliverable ("13
/// brick slices + rename pass + one build_runner; DI resolves"). This stub
/// exists so the 2-top-level-route + 5-branch-shell router the spec
/// describes actually compiles and its `redirect` is testable.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      body: const LoadingDataWidget(),
    );
  }
}
