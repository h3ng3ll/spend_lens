import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';

/// The onboarding header's `Skip` control, top-right (design's onboarding
/// artboard). Layout only (A6); [onSkip] is a named callback supplied by the
/// caller — no inline bloc/logic here (A2).
class OnboardingSkipRow extends StatelessWidget {
  final VoidCallback onSkip;
  final String skipLabel;

  const OnboardingSkipRow({
    super.key,
    required this.onSkip,
    required this.skipLabel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return HorizontalPadding(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: onSkip,
            child: Text(
              skipLabel,
              style: textTheme.body17.copyWith(color: scheme.sec),
            ),
          ),
        ],
      ),
    );
  }
}
