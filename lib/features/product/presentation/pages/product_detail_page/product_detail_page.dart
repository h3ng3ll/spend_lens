import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/app_icons.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/routes/init_router/init_router.dart';
import '../../../../../core/routes/presentation/error_message_widget.dart';
import '../../../../../core/routes/presentation/loading_data_widget.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../../../core/utils/extensions/go_router_x.dart';
import '../../../../../core/widgets/app_empty_state.dart';
import '../../../../../core/widgets/confirm_dialog.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../analytics/domain/models/price_observation/price_observation.dart';
import '../../../../analytics/domain/repositories/i_price_observation_local_repository.dart';
import '../../../../settings/presentation/bloc/settings_bloc/settings_bloc.dart';
import '../../../../store/domain/repositories/i_store_local_repository.dart';
import '../../../domain/models/product/product.dart';
import '../../../domain/repositories/i_product_local_repository.dart';
import '../../bloc/product_detail_bloc/product_detail_bloc.dart';
import '../edit_product_page/edit_product_result.dart';
import '../../sheets/price_point_sheet/price_point_sheet.dart';
import 'widgets/product_detail_body.dart';

/// `ProductDetailPageRoute` — a top-level push above the shell showing one
/// product: what it is, what it has cost over time, and the manual links
/// that let it be compared across stores.
///
/// This is the screen that gives the product entity a face. The price
/// history it charts was previously computed but unreachable: nothing in the
/// app navigated to `PriceHistoryPage`, so a finished inflation view sat
/// dead. The store-detail product rows now land here.
///
/// [ProductDetailBloc] is screen-scoped (`registerFactory` semantics): built
/// here in `initState`, closed in `dispose` — never `main()` (BLoC rule
/// A3.8). Follows `StoreDetailPage`'s exact shape.
class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late final ProductDetailBloc _productDetailBloc = ProductDetailBloc(
    productId: widget.productId,
    productLocalRepository: getIt<IProductLocalRepository>(),
    priceObservationLocalRepository:
        getIt<IPriceObservationLocalRepository>(),
    storeLocalRepository: getIt<IStoreLocalRepository>(),
  )..add(const ProductDetailEvent.watch());

  @override
  void dispose() {
    _productDetailBloc.close();
    super.dispose();
  }

  Product? get _product => _productDetailBloc.state.snapshot?.product;

  Future<void> _onAddPrice() async {
    final result = await PricePointSheet.show(
      context,
      defaultStoreId: _product?.storeId,
    );
    if (result == null || !mounted) return;

    _productDetailBloc.add(
      ProductDetailEvent.addPrice(
        unitPrice: result.unitPrice,
        observedAt: result.observedAt,
        storeId: result.storeId,
        // The settings currency LABELS the amount; it never converts it.
        // Both the history calculator and the store comparator ignore the
        // code by design, so stamping the display currency here is safe.
        currencyCode: context.read<SettingsBloc>().state.settings.currencyCode,
      ),
    );
  }

  Future<void> _onEditPrice(PriceObservation observation) async {
    final result = await PricePointSheet.show(
      context,
      existing: observation,
      defaultStoreId: _product?.storeId,
    );
    if (result == null || !mounted) return;

    _productDetailBloc.add(
      ProductDetailEvent.updatePrice(
        observationId: observation.id,
        unitPrice: result.unitPrice,
        observedAt: result.observedAt,
        storeId: result.storeId,
      ),
    );
  }

  /// Opens the receipt a scanned price came from.
  ///
  /// The receipt is what DESCRIBES that price, so it is the only place a
  /// correction sticks: `RecordPriceObservationsUseCase` rebuilds this
  /// observation from the receipt's lines every time the receipt is saved,
  /// which would silently overwrite an edit made here.
  void _onOpenReceipt(PriceObservation observation) {
    final receiptId = observation.receiptId;
    if (receiptId == null) return;
    EditReceiptPageRoute(receiptId: receiptId).push<void>(context);
  }

  Future<void> _onDeletePrice(PriceObservation observation) async {
    final lo = AppLocalizations.of(context);
    await ConfirmDialog.show(
      context,
      title: lo.deletePrice,
      body: lo.deletePriceConfirm,
      confirmLabel: lo.deletePrice,
      cancelLabel: lo.cancel,
      onConfirm: () => _productDetailBloc.add(
        ProductDetailEvent.deletePrice(observation.id),
      ),
    );
  }

  /// Opens the edit sheet and dispatches ONLY what actually changed.
  ///
  /// Field-by-field so an untouched value never bumps `updatedAt` and never
  /// queues a pointless sync write — and so renaming does not also re-stamp
  /// the store, which would look like an edit the user did not make.
  Future<void> _onEdit() async {
    final product = _product;
    if (product == null) return;

    final result = await EditProductPageRoute(
      productId: product.id,
    ).push<EditProductResult>(context);
    if (result == null || !mounted) return;

    if (result.displayName != product.displayName) {
      _productDetailBloc.add(ProductDetailEvent.rename(result.displayName));
    }
    if (result.storeId != product.storeId) {
      _productDetailBloc.add(ProductDetailEvent.setStore(result.storeId));
    }
    final categoryId = result.categoryId;
    if (categoryId != null && categoryId != product.defaultCategoryId) {
      _productDetailBloc.add(ProductDetailEvent.setCategory(categoryId));
    }
    if (result.unit != product.defaultUnit) {
      _productDetailBloc.add(ProductDetailEvent.setUnit(result.unit));
    }
  }

  void _onDelete() =>
      _productDetailBloc.add(const ProductDetailEvent.deleteProduct());

  void _onOpenFullHistory() =>
      PriceHistoryPageRoute(productId: widget.productId).push<void>(context);

  bool _listenWhenLeaving(
    ProductDetailState previous,
    ProductDetailState current,
  ) {
    return (!previous.isNotFound && current.isNotFound) ||
        (!previous.isDeleted && current.isDeleted);
  }

  void _onLeave(BuildContext context, ProductDetailState state) {
    context.goBack();
  }

  bool _listenWhenWriteFailed(
    ProductDetailState previous,
    ProductDetailState current,
  ) {
    return !previous.isWriteFailed && current.isWriteFailed;
  }

  void _onWriteFailed(BuildContext context, ProductDetailState state) =>
      UiMessageService.showError(
        AppLocalizations.of(context).tSaveFailedGeneric,
      );

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: CustomAppBar(title: Text(lo.productTitle)),
      body: BlocProvider<ProductDetailBloc>.value(
        value: _productDetailBloc,
        child: MultiBlocListener(
          listeners: [
            BlocListener<ProductDetailBloc, ProductDetailState>(
              listenWhen: _listenWhenLeaving,
              listener: _onLeave,
            ),
            BlocListener<ProductDetailBloc, ProductDetailState>(
              listenWhen: _listenWhenWriteFailed,
              listener: _onWriteFailed,
            ),
          ],
          child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
            builder: (context, state) {
              if (state.isFailed) {
                return ErrorMessageWidget(message: state.errorMessage);
              }
              if (state.isNotFound) {
                return Center(
                  child: HorizontalPadding(
                    child: AppEmptyState(
                      icon: AppIcons.emptyReceipt,
                      title: lo.priceHistoryNotFoundTitle,
                      body: lo.priceHistoryNotFoundBody,
                    ),
                  ),
                );
              }
              if (state.isReady && state.snapshot?.product != null) {
                return ProductDetailBody(
                  snapshot: state.snapshot!,
                  onAddPrice: _onAddPrice,
                  onEditPrice: _onEditPrice,
                  onOpenReceipt: _onOpenReceipt,
                  onDeletePrice: _onDeletePrice,
                  onDelete: _onDelete,
                  onEdit: _onEdit,
                  onOpenFullHistory: _onOpenFullHistory,
                );
              }
              return const LoadingDataWidget();
            },
          ),
        ),
      ),
    );
  }
}
