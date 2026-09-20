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

  /// Applies a category picked on the Categories page.
  ///
  /// Carries the id only — the label and dot colour are resolved in the
  /// widget layer from `CategoriesBloc`, exactly as Review does, so the
  /// editor state never holds a denormalized copy of a category's name.
  const factory EditReceiptEvent.setCategory(String categoryId) = _SetCategory;

  const factory EditReceiptEvent.setPurchasedAt(DateTime purchasedAt) =
      _SetPurchasedAt;

  const factory EditReceiptEvent.setPrintedTotal(double? printedTotal) =
      _SetPrintedTotal;

  const factory EditReceiptEvent.updateItemName(String itemId, String name) =
      _UpdateItemName;

  /// Pins a line to a product the user picked, overriding the normalizer's
  /// automatic match.
  ///
  /// Auto-matching is conservative but not infallible — it resolves by name
  /// similarity, so a mis-OCR'd line can land on the wrong product or create
  /// a duplicate. This is the user's correction, and `_onSave` honours it by
  /// SKIPPING the normalizer for that line; re-deriving the match at save
  /// would silently undo the choice they just made.
  const factory EditReceiptEvent.pickItemProduct(
    String itemId,
    String productId,
  ) = _PickItemProduct;

  /// Cycles one item's unit of measure (piece -> kg -> L -> piece).
  ///
  /// The parser's unit is a best guess from OCR text that routinely reads
  /// `kg` as `kq`/`ka`, so the user needs to be able to correct it — and a
  /// weighed line's quantity IS its weight, so the wrong unit mislabels
  /// the number too. NO PAYLOAD beyond the item id: the handler reads the
  /// current unit and advances it, so the UI never computes the next value
  /// (BLoC toggle-event rule).
  const factory EditReceiptEvent.cycleItemUnit(String itemId) =
      _CycleItemUnit;

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
