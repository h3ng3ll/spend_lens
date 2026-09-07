import 'package:flutter/material.dart';

import '../resources/colors/app_color_scheme.dart';
import '../resources/text/app_text_theme.dart';

/// The small uppercase, letter-spaced section label used above every card
/// group (e.g. "CATEGORIES", "RECENT", "YOUR DATA").
class SectionLabel extends StatelessWidget {
  final String text;

  const SectionLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Text(
      text.toUpperCase(),
      style: textTheme.sectionLabel12.copyWith(
        color: scheme.ter,
        letterSpacing: 1.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
