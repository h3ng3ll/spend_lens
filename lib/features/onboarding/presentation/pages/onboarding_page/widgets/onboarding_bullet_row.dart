import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';

/// One bullet line of an onboarding step's point list (design's onboarding
/// artboard — a small gradient dot followed by the point text). Layout only
/// (A6).
class OnboardingBulletRow extends StatelessWidget {
  final String text;

  const OnboardingBulletRow({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10.0,
      children: [
        AppContainer(
          width: 6.0,
          height: 6.0,
          gradient: scheme.accentGradient,
          shape: BoxShape.circle,
        ),
        Expanded(
          child: Text(
            text,
            style: textTheme.body17.copyWith(color: scheme.sec),
          ),
        ),
      ],
    );
  }
}
