import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';

/// A small pill badge (design's onboarding step-3 artboard: "No account" /
/// "No upload" / "Offline"). Layout only (A6).
class OnboardingPillChip extends StatelessWidget {
  final String label;

  const OnboardingPillChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return AppContainer(
      height: 28.0,
      color: scheme.field,
      border: Border.all(color: scheme.line2),
      borderRadius: BorderRadius.circular(999.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      alignment: Alignment.center,
      child: Text(
        label,
        style: textTheme.footnote13.copyWith(
          color: scheme.sec,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
