import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../category/domain/models/category/category.dart';
import '../../../../expense/domain/models/expense/expense.dart';
import '../../../../analytics/domain/models/price_observation/price_observation.dart';
import '../../../../product/domain/models/product/product.dart';
import '../../../../receipt/domain/models/receipt/receipt.dart';
import '../../../../receipt/domain/models/receipt_item/receipt_item.dart';
import '../../../../store/domain/models/store/store.dart';

part 'backup_bundle.freezed.dart';
part 'backup_bundle.g.dart';

/// Canonical export/import payload (design_spendlens.md §6/§9/§11 —
/// "canonical JSON with `schemaVersion`").
///
/// `schemaVersion` is the ONLY field `BackupJsonCodec.decode` inspects before
/// trusting the rest of the payload — see that file's doc comment for the
/// reject/migrate contract. Every list here mirrors one Hive box 1:1; this
/// bundle carries no derived/computed data (spec §49 — Expenses and
/// ReceiptItems are always computed FROM, never stored as a second source of
/// truth for anything else, and that discipline extends to the backup file).
@freezed
sealed class BackupBundle with _$BackupBundle {
  const factory BackupBundle({
    required int schemaVersion,
    required DateTime exportedAt,
    @Default(<Receipt>[]) List<Receipt> receipts,
    @Default(<ReceiptItem>[]) List<ReceiptItem> receiptItems,
    @Default(<Product>[]) List<Product> products,
    @Default(<Store>[]) List<Store> stores,
    @Default(<Category>[]) List<Category> categories,
    @Default(<Expense>[]) List<Expense> expenses,
    @Default(<PriceObservation>[]) List<PriceObservation> priceObservations,
  }) = _BackupBundle;

  factory BackupBundle.fromJson(Map<String, dynamic> json) =>
      _$BackupBundleFromJson(json);
}
