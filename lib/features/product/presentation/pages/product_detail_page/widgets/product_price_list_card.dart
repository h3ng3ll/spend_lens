import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_empty_state.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/create_new_row.dart';
import '../../../../../../core/widgets/section_label.dart';
import '../../../../../analytics/domain/models/price_observation/price_observation.dart';
import '../../../../../store/domain/models/store/store.dart';
import '../../../utils/product_price_points.dart';
import 'product_price_row.dart';

/// "Prices" — every price point recorded for this product, newest first,
/// plus the action that adds one by hand.
///
/// The add row is rendered in BOTH the populated and the empty branch: a
/// product created by hand starts with no prices, and hiding the only way to
/// give it one behind a non-empty list would strand it permanently.
class ProductPriceListCard extends StatelessWidget {
  final List<PriceObservation> pricePoints;
  final List<Store> stores;
  final VoidCallback onAddPrice;
  final ValueChanged<PriceObservation> onEditPrice;

  /// Opens the receipt a scanned price came from.
  final ValueChanged<PriceObservation> onOpenReceipt;
  final ValueChanged<PriceObservation> onDeletePrice;

  const ProductPriceListCard({
    super.key,
    required this.pricePoints,
    required this.stores,
    required this.onAddPrice,
    required this.onEditPrice,
    required this.onOpenReceipt,
    required this.onDeletePrice,
  });

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10.0,
      children: [
        SectionLabel(text: lo.productPrices),
        if (pricePoints.isEmpty)
          AppEmptyState(
            icon: AppIcons.emptyReceipt,
            title: lo.productNoPricesTitle,
            body: lo.productNoPricesBody,
          )
        else
          AppSectionCard(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < pricePoints.length; i++)
                  ProductPriceRow(
                    observation: pricePoints[i],
                    storeName: storeNameFor(stores, pricePoints[i].storeId),
                    onEdit: () => onEditPrice(pricePoints[i]),
                    onOpenReceipt: () => onOpenReceipt(pricePoints[i]),
                    onDelete: () => onDeletePrice(pricePoints[i]),
                    showBottomDivider: i != pricePoints.length - 1,
                  ),
              ],
            ),
          ),
        CreateNewRow(
          title: lo.addPrice,
          subtitle: lo.addPriceSub,
          onTap: onAddPrice,
        ),
      ],
    );
  }
}
