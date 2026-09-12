import 'dart:convert';

import '../../features/receipt/domain/models/receipt/receipt.dart';
import '../../features/receipt/domain/models/receipt_item/receipt_item.dart';

/// Measures how many bytes a receipt's DOCUMENT data occupies, by
/// serializing exactly what the sync engine uploads.
///
/// Computed locally on purpose — "calculated manually" rather than asked of
/// Firestore. A per-receipt server round-trip to size one document would be
/// a network call every time a detail screen opens, for a number that can be
/// derived from data already in hand.
///
/// **This is an ESTIMATE, and the UI says so.** It measures the JSON payload
/// (`toJson()` + UTF-8 length), which is what `pushRecords` sends. Firestore's
/// own accounting is larger: it adds per-field name overhead, document-path
/// length, and index entries. The figure is therefore a lower bound on the
/// true document footprint, and is useful for comparing receipts against each
/// other rather than as a billing figure.
///
/// Deliberately NOT counted toward Profile's storage bar, which measures
/// Firebase Storage photo objects only (`FirebaseStorageService.usedBytes`).
/// Photo bytes and document bytes are reported as two separate figures so
/// neither number silently misstates the other.
class ReceiptSizeCalculator {
  const ReceiptSizeCalculator();

  /// Bytes for [receipt] plus every one of its [items], as uploaded.
  int documentBytes({
    required Receipt receipt,
    required List<ReceiptItem> items,
  }) {
    var total = _jsonBytes(receipt.toJson());
    for (final item in items) {
      total += _jsonBytes(item.toJson());
    }
    return total;
  }

  int _jsonBytes(Map<String, dynamic> json) =>
      utf8.encode(jsonEncode(json)).length;
}
