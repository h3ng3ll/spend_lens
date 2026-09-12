part of 'receipt_storage_bloc.dart';

/// The UI reads these getters, never the enum directly.
extension ReceiptStorageStateX on ReceiptStorageState {
  bool get isInitial => status == EReceiptStorageStatus.initial;

  bool get isLoading => status == EReceiptStorageStatus.loading;

  bool get isReady => status == EReceiptStorageStatus.ready;

  /// The receipt was deleted elsewhere while this page was open. Not an
  /// error — nothing went wrong, the record is simply gone.
  bool get isNotFound => status == EReceiptStorageStatus.notFound;

  bool get isFailed => status == EReceiptStorageStatus.failed;
}
