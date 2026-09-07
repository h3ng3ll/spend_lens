import 'package:flutter/material.dart';

import '../resources/colors/app_color_scheme.dart';
import '../resources/text/app_text_theme.dart';

/// A small caption label stacked above a field/row (design_spendlens.md's
/// manual-entry artboards repeat this exact `sectionLabel12 / field` pair
/// for every input: Amount, Category, Note, Store, Name, Alias, Type…).
///
/// Layout only (A6, Container Rule): receives the field as a child rather
/// than constructing it.
class LabeledField extends StatelessWidget {
  final String label;
  final Widget child;

  const LabeledField({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6.0,
      children: [
        Text(
          label,
          style: textTheme.footnote13.copyWith(color: scheme.sec),
        ),
        child,
      ],
    );
  }
}
