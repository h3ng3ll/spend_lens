import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';

/// The Review screen's "Correct" action button — one widget per file
/// (`developer.md` A2).
class CorrectButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const CorrectButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: ConstrainedBox(
        // ⛔ sig:developer-derived-fixed-dp-cell-height-ignores-
        // textScaleFactor — this button carries the "Correct" label text,
        // so MIN-HEIGHT only.
        constraints: const BoxConstraints(minHeight: 56.0),
        child: AppContainer(
          color: scheme.field,
          border: Border.all(color: scheme.field2),
          borderRadius: BorderRadius.circular(16.0),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          alignment: Alignment.center,
          child: Text(
            label,
            style: textTheme.headline17.copyWith(
              color: scheme.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
