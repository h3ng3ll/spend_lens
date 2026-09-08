part of 'receipt_photo_bloc.dart';

extension ReceiptPhotoStateX on ReceiptPhotoState {
  bool get isLoading => status == EReceiptPhotoStatus.loading;

  bool get isReady => status == EReceiptPhotoStatus.ready;

  bool get isFailed => status == EReceiptPhotoStatus.failed;

  /// True once the receipt resolved but carries no stored photo — the state
  /// the "Choose from library" action exists to resolve.
  bool get hasNoPhoto => isReady && (imagePath == null || imagePath!.isEmpty);
}
