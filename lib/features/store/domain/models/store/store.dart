import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/models/e_sync_status.dart';
import 'e_store_type.dart';

part 'store.freezed.dart';
part 'store.g.dart';

/// A store the user has bought from (design_spendlens.md §3). Created
/// either explicitly ("New store" flow) or resolved by the receipt parser's
/// store-resolver stage from a receipt's printed name.
@freezed
sealed class Store with _$Store {
  const factory Store({
    required String id,
    required String name,

    /// Alternate spellings the parser has seen on printed receipts for this
    /// store (e.g. `'NR1 SRL'` for "Nr.1, Green Hills") — never displayed,
    /// used only to resolve incoming receipts to this [Store].
    @Default(<String>[]) List<String> receiptAliases,
    @Default(EStoreType.other) EStoreType type,
    required DateTime updatedAt,
    DateTime? deletedAt,
    @Default(ESyncStatus.synced) ESyncStatus syncStatus,
  }) = _Store;

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
}
