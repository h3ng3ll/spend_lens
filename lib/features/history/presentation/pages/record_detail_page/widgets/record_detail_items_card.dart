import '../../../../../product/domain/models/product/product.dart';
import '../../../../../product/presentation/utils/receipt_item_display_name.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/section_label.dart';
import '../../../../../receipt/domain/models/receipt_item/receipt_item.dart';
import 'record_detail_item_row.dart';

/// The Items card (design_spendlens.md — the Record detail artboard's
/// `dHasItems` branch): an "N ITEMS" section label over one
/// [RecordDetailItemRow] per line, hairline-separated.
///
/// The count in the label goes through the `items` ICU plural, never
/// string concatenation (recorded bug
/// `count-plus-noun-concatenated-without-icu-plural`).
///
/// The caller decides whether this card appears at all — it is built only
/// for a receipt-sourced record with at least one item, so this widget
/// never renders an empty-items placeholder.
class RecordDetailItemsCard extends StatelessWidget {
  final List<ReceiptItem> items;

  /// The products the items resolve to, so each line shows its product's
  /// CURRENT name instead of the copy stamped on it at save time.
  final List<Product> products;

  const RecordDetailItemsCard({
    super.key,
    required this.items,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);
    final lastIndex = items.length - 1;

    return AppSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 4.0,
        children: [
          SectionLabel(text: lo.items(items.length)),
          for (int i = 0; i < items.length; i++)
            RecordDetailItemRow(
              name: receiptItemDisplayName(items[i], products),
              quantity: items[i].quantity,
              unit: items[i].unit,
              unitPrice: items[i].unitPrice,
              lineTotal: items[i].lineTotal,
              showBottomBorder: i != lastIndex,
            ),
        ],
      ),
    );
  }
}
