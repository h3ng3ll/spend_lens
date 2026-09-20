part of 'products_bloc.dart';

enum EProductsStatus { initial, loading, loaded, failed }

@freezed
sealed class ProductsState with _$ProductsState {
  const factory ProductsState({
    @Default(EProductsStatus.initial) EProductsStatus status,
    @Default(<Product>[]) List<Product> products,
    @Default('') String errorMessage,

    /// One-shot pop signal: the picker/create screen closes with this id.
    String? lastCreatedId,

    /// One-shot error signal for the write-failure toast.
    @Default(false) bool lastWriteFailed,
  }) = _ProductsState;
}
