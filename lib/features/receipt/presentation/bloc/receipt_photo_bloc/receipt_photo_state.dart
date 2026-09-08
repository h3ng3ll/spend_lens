part of 'receipt_photo_bloc.dart';

enum EReceiptPhotoStatus { initial, loading, ready, failed }

@freezed
sealed class ReceiptPhotoState with _$ReceiptPhotoState {
  const factory ReceiptPhotoState({
    @Default(EReceiptPhotoStatus.initial) EReceiptPhotoStatus status,
    String? receiptId,

    /// The FILENAME stored on `Receipt.imagePath`, never a full path — the
    /// Documents directory it lives under is resolved at render time
    /// because it changes across iOS reinstalls.
    String? imagePath,
  }) = _ReceiptPhotoState;
}
