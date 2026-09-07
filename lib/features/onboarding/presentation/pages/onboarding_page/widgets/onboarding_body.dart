import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/btn/custom_text_btn.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';

/// M4 minimal placeholder for the onboarding carousel (design's 3-step
/// `onb0`/`onb1`/`onb2` content lands at M10). Layout only (A6): receives
/// its action and label as constructor parameters.
class OnboardingBody extends StatelessWidget {
  final VoidCallback onGetStarted;
  final String getStartedLabel;

  const OnboardingBody({
    super.key,
    required this.onGetStarted,
    required this.getStartedLabel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return SafeArea(
      child: HorizontalPadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 16.0,
          children: [
            Text(
              lo.splashTag,
              style: textTheme.screenTitle28.copyWith(color: scheme.ink),
            ),
            CustomTextBtn(onPressed: onGetStarted, text: getStartedLabel),
          ],
        ),
      ),
    );
  }
}
