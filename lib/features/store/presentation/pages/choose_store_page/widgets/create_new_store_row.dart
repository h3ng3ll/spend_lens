import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';

/// The Choose-store picker's trailing "Create new store" row
/// (design_spendlens.md's Choose-store artboard) navigating to
/// `NewStorePageRoute`.
class CreateNewStoreRow extends StatelessWidget {
  final VoidCallback onTap;

  const CreateNewStoreRow({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    // CHRONIC BUG GUARD
    // (`sig:developer-derived-fixed-dp-cell-height-ignores-textScaleFactor`):
    // no fixed `height:` — the row sizes to its two-line title/subtitle
    // content via vertical padding, so a larger textScaleFactor grows the
    // row instead of clipping either line.
    return GestureDetector(
      onTap: onTap,
      child: AppContainer(
        color: scheme.card,
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
              color: scheme.accentTint,
              shape: BoxShape.circle,
              alignment: Alignment.center,
              child: AppSvgIcon(asset: AppIcons.plus, color: scheme.accent, size: 16.0),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lo.createNewStore,
                    style: textTheme.subhead15.copyWith(
                      color: scheme.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    lo.createNewStoreSub,
                    style: textTheme.footnote13.copyWith(color: scheme.ter),
                  ),
                ],
              ),
            ),
            Text('›', style: textTheme.body17.copyWith(color: scheme.ter)),
          ],
        ),
      ),
    );
  }
}
