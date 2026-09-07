import 'package:flutter/material.dart';

import '../../../resources/colors/app_color_scheme.dart';
import '../../../resources/text/app_text_theme.dart';
import '../../app_container.dart';

/// The Period sheet's year stepper — STYLED DISABLED (design_spendlens.md,
/// "Deliberately not built": only the current year is selectable until
/// there is more than one year of data, verified at
/// `SpendLens Prototype.dc.html` line 946/947 — both arrows are
/// `color:var(--dim)` with a no-op `onClick`).
///
/// CHRONIC BUG GUARD
/// (`db:shared-button-disabled-styling-only-recolors-its-own-default-
/// child`): the arrow glyph is a CUSTOM child built directly at this call
/// site (a bordered box, not a stock button's default `Text`/`Icon` child),
/// and its disabled coloring (`scheme.dim`) is applied EXPLICITLY here —
/// never inherited from a shared button widget's own internal
/// disabled-state logic, which would only recolor that widget's OWN default
/// child and leave a custom glyph like this one unaffected.
class PeriodYearStepper extends StatelessWidget {
  final int year;

  const PeriodYearStepper({super.key, required this.year});

  Widget _arrow(AppColorScheme scheme, {required bool pointsLeft}) {
    return AppContainer(
      width: 36.0,
      height: 36.0,
      color: scheme.card,
      shape: BoxShape.circle,
      alignment: Alignment.center,
      child: Transform.rotate(
        angle: 0.785398,
        child: AppContainer(
          width: 9.0,
          height: 9.0,
          border: pointsLeft
              ? Border(
                  left: BorderSide(color: scheme.dim, width: 2.0),
                  bottom: BorderSide(color: scheme.dim, width: 2.0),
                )
              : Border(
                  right: BorderSide(color: scheme.dim, width: 2.0),
                  top: BorderSide(color: scheme.dim, width: 2.0),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _arrow(scheme, pointsLeft: true),
        Text(
          '$year',
          style: textTheme.headline17Semi.copyWith(
            color: scheme.ink,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        _arrow(scheme, pointsLeft: false),
      ],
    );
  }
}
