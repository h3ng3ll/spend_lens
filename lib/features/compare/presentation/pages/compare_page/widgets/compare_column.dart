import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';
import '../../../../../analytics/domain/models/price_observation/price_observation.dart';
import '../../../../../product/domain/models/product/product.dart';
import '../../../utils/compare_lists.dart';
import 'compare_product_row.dart';

/// One half of the Compare screen: a store selector and that store's
/// products.
///
/// The two columns are INDEPENDENT — each lists its own store's products
/// whether or not the other carries them, and they scroll separately. There
/// is deliberately no row-matching between the halves: with different-length
/// lists a lock-stepped layout misaligns, and reading two plain lists is
/// what was asked for.
class CompareColumn extends StatelessWidget {
  final String? storeId;
  final String? storeName;
  final List<Product> products;
  final List<PriceObservation> observations;
  final VoidCallback onPickStore;
  final ValueChanged<Product> onOpenProduct;

  const CompareColumn({
    super.key,
    required this.storeId,
    required this.storeName,
    required this.products,
    required this.observations,
    required this.onPickStore,
    required this.onOpenProduct,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10.0,
      children: [
        GestureDetector(
          onTap: onPickStore,
          behavior: HitTestBehavior.opaque,
          child: AppContainer(
            color: scheme.card,
            border: Border.all(color: scheme.line, width: 1.0),
            borderRadius: BorderRadius.circular(14.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 12.0,
            ),
            child: Row(
              spacing: 6.0,
              children: [
                Expanded(
                  child: Text(
                    storeName ?? lo.chooseStore,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.subhead15.copyWith(
                      color: storeName == null ? scheme.ter : scheme.ink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                AppSvgIcon(
                  asset: AppIcons.chevronDown,
                  color: scheme.ter,
                  size: 14.0,
                ),
              ],
            ),
          ),
        ),
        if (products.isEmpty)
          Text(
            lo.compareNoProductsHere,
            style: textTheme.footnote13.copyWith(color: scheme.ter),
          )
        else
          for (var i = 0; i < products.length; i++)
            CompareProductRow(
              product: products[i],
              latestPrice: latestPriceFor(
                observations,
                products[i].id,
                storeId: storeId,
              ),
              onTap: () => onOpenProduct(products[i]),
              showBottomDivider: i != products.length - 1,
            ),
      ],
    );
  }
}
