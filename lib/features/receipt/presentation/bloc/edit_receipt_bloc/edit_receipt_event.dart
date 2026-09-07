part of 'edit_receipt_bloc.dart';

@freezed
sealed class EditReceiptEvent with _$EditReceiptEvent {
  /// One-shot load of the existing [Receipt]/[ReceiptItem]s to seed the
  /// editor (form-bloc one-shot read — hive_rules.md §6 exempts this case
  /// explicitly). Dispatched once from `EditReceiptPage.initState`.
  const factory EditReceiptEvent.load(String receiptId) = _Load;

  /// Resolves [storeId] against `IStoreLocalRepository` and applies it —
  /// used to be a UI-side `getIt<IStoreLocalRepository>().getById(...)`
  /// read in `EditReceiptPage._onPickStore` before dispatching `setStore`
  /// directly; the bloc now owns the lookup so the UI only carries the
  /// picked id forward.
  const factory EditReceiptEvent.pickStore(String storeId) = _PickStore;

  const factory EditReceiptEvent.setStore(String storeId, String storeName) =
      _SetStore;

  const factory EditReceiptEvent.setPurchasedAt(DateTime purchasedAt) =
      _SetPurchasedAt;

  const factory EditReceiptEvent.setPrintedTotal(double? printedTotal) =
      _SetPrintedTotal;

  const factory EditReceiptEvent.updateItemName(String itemId, String name) =
      _UpdateItemName;

  const factory EditReceiptEvent.updateItemQuantity(
    String itemId,
    double quantity,
  ) = _UpdateItemQuantity;

  const factory EditReceiptEvent.updateItemPrice(
    String itemId,
    double lineTotal,
  ) = _UpdateItemPrice;

  const factory EditReceiptEvent.removeItem(String itemId) = _RemoveItem;

  const factory EditReceiptEvent.addItem() = _AddItem;

  const factory EditReceiptEvent.save() = _Save;
}
