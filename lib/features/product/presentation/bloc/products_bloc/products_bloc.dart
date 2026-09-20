import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../analytics/domain/models/price_observation/price_observation.dart';
import '../../../../analytics/domain/repositories/i_price_observation_local_repository.dart';
import '../../../domain/models/product/e_unit.dart';
import '../../../domain/models/product/product.dart';
import '../../../domain/normalizer/product_name_cleaner.dart';
import '../../../domain/repositories/i_product_local_repository.dart';

part 'products_event.dart';

part 'products_state.dart';

part 'products_state_ext.dart';

part 'products_bloc.freezed.dart';

/// App-lifetime bloc (`registerLazySingleton`, dispatched once from
/// `main()` — never re-dispatched from a screen's `initState`, per BLoC rule
/// A3.8), matching `StoresBloc` and `CategoriesBloc`.
///
/// It is app-lifetime because `ChooseProductPage` is pushed from several
/// parents and must read an ALREADY-LIVE list, and because the picker's
/// quick-create relies on [lastCreatedId] surviving the pushed screen to pop
/// it with the new id — a screen-scoped instance could do neither.
///
/// It also owns every product WRITE, so pages dispatch intents instead of
/// calling the repository directly.
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final IProductLocalRepository _productLocalRepository;
  final IPriceObservationLocalRepository _priceObservationLocalRepository;
  final ProductNameCleaner _nameCleaner;
  final DateTime Function() _now;

  ProductsBloc({
    required IProductLocalRepository productLocalRepository,
    required IPriceObservationLocalRepository priceObservationLocalRepository,
    ProductNameCleaner nameCleaner = const ProductNameCleaner(),
    DateTime Function() now = DateTime.now,
  }) : this._(
          productLocalRepository,
          priceObservationLocalRepository,
          nameCleaner,
          now,
        );

  ProductsBloc._(
    this._productLocalRepository,
    this._priceObservationLocalRepository,
    this._nameCleaner,
    this._now,
  ) : super(const ProductsState()) {
    on<_Watch>(_onWatch);
    on<_QuickCreate>(_onQuickCreate);
    on<_Create>(_onCreate);
  }

  Future<void> _onWatch(_Watch event, Emitter<ProductsState> emit) async {
    emit(state.copyWith(status: EProductsStatus.loading));

    await emit.forEach<List<Product>>(
      _productLocalRepository.watchAll(),
      onData: (products) =>
          state.copyWith(status: EProductsStatus.loaded, products: products),
      onError: (error, stackTrace) => state.copyWith(
        status: EProductsStatus.failed,
        errorMessage: error.toString(),
      ),
    );
  }

  Future<void> _onQuickCreate(
    _QuickCreate event,
    Emitter<ProductsState> emit,
  ) async {
    final trimmed = event.name.trim();
    if (trimmed.isEmpty) return;

    try {
      final product = _buildProduct(
        displayName: trimmed,
        storeId: event.storeId,
        categoryId: null,
        unit: EUnit.piece,
      );
      await _productLocalRepository.save(product);
      emit(state.copyWith(lastCreatedId: product.id, lastWriteFailed: false));
    } catch (_) {
      emit(state.copyWith(lastWriteFailed: true));
    }
  }

  Future<void> _onCreate(_Create event, Emitter<ProductsState> emit) async {
    final trimmed = event.name.trim();
    if (trimmed.isEmpty) return;

    try {
      final product = _buildProduct(
        displayName: trimmed,
        storeId: event.storeId,
        categoryId: event.categoryId,
        unit: event.unit,
      );
      await _productLocalRepository.save(product);

      // The first price is optional: a product with none is legal and
      // renders its empty price list with a live "+ Add price".
      final firstPrice = event.firstPrice;
      if (firstPrice != null && firstPrice > 0) {
        final now = _now();
        await _priceObservationLocalRepository.save(
          PriceObservation(
            id: 'manual_${now.microsecondsSinceEpoch}',
            productId: product.id,
            storeId: event.storeId,
            receiptId: null,
            observedAt: event.observedAt,
            comparableUnitPrice: firstPrice,
            unit: event.unit,
            currencyCode: event.currencyCode,
            updatedAt: now,
          ),
        );
      }

      emit(state.copyWith(lastCreatedId: product.id, lastWriteFailed: false));
    } catch (_) {
      emit(state.copyWith(lastWriteFailed: true));
    }
  }

  /// A hand-created product, normalized the same way the scan path does.
  ///
  /// `normalizedName` runs through the SAME cleaner the receipt pipeline
  /// uses, so a product typed here and the same name later scanned resolve
  /// to one row instead of two — if the two paths derived the key
  /// differently, every manually added product would be duplicated by its
  /// first scan.
  Product _buildProduct({
    required String displayName,
    required String? storeId,
    required String? categoryId,
    required EUnit unit,
  }) {
    final now = _now();
    return Product(
      id: '${now.microsecondsSinceEpoch}_product_manual',
      normalizedName: _nameCleaner.clean(displayName),
      displayName: displayName,
      defaultCategoryId: categoryId,
      defaultUnit: unit,
      storeId: storeId,
      updatedAt: now,
    );
  }
}
