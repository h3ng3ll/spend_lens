part of 'receipt_storage_bloc.dart';

@freezed
sealed class ReceiptStorageEvent with _$ReceiptStorageEvent {
  /// Reads this receipt's sizes and sync state. Dispatched once from
  /// `ReceiptStoragePage.initState`.
  const factory ReceiptStorageEvent.load() = _Load;
}
