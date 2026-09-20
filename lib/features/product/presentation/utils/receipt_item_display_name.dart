/// Resolving what a receipt line should be CALLED.
library;

import '../../../receipt/domain/models/receipt_item/receipt_item.dart';
import '../../domain/models/product/product.dart';

/// The name to show for [item] — its product's CURRENT name when the line is
/// bound to one, else the line's own stored name.
///
/// There is ONE name, on ONE entity: a bound line does not keep a second
/// copy of its product's name, it reads it. `ReceiptItem.normalizedName` is
/// a snapshot taken at save time, so a product renamed afterwards left every
/// line still showing the old text — rename `SET 2 LAVEIE HF 59.98 A` to
/// `SET 2 LAVEIE` and the receipt kept the OCR noise forever, with nothing
/// on screen explaining why the two disagreed.
///
/// The stored field remains the fallback for an UNBOUND line, which has no
/// product to read from, and `rawName` is the last resort for a line that
/// never had a usable name at all.
///
/// [rawName] is never consulted as a rename target — it is what the receipt
/// actually printed and must survive every edit (spec §11).
String receiptItemDisplayName(ReceiptItem item, List<Product> products) {
  final productId = item.productId;
  if (productId != null) {
    for (final product in products) {
      if (product.id != productId) continue;
      if (product.deletedAt != null) break;
      if (product.displayName.trim().isNotEmpty) return product.displayName;
      break;
    }
  }

  if (item.normalizedName.trim().isNotEmpty) return item.normalizedName;
  return item.rawName;
}
