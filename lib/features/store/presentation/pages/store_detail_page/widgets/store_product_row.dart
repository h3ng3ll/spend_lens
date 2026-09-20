import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';
import '../../../../../analytics/domain/models/store_price_comparison/store_price_comparison.dart';
import '../../../../../product/domain/models/product/product.dart';

/// One "Products bought here" row: product name + the cross-store
/// comparison line (`SpendLens Prototype.dc.html` line 885's `p.cmpStyle` —
/// `better === true` → `accent2` (teal/positive), `false` → `warn`
/// (amber/costlier here), `null` → `ter` (muted, nothing to compare)).
///
/// This is a DIFFERENT color rule from the amount trend pair
/// (`trendUp`/`trendDown`, design_spendlens.md §4.2) — here `warn` marks
/// "costlier at this store", not "spending rose"; the two never share a
/// token by coincidence, they are simply the same amber hue serving two
/// distinct semantic roles the design itself assigns it.
class StoreProductRow extends StatelessWidget {
  final Product product;
  final StorePriceComparison? comparison;

  /// Opens this product's page. The row used to be inert, which left the
  /// whole product surface — and the finished price-history screen behind
  /// it — unreachable from anywhere in the app.
  final VoidCallback onTap;

  const StoreProductRow({
    super.key,
    required this.product,
    required this.comparison,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    final comparisonText = _resolveComparisonText(lo);
    final comparisonColor = switch (comparison?.isBetterHere) {
      true => scheme.accent2,
      false => scheme.warn,
      null => scheme.ter,
    };

    // CHRONIC BUG GUARD
    // (`sig:developer-derived-fixed-dp-cell-height-ignores-textScaleFactor`):
    // no fixed `height:` — the row sizes to its own content, so a larger
    // textScaleFactor grows it instead of clipping the comparison line.
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 12.0,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  Text(
                    product.displayName,
                    style: textTheme.headline17.copyWith(color: scheme.ink),
                  ),
                  if (comparisonText != null)
                    Text(
                      comparisonText,
                      style: textTheme.footnote13.copyWith(
                        color: comparisonColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
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

  String? _resolveComparisonText(AppLocalizations lo) {
    final result = comparison;
    if (result == null) return null;

    return switch (result.key) {
      EStorePriceComparisonKey.onlyHere => lo.onlyHere,
      EStorePriceComparisonKey.cheapestOf =>
        lo.cheapestOf(result.params[0] as int),
      EStorePriceComparisonKey.cheaperBy => lo.cheaperBy(
          result.params[0] as String,
          result.params[1] as int,
          result.params[2] as String,
        ),
    };
  }
}
