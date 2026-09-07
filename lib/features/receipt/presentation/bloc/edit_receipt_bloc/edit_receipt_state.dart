part of 'edit_receipt_bloc.dart';

enum EEditReceiptStatus { initial, loading, ready, saved, failed }

@freezed
sealed class EditReceiptState with _$EditReceiptState {
  const factory EditReceiptState({
    @Default(EEditReceiptStatus.initial) EEditReceiptStatus status,
    String? receiptId,
    String? storeId,
    @Default('') String storeName,
    DateTime? purchasedAt,
    double? printedTotal,
    @Default(<EditDraftItem>[]) List<EditDraftItem> items,
    @Default(true) bool matchesTotal,
    String? errorMessage,
  }) = _EditReceiptState;
}
