part of 'edit_receipt_bloc.dart';

enum EEditReceiptStatus { initial, loading, ready, saved, failed }

@freezed
sealed class EditReceiptState with _$EditReceiptState {
  const factory EditReceiptState({
    @Default(EEditReceiptStatus.initial) EEditReceiptStatus status,
    String? receiptId,
    String? storeId,
    @Default('') String storeName,

    /// Whether [storeId] came from an explicit user pick rather than an
    /// auto-match. Carried onto the draft so the save path can decide
    /// whether learning an alias from this receipt is justified.
    @Default(false) bool isStoreUserPicked,

    /// The receipt's category. Seeded from `Receipt.categoryId` on load and
    /// written back on save, which `CreateExpenseFromReceiptUseCase` then
    /// mirrors onto the `Expense` — so the record-detail screen's category
    /// chip follows an edit made here.
    String? categoryId,
    DateTime? purchasedAt,
    double? printedTotal,
    @Default(<EditDraftItem>[]) List<EditDraftItem> items,
    @Default(true) bool matchesTotal,
    String? errorMessage,
  }) = _EditReceiptState;
}
