import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/utils/extensions/color_ext.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/category_dot.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';
import '../../../../../category/domain/models/category/category.dart';
import '../../../../../category/domain/models/category/category_display_x.dart';

/// The Cash-expense "Category" row (design_spendlens.md's Cash-expense
/// artboard): dot + selected category name + "Change" + chevron, tapping it
/// opens the category picker. Layout only (A6) — the tap callback and the
/// selected [category] both arrive from the parent page.
class CashCategoryRow extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CashCategoryRow({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AppContainer(
        height: 48.0,
        color: scheme.field,
        borderRadius: BorderRadius.circular(14.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10.0,
          children: [
            CategoryDot(color: ColorExtension.fromHex(category.colorHex)),
            Expanded(
              child: Text(
                category.displayName(lo),
                style: textTheme.body17.copyWith(color: scheme.ink),
              ),
            ),
            Text(
              lo.change,
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
    );
  }
}
