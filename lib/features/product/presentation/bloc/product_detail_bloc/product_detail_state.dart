part of 'product_detail_bloc.dart';

enum EProductDetailStatus { initial, loading, ready, notFound, failed }

@freezed
sealed class ProductDetailState with _$ProductDetailState {
  const factory ProductDetailState({
    @Default(EProductDetailStatus.initial) EProductDetailStatus status,
    ProductDetailSnapshot? snapshot,
    @Default('') String errorMessage,

    /// One-shot signal for the error toast.
    @Default(false) bool lastWriteFailed,

    /// One-shot signal telling the page to pop after a delete.
    @Default(false) bool isDeleted,
  }) = _ProductDetailState;
}
