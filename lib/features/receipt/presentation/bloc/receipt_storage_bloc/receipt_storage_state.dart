part of 'receipt_storage_bloc.dart';

enum EReceiptStorageStatus { initial, loading, ready, notFound, failed }

@freezed
sealed class ReceiptStorageState with _$ReceiptStorageState {
  const factory ReceiptStorageState({
    @Default(EReceiptStorageStatus.initial) EReceiptStorageStatus status,
    ReceiptStorageInfo? info,
    @Default('') String errorMessage,
  }) = _ReceiptStorageState;
}
