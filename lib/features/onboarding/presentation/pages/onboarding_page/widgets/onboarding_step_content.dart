import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import 'onboarding_bullet_row.dart';

/// One page of the onboarding `PageView` (design's onboarding artboard):
/// [hero] illustration, [title], and its bullet [points]. Container rule
/// (A6): the hero is supplied by the caller, never built here.
///
/// CHRONIC BUG GUARD (`db:min-column-pageview-expanded-top-aligns-void`):
/// this Column is a `PageView` page's direct child, so it gets a TIGHT
/// full-height constraint from the page — `mainAxisAlignment: center` is
/// therefore live (not inert, unlike under a `SingleChildScrollView`) and is
/// what prevents content clustering at the top with a void below.
class OnboardingStepContent extends StatelessWidget {
  final Widget hero;
  final String title;
  final List<String> points;

  const OnboardingStepContent({
    super.key,
    required this.hero,
    required this.title,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return HorizontalPadding(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 36.0,
        children: [
          Center(child: hero),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12.0,
            children: [
              Text(
                title,
                style: textTheme.screenTitle28.copyWith(color: scheme.ink),
              ),
              ...points.map((point) => OnboardingBulletRow(text: point)),
            ],
          ),
        ],
      ),
    );
  }
}
