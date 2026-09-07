import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/widgets/app_container.dart';

/// The mock receipt-card illustration shared by the "know your spending" and
/// "scan in seconds" onboarding steps (design's onboarding artboard — a
/// paper-toned card with placeholder text lines standing in for a receipt).
/// Purely decorative; layout only (A6).
class OnboardingReceiptCard extends StatelessWidget {
  final double width;
  final double height;
  final bool highlighted;

  const OnboardingReceiptCard({
    super.key,
    required this.width,
    required this.height,
    this.highlighted = false,
  });

  Widget _line(AppColorScheme scheme, {double widthFactor = 1.0}) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: AppContainer(
        height: 3.0,
        color: scheme.dim,
        borderRadius: BorderRadius.circular(2.0),
      ),
    );
  }

  Widget _bar(AppColorScheme scheme, {double widthFactor = 0.4}) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: AppContainer(
        height: 5.0,
        color: scheme.ter,
        borderRadius: BorderRadius.circular(2.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);

    return AppContainer(
      width: width,
      height: height,
      color: scheme.cardSolid,
      borderRadius: BorderRadius.circular(6.0),
      border: highlighted
          ? Border.all(color: scheme.accent, width: 1.5)
          : null,
      boxShadow: [
        BoxShadow(
          color: AppColors.black.value.withValues(alpha: 0.4),
          blurRadius: 40.0,
          offset: const Offset(0.0, 20.0),
        ),
        if (highlighted)
          BoxShadow(
            color: scheme.accent.withValues(alpha: 0.35),
            blurRadius: 40.0,
          ),
      ],
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 6.0,
        children: [
          Center(child: _bar(scheme)),
          _line(scheme),
          _line(scheme, widthFactor: 0.85),
          _line(scheme),
          _line(scheme, widthFactor: 0.7),
          Center(child: _bar(scheme, widthFactor: 0.5)),
        ],
      ),
    );
  }
}
