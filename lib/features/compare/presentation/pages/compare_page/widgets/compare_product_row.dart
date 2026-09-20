import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../analytics/domain/models/price_observation/price_observation.dart';
import '../../../../../product/domain/models/product/product.dart';
import '../../../../../product/presentation/utils/product_price_points.dart';

/// One product in a comparison column: its name and its latest price here.
class CompareProductRow extends StatelessWidget {
  final Product product;
  final PriceObservation? latestPrice;
  final VoidCallback onTap;
  final bool showBottomDivider;

  const CompareProductRow({
    super.key,
    required this.product,
    required this.latestPrice,
    required this.onTap,
    required this.showBottomDivider,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    final price = latestPrice;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: showBottomDivider
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: scheme.line, width: 1.0),
                ),
              )
            : null,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 2.0,
          children: [
            Text(
              product.displayName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.subhead15.copyWith(color: scheme.ink),
            ),
            Text(
              price == null
                  ? lo.compareNoPrice
                  : '${formatPrice(price.comparableUnitPrice)} '
                      '${price.currencyCode}',
              style: textTheme.footnote13.copyWith(
                color: price == null ? scheme.ter : scheme.accent2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
