import 'package:flutter/material.dart';

import '../../../../../../core/widgets/gradient_cta_button.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import 'onboarding_dots.dart';

/// The onboarding footer: the page-dot indicator plus the primary CTA
/// (design's onboarding artboard — `Continue` on steps 1–2, `Get Started` on
/// the last step). Layout only (A6); [onCta] is a named callback supplied by
/// the caller (A2).
class OnboardingFooterRow extends StatelessWidget {
  final int stepCount;
  final int activeIndex;
  final String ctaLabel;
  final VoidCallback onCta;

  const OnboardingFooterRow({
    super.key,
    required this.stepCount,
    required this.activeIndex,
    required this.ctaLabel,
    required this.onCta,
  });

  @override
  Widget build(BuildContext context) {
    return HorizontalPadding(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20.0,
        children: [
          OnboardingDots(stepCount: stepCount, activeIndex: activeIndex),
          GradientCtaButton(label: ctaLabel, enabled: true, onTap: onCta),
        ],
      ),
    );
  }
}
