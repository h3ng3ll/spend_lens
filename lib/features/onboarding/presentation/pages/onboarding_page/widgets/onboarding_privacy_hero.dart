import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';

/// The "your data stays on your device" onboarding step's illustration — a
/// glass-card badge holding the receipt glyph on the accent gradient
/// (design's onboarding artboard, step 3). Purely decorative; layout only
/// (A6).
class OnboardingPrivacyHero extends StatelessWidget {
  final double size;

  const OnboardingPrivacyHero({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);

    return AppContainer(
      width: size,
      height: size,
      color: scheme.card,
      border: Border.all(color: scheme.field2),
      borderRadius: BorderRadius.circular(size * 0.28),
      boxShadow: [
        BoxShadow(
          color: scheme.accent2.withValues(alpha: 0.25),
          blurRadius: 60.0,
        ),
      ],
      alignment: Alignment.center,
      child: AppContainer(
        width: size * 0.4,
        height: size * 0.4,
        gradient: scheme.accentGradient,
        borderRadius: BorderRadius.circular(size * 0.12),
        alignment: Alignment.center,
        child: AppSvgIcon(
          asset: AppIcons.receipt,
          color: scheme.onAccent,
          size: size * 0.22,
        ),
      ),
    );
  }
}
