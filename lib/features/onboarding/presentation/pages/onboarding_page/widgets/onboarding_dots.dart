import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/widgets/app_container.dart';

/// The onboarding page-dot indicator (design's onboarding artboard footer).
/// Layout only (A6): [stepCount] dots, the [activeIndex]'th one widened and
/// accent-colored.
class OnboardingDots extends StatelessWidget {
  final int stepCount;
  final int activeIndex;

  const OnboardingDots({
    super.key,
    required this.stepCount,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6.0,
      children: List.generate(stepCount, (index) {
        final isActive = index == activeIndex;
        return AppContainer(
          width: isActive ? 18.0 : 6.0,
          height: 6.0,
          color: isActive ? scheme.accent : scheme.dim,
          borderRadius: BorderRadius.circular(3.0),
        );
      }),
    );
  }
}
