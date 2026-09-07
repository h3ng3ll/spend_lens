import 'package:flutter/material.dart';

import '../resources/colors/app_color_scheme.dart';
import '../resources/text/app_text_theme.dart';
import 'app_container.dart';

/// The shared "Create '{query}'" quick-create row (design_spendlens.md's
/// Categories AND Choose-store artboards share this exact shape: a gradient
/// `+` badge, a two-line accent label, over an `--accent-tint` wash) —
/// shown only while the typed search query doesn't match any existing
/// row.
class CreateNewRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const CreateNewRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    // CHRONIC BUG GUARD
    // (`sig:developer-derived-fixed-dp-cell-height-ignores-textScaleFactor`):
    // no fixed `height:` — the row sizes to its two-line title/subtitle
    // content via vertical padding, so a larger textScaleFactor grows the
    // row instead of clipping either line.
    return GestureDetector(
      onTap: onTap,
      child: AppContainer(
        color: scheme.accentTint,
        border: Border.all(color: scheme.accentLine, width: 1.0),
        borderRadius: BorderRadius.circular(16.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 12.0,
          children: [
            AppContainer(
              width: 28.0,
              height: 28.0,
              gradient: scheme.accentGradient,
              shape: BoxShape.circle,
              alignment: Alignment.center,
              child: Text(
                '+',
                style: textTheme.headline17Semi.copyWith(
                  color: scheme.onAccent,
                  height: 1.0,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.subhead15.copyWith(
                      color: scheme.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: textTheme.footnote13.copyWith(color: scheme.ter),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
