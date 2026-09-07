part of 'edit_receipt_bloc.dart';

extension EditReceiptStateX on EditReceiptState {
  bool get isLoading => status == EEditReceiptStatus.loading;

  bool get isReady => status == EEditReceiptStatus.ready;

  bool get isSaved => status == EEditReceiptStatus.saved;

  bool get isFailed => status == EEditReceiptStatus.failed;

  double get itemsTotal =>
      items.fold(0.0, (sum, item) => sum + item.lineTotal);
}
