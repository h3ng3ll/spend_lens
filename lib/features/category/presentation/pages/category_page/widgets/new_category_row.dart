import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';

/// The Categories list's trailing "+ New category" row
/// (design_spendlens.md's Categories artboard) navigating to
/// `NewCategoryPageRoute`.
class NewCategoryRow extends StatelessWidget {
  final VoidCallback onTap;

  const NewCategoryRow({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    // CHRONIC BUG GUARD
    // (`sig:developer-derived-fixed-dp-cell-height-ignores-textScaleFactor`):
    // no fixed `height:` — vertical padding lets the row grow with the
    // label's text scale instead of clipping it.
    return GestureDetector(
      onTap: onTap,
      child: AppContainer(
        color: scheme.card,
        border: Border.all(color: scheme.accentLine, width: 1.0),
        borderRadius: BorderRadius.circular(16.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 12.0,
          children: [
            AppContainer(
              width: 28.0,
              height: 28.0,
              color: scheme.accentTint,
              shape: BoxShape.circle,
              alignment: Alignment.center,
              child: AppSvgIcon(asset: AppIcons.plus, color: scheme.accent, size: 16.0),
            ),
            Expanded(
              child: Text(
                lo.newCategory,
                style: textTheme.subhead15.copyWith(
                  color: scheme.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text('›', style: textTheme.body17.copyWith(color: scheme.ter)),
          ],
        ),
      ),
    );
  }
}
