import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';
import '../../../../../../core/widgets/category_dot.dart';

/// Review's Category picker row (`SpendLens Prototype.dc.html` line 524).
/// Layout only (A6) — the picked category's dot color/label and the tap
/// callback arrive from the parent page.
class ReviewCategoryCard extends StatelessWidget {
  final String sectionLabel;
  final Color? dotColor;
  final String categoryLabel;
  final String changeLabel;
  final VoidCallback onTap;

  const ReviewCategoryCard({
    super.key,
    required this.sectionLabel,
    required this.dotColor,
    required this.categoryLabel,
    required this.changeLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return AppContainer(
      color: scheme.card,
      border: Border.all(color: scheme.line, width: 1.0),
      borderRadius: BorderRadius.circular(20.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.0,
        children: [
          Text(
            sectionLabel,
            style: textTheme.sectionLabel12.copyWith(color: scheme.ter),
          ),
          GestureDetector(
            onTap: onTap,
            child: ConstrainedBox(
              // ⛔ sig:developer-derived-fixed-dp-cell-height-ignores-
              // textScaleFactor — this row carries the category label
              // text, so MIN-HEIGHT only.
              constraints: const BoxConstraints(minHeight: 48.0),
              child: AppContainer(
                color: scheme.field,
                borderRadius: BorderRadius.circular(14.0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10.0,
                children: [
                  if (dotColor != null) CategoryDot(color: dotColor!),
                  Expanded(
                    child: Text(
                      categoryLabel,
                      style: textTheme.body17.copyWith(color: scheme.ink),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    changeLabel,
                    style: textTheme.subhead15.copyWith(
                      color: scheme.accent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  AppSvgIcon(
                    asset: AppIcons.chevronRight,
                    color: scheme.ter,
                    size: 16.0,
                  ),
                ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
