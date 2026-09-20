part of 'products_bloc.dart';

@freezed
sealed class ProductsEvent with _$ProductsEvent {
  const factory ProductsEvent.watch() = _Watch;

  /// Creates a product from a typed search query — the picker's
  /// `Create '<query>'` row.
  ///
  /// [storeId] is the store the picker was scoped to, so a product created
  /// while correcting a receipt belongs to that receipt's store rather than
  /// becoming a stray general-purpose row.
  const factory ProductsEvent.quickCreate({
    required String name,
    required String? storeId,
  }) = _QuickCreate;

  /// Creates a product AND, when [firstPrice] is given, its first price
  /// point in one operation — the "+ Add product" flow from a store, which
  /// exists so a product can be recorded without the camera.
  const factory ProductsEvent.create({
    required String name,
    required String? storeId,
    required String? categoryId,
    required EUnit unit,
    required double? firstPrice,
    required DateTime observedAt,
    required String currencyCode,
  }) = _Create;
}
