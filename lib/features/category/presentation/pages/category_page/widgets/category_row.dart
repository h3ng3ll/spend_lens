import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/utils/extensions/color_ext.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';
import '../../../../../../core/widgets/category_dot.dart';
import '../../../../domain/models/category/category.dart';
import '../../../../domain/models/category/category_display_x.dart';

/// A single row in the Categories list (design_spendlens.md's Categories
/// artboard): dot + name + meta line, tapping the row (not the trailing
/// icons) picks it; custom categories additionally show rename (pencil) and,
/// only while unused, delete (×) actions — each its own tap target, nested
/// inside the row's `GestureDetector` rather than swallowed by it.
class CategoryRow extends StatelessWidget {
  static const double _actionSize = 32.0;

  final Category category;
  final String meta;
  final bool isCustom;
  final bool isDeletable;
  final VoidCallback onPick;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  const CategoryRow({
    super.key,
    required this.category,
    required this.meta,
    required this.isCustom,
    required this.isDeletable,
    required this.onPick,
    required this.onRename,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    // CHRONIC BUG GUARD
    // (`sig:developer-derived-fixed-dp-cell-height-ignores-textScaleFactor`):
    // no fixed `height:` on this row — it sizes to its two-line text
    // content via vertical `Padding`, so a larger textScaleFactor grows the
    // row instead of clipping the name/meta text.
    return AppContainer(
      border: Border(bottom: BorderSide(color: scheme.field, width: 0.5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8.0,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onPick,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 12.0,
                  children: [
                    CategoryDot(
                      color: ColorExtension.fromHex(category.colorHex),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.displayName(lo),
                            style: textTheme.body17.copyWith(
                              color: scheme.ink,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            meta,
                            style: textTheme.footnote13.copyWith(
                              color: scheme.ter,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isCustom)
              GestureDetector(
                onTap: onRename,
                child: AppContainer(
                  width: _actionSize,
                  height: _actionSize,
                  color: scheme.field,
                  shape: BoxShape.circle,
                  alignment: Alignment.center,
                  child: AppSvgIcon(
                    asset: AppIcons.edit,
                    color: scheme.sec,
                    size: 14.0,
                  ),
                ),
              ),
            if (isDeletable)
              GestureDetector(
                onTap: onDelete,
                child: AppContainer(
                  width: _actionSize,
                  height: _actionSize,
                  color: scheme.field,
                  shape: BoxShape.circle,
                  alignment: Alignment.center,
                  child: AppSvgIcon(
                    asset: AppIcons.close,
                    color: scheme.sec,
                    size: 14.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
