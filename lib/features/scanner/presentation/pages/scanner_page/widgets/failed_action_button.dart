import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';

/// One of [ScannerFailedSheet]'s two actions ("Try Again" / "Enter
/// Manually") — one widget per file (`developer.md` A2).
class FailedActionButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const FailedActionButton({
    super.key,
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: ConstrainedBox(
        // ⛔ sig:developer-derived-fixed-dp-cell-height-ignores-
        // textScaleFactor — this button carries the "Try Again"/"Enter
        // Manually" label text, so MIN-HEIGHT only (the drag handle and
        // the icon-only warning badge above, on this same sheet, are the
        // correct FIXED-size decorative cases for comparison).
        constraints: const BoxConstraints(minHeight: 44.0),
        child: AppContainer(
          color: isPrimary ? scheme.ink : null,
          border: isPrimary ? null : Border.all(color: scheme.line2),
          borderRadius: BorderRadius.circular(14.0),
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          alignment: Alignment.center,
          child: Text(
            label,
            style: textTheme.subhead15.copyWith(
              fontWeight: FontWeight.w600,
              color: isPrimary ? scheme.onAccent : scheme.accent,
            ),
          ),
        ),
      ),
    );
  }
}
