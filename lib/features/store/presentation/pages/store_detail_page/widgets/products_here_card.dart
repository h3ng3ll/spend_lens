import 'package:flutter/material.dart';

import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_empty_state.dart';
import '../../../../../../core/widgets/section_label.dart';
import '../../../../../../core/resources/app_icons.dart';

/// "Products bought here" (design_spendlens.md's Stores artboard,
/// `hasStoreSel` branch's `productsHere` section).
///
/// SCOPE BOUNDARY (M5 vs M7/M8): products/price-comparison rows require
/// scanned Receipts (Receipt → ReceiptItem → Product → PriceObservation),
/// and receipt scanning is M7/M8. M5 is manual-entry-only, so there are
/// ZERO Products in this milestone — this card renders a genuine, honest
/// empty state rather than fabricating rows or hiding the section, so a
/// future milestone's real product list has somewhere to land. The design's
/// `cmpNote` (comparison note) is deliberately OMITTED here: it references
/// price-comparison data that cannot exist without products, so showing it
/// now would state something false.
class ProductsHereCard extends StatelessWidget {
  const ProductsHereCard({super.key});

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10.0,
      children: [
        SectionLabel(text: lo.productsHere),
        AppEmptyState(
          icon: AppIcons.emptyReceipt,
          title: lo.storeNoProductsYet,
          body: lo.storeNoProductsYetBody,
        ),
      ],
    );
  }
}
