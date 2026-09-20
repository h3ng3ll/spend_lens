import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/utils/combine_latest_streams.dart';
import '../../../../analytics/domain/models/price_observation/price_observation.dart';
import '../../../../analytics/domain/repositories/i_price_observation_local_repository.dart';
import '../../../../store/domain/repositories/i_store_local_repository.dart';
import '../../../domain/models/product/e_unit.dart';
import '../../../domain/models/product/product.dart';
import '../../../domain/models/product_detail_snapshot/product_detail_snapshot.dart';
import '../../../../../core/services/product_image_store/product_image_store.dart';
import '../../../domain/repositories/i_product_local_repository.dart';
import '../../../domain/use_cases/remove_product_image_use_case.dart';
import '../../../domain/use_cases/save_product_image_use_case.dart';

part 'product_detail_event.dart';

part 'product_detail_state.dart';

part 'product_detail_state_ext.dart';

part 'product_detail_bloc.freezed.dart';

/// Screen-scoped bloc (`registerFactory` semantics: built in
/// `ProductDetailPage.initState`, closed in `dispose` — never `main()`, per
/// BLoC rule A3.8), taking [productId] as a constructor param.
///
/// Reactive, not static (hive_rules.md §6/§10): combines products + price
/// observations + stores into ONE [ProductDetailSnapshot] stream via
/// `combineLatest3` and subscribes with a SINGLE `emit.forEach`. Every write
/// below lands in a repository and comes back through that same stream, so
/// no handler re-reads state to refresh the page.
///
/// "This product has no prices yet" is an ordinary `ready` state with an
/// empty list — NOT `failed`, and not a dedicated empty status either,
/// because a product created by hand legitimately starts with nothing and
/// must still render its "+ Add price" action (recorded chronic bug
/// `absent-data-mapped-to-failed-status-first-launch-shows-something-went-wrong`).
class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final String productId;
  final IProductLocalRepository _productLocalRepository;
  final IPriceObservationLocalRepository _priceObservationLocalRepository;
  final IStoreLocalRepository _storeLocalRepository;
  final ProductImageStore _imageStore;
  final SaveProductImageUseCase _saveProductImage;
  final RemoveProductImageUseCase _removeProductImage;
  final DateTime Function() _now;

  ProductDetailBloc({
    required this.productId,
    required this._productLocalRepository,
    required this._priceObservationLocalRepository,
    required this._storeLocalRepository,
    required this._imageStore,
    required this._saveProductImage,
    required this._removeProductImage,
    this._now = DateTime.now,
  }) : super(const ProductDetailState()) {
    on<_Watch>(_onWatch);
    on<_AddPrice>(_onAddPrice);
    on<_UpdatePrice>(_onUpdatePrice);
    on<_DeletePrice>(_onDeletePrice);
    on<_Rename>(_onRename);
    on<_SetCategory>(_onSetCategory);
    on<_SetUnit>(_onSetUnit);
    on<_SetStore>(_onSetStore);
    on<_SetImage>(_onSetImage);
    on<_RemoveImage>(_onRemoveImage);
    on<_DeleteProduct>(_onDeleteProduct);
  }

  Future<void> _onWatch(_Watch event, Emitter<ProductDetailState> emit) async {
    emit(state.copyWith(status: EProductDetailStatus.loading));

    await emit.forEach<ProductDetailSnapshot>(
      combineLatest3(
        _productLocalRepository.watchAll(),
        _priceObservationLocalRepository.watchAll(),
        _storeLocalRepository.watchAll(),
        (products, observations, stores) => ProductDetailSnapshot(
          product: _findProduct(products, productId),
          allProducts: products,
          observations: observations,
          stores: stores,
        ),
      ),
      onData: (snapshot) => snapshot.product == null
          ? state.copyWith(status: EProductDetailStatus.notFound)
          : state.copyWith(
              status: EProductDetailStatus.ready,
              snapshot: snapshot,
            ),
      onError: (error, stackTrace) => state.copyWith(
        status: EProductDetailStatus.failed,
        errorMessage: error.toString(),
      ),
    );
  }

  Future<void> _onAddPrice(
    _AddPrice event,
    Emitter<ProductDetailState> emit,
  ) async {
    await _write(emit, () async {
      final now = _now();
      await _priceObservationLocalRepository.save(
        PriceObservation(
          // `manual_` prefixed so it can never collide with the receipt
          // path's `${receiptId}_obs_${item.id}` ids, and so a row's origin
          // is legible in a log or a Firestore console.
          id: 'manual_${now.microsecondsSinceEpoch}',
          productId: productId,
          storeId: event.storeId,
          receiptId: null,
          observedAt: event.observedAt,
          comparableUnitPrice: event.unitPrice,
          unit: state.snapshot?.product?.defaultUnit ?? EUnit.piece,
          currencyCode: event.currencyCode,
          updatedAt: now,
        ),
      );
    });
  }

  Future<void> _onUpdatePrice(
    _UpdatePrice event,
    Emitter<ProductDetailState> emit,
  ) async {
    await _write(emit, () async {
      final existing = await _priceObservationLocalRepository.getById(
        event.observationId,
      );
      if (existing == null) return;
      await _priceObservationLocalRepository.save(
        existing.copyWith(
          comparableUnitPrice: event.unitPrice,
          observedAt: event.observedAt,
          storeId: event.storeId,
          updatedAt: _now(),
        ),
      );
    });
  }

  Future<void> _onDeletePrice(
    _DeletePrice event,
    Emitter<ProductDetailState> emit,
  ) async {
    // SOFT delete: the tombstone has to publish so the removal reaches the
    // user's other devices. `deleteLocalOnly` is only for rows being
    // replaced in the same operation.
    await _write(
      emit,
      () => _priceObservationLocalRepository.delete(event.observationId),
    );
  }

  Future<void> _onRename(
    _Rename event,
    Emitter<ProductDetailState> emit,
  ) async {
    await _write(emit, () async {
      final product = state.snapshot?.product;
      if (product == null) return;

      final name = event.displayName.trim();
      if (name.isEmpty || name == product.displayName) return;

      // Keep the OLD spelling as an alias: `normalizedName` stays the
      // matcher key, so a receipt still printing the previous name keeps
      // resolving to this product instead of creating a duplicate.
      final previous = product.displayName.trim().toLowerCase();
      final aliases = product.aliases.contains(previous) || previous.isEmpty
          ? product.aliases
          : [...product.aliases, previous];

      await _productLocalRepository.save(
        product.copyWith(
          displayName: name,
          aliases: aliases,
          updatedAt: _now(),
        ),
      );
    });
  }

  Future<void> _onSetCategory(
    _SetCategory event,
    Emitter<ProductDetailState> emit,
  ) async {
    await _write(emit, () async {
      final product = state.snapshot?.product;
      if (product == null) return;
      await _productLocalRepository.save(
        product.copyWith(
          defaultCategoryId: event.categoryId,
          updatedAt: _now(),
        ),
      );
    });
  }

  /// Commits the photo the edit page STAGED, then discards the staging slot.
  ///
  /// The staged file is one shared slot, so it is read into memory here and
  /// handed to the use case, which compresses it, writes the per-product slot
  /// and uploads. Leaving the staging file behind would show this photo over
  /// the NEXT product opened.
  Future<void> _onSetImage(
    _SetImage event,
    Emitter<ProductDetailState> emit,
  ) async {
    await _write(emit, () async {
      final product = state.snapshot?.product;
      if (product == null) return;

      final bytes = await _imageStore.readBytes(event.stagedFilename);
      // A staged file that vanished (a cleared cache, a failed copy) leaves
      // the product exactly as it was rather than clearing its photo.
      if (bytes == null) return;

      final updated = await _saveProductImage(
        product: product,
        bytes: bytes,
        uid: event.uid,
      );
      await _productLocalRepository.save(updated.copyWith(updatedAt: _now()));
      await _imageStore.discardStaged();
    });
  }

  Future<void> _onRemoveImage(
    _RemoveImage event,
    Emitter<ProductDetailState> emit,
  ) async {
    await _write(emit, () async {
      final product = state.snapshot?.product;
      if (product == null || product.imageFilename == null) return;

      final updated = await _removeProductImage(
        product: product,
        uid: event.uid,
      );
      await _productLocalRepository.save(updated.copyWith(updatedAt: _now()));
    });
  }

  Future<void> _onSetUnit(
    _SetUnit event,
    Emitter<ProductDetailState> emit,
  ) async {
    await _write(emit, () async {
      final product = state.snapshot?.product;
      if (product == null || product.defaultUnit == event.unit) return;
      await _productLocalRepository.save(
        product.copyWith(defaultUnit: event.unit, updatedAt: _now()),
      );
    });
  }

  Future<void> _onSetStore(
    _SetStore event,
    Emitter<ProductDetailState> emit,
  ) async {
    await _write(emit, () async {
      final product = state.snapshot?.product;
      if (product == null) return;
      await _productLocalRepository.save(
        Product(
          id: product.id,
          normalizedName: product.normalizedName,
          displayName: product.displayName,
          aliases: product.aliases,
          defaultCategoryId: product.defaultCategoryId,
          defaultUnit: product.defaultUnit,
          // Passed positionally rather than via copyWith because copyWith
          // cannot distinguish "leave it" from "clear it" on a nullable, and
          // clearing it IS the "make general purpose" action.
          storeId: event.storeId,
          linkedProductIds: product.linkedProductIds,
          updatedAt: _now(),
          deletedAt: product.deletedAt,
          syncStatus: product.syncStatus,
        ),
      );
    });
  }

  Future<void> _onDeleteProduct(
    _DeleteProduct event,
    Emitter<ProductDetailState> emit,
  ) async {
    final product = state.snapshot?.product;
    if (product == null) return;

    try {
      // The PHOTO first, and its failure is swallowed. Nothing in the sync
      // cycle removes a Storage object on a record delete, so without this
      // the image outlives every record naming it — billed to the user's
      // quota with no code path left that could ever find it. A photo that
      // cannot be deleted must not abort the delete the user asked for.
      try {
        await _removeProductImage(product: product, uid: event.uid);
      } catch (_) {}

      // Unwind the links FIRST. A partner left holding this id would render
      // a phantom row naming a product that no longer exists.
      for (final partnerId in product.linkedProductIds) {
        final partner = await _productLocalRepository.getById(partnerId);
        if (partner == null) continue;
        await _productLocalRepository.save(
          partner.copyWith(
            linkedProductIds: partner.linkedProductIds
                .where((id) => id != product.id)
                .toList(),
            updatedAt: _now(),
          ),
        );
      }

      // This product's price points go with it — they are meaningless once
      // nothing names the product they priced.
      final observations = await _priceObservationLocalRepository.getAll();
      for (final observation in observations) {
        if (observation.productId != product.id) continue;
        await _priceObservationLocalRepository.delete(observation.id);
      }

      await _productLocalRepository.delete(product.id);
      emit(state.copyWith(isDeleted: true));
    } catch (error) {
      emit(state.copyWith(lastWriteFailed: true, errorMessage: '$error'));
      emit(state.copyWith(lastWriteFailed: false));
    }
  }

  /// Runs [action], flipping the one-shot write-failure flag on error.
  ///
  /// The flag is raised and lowered in consecutive emits so a `BlocListener`
  /// fires exactly once per failure — the same one-shot signalling
  /// `StoresBloc` uses for `lastWriteFailed`.
  Future<void> _write(
    Emitter<ProductDetailState> emit,
    Future<void> Function() action,
  ) async {
    try {
      await action();
    } catch (error) {
      emit(state.copyWith(lastWriteFailed: true, errorMessage: '$error'));
      emit(state.copyWith(lastWriteFailed: false));
    }
  }

  Product? _findProduct(List<Product> products, String id) {
    for (final product in products) {
      if (product.id == id) return product;
    }
    return null;
  }
}
