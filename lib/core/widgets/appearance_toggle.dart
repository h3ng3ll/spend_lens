import 'package:flutter/material.dart';

import '../resources/colors/app_color_scheme.dart';
import '../resources/text/app_text_theme.dart';
import 'app_container.dart';

/// The Settings → Appearance control (design_spendlens.md §10, verified at
/// `SpendLens Prototype.dc.html` line 781 `themeOpts`): a 2-segment pill
/// (Dark / Light), NOT an iOS-style switch.
///
/// CHRONIC BUG GUARD
/// (`db:custom-switch-toggle-knob-fills-track-wrong-state-colors`): the
/// selected segment fills with `scheme.field2` and gets `FontWeight.w600`;
/// the unselected segment stays on the bare track (`scheme.field`, painted
/// by the outer [AppContainer]) with `scheme.sec` + `FontWeight.w500`. The
/// two states are visually distinct in BOTH color and weight in both
/// themes — there is no shared "knob" that could fill the whole track,
/// because this is a segmented selector, not a binary switch.
class AppearanceToggle extends StatelessWidget {
  final bool isDark;
  final String darkLabel;
  final String lightLabel;
  final VoidCallback onToggle;

  const AppearanceToggle({
    super.key,
    required this.isDark,
    required this.darkLabel,
    required this.lightLabel,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    Widget segment(String label, bool selected) {
      return AppContainer(
        color: selected ? scheme.field2 : null,
        borderRadius: BorderRadius.circular(8.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        alignment: Alignment.center,
        child: Text(
          label,
          style: textTheme.footnote13.copyWith(
            color: selected ? scheme.ink : scheme.sec,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onToggle,
      behavior: HitTestBehavior.opaque,
      child: AppContainer(
        color: scheme.field,
        borderRadius: BorderRadius.circular(10.0),
        padding: const EdgeInsets.all(3.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 2.0,
          children: [
            segment(darkLabel, isDark),
            segment(lightLabel, !isDark),
          ],
        ),
      ),
    );
  }
}
