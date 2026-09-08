part of 'receipt_photo_bloc.dart';

@freezed
sealed class ReceiptPhotoEvent with _$ReceiptPhotoEvent {
  /// Subscribes to the receipt's stored photo filename. Dispatched once
  /// from `ReceiptPhotoPage.initState`.
  const factory ReceiptPhotoEvent.load(String receiptId) = _Load;

  /// Replaces this receipt's photo with [file] — the image the user picked
  /// from the library. Carries the picked file only; the bloc owns reading
  /// the bytes, persisting them, and updating `Receipt.imagePath`.
  const factory ReceiptPhotoEvent.replaceFromFile(File file) =
      _ReplaceFromFile;
}
