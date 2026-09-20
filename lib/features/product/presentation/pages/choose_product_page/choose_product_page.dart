import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/routes/presentation/error_message_widget.dart';
import '../../../../../core/routes/presentation/loading_data_widget.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../core/widgets/sheet_close_header.dart';
import '../../../../store/domain/models/store/store.dart';
import '../../../../store/domain/repositories/i_store_local_repository.dart';
import '../../../domain/models/product/product.dart';
import '../../bloc/products_bloc/products_bloc.dart';
import 'widgets/choose_product_body.dart';

/// `ChooseProductPageRoute` — a top-level push above the shell for picking a
/// product, popping with its id.
///
/// Scoped with [storeId] to the receipt's store (plus general-purpose
/// products), so a line is never matched onto another shop's product.
///
/// [ProductsBloc] is app-lifetime (`registerLazySingleton`, dispatched once
/// from `main()`, BLoC rule A3.8) — this page reads the EXISTING instance via
/// `context.watch` and never constructs its own.
///
/// KEYBOARD-HIDES-FIELD GUARD (`db:keyboard-hides-text-field`): the search
/// field sits at the TOP of the scrollable body, and the `Scaffold` keeps
/// its default `resizeToAvoidBottomInset: true`.
class ChooseProductPage extends StatefulWidget {
  /// Limit candidates to this store's products plus general-purpose ones.
  final String? storeId;

  const ChooseProductPage({super.key, this.storeId});

  @override
  State<ChooseProductPage> createState() => _ChooseProductPageState();
}

class _ChooseProductPageState extends State<ChooseProductPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Store> _stores = const [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchControllerChanged);
    _loadStores();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchControllerChanged);
    _searchController.dispose();
    super.dispose();
  }

  /// A one-shot read, deliberately: the picker only needs store NAMES to
  /// label its rows, and a store renamed while the sheet is open is not a
  /// case worth a second stream subscription on a transient screen.
  Future<void> _loadStores() async {
    final stores = await getIt<IStoreLocalRepository>().getAll();
    if (!mounted) return;
    setState(() => _stores = stores);
  }

  void _onSearchControllerChanged() => setState(() {});

  void _onClose(BuildContext context) => context.pop();

  void _onPick(BuildContext context, Product product) =>
      context.pop(product.id);

  /// Dispatches the typed query as an intent — `ProductsBloc` owns the
  /// write. The listener below pops with the new id once it arrives.
  void _onQuickCreate(BuildContext context) {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    context.read<ProductsBloc>().add(
          ProductsEvent.quickCreate(name: query, storeId: widget.storeId),
        );
  }

  bool _listenWhenCreated(ProductsState previous, ProductsState current) {
    return current.lastCreatedId != null &&
        previous.lastCreatedId != current.lastCreatedId;
  }

  void _onCreated(BuildContext context, ProductsState state) {
    final createdId = state.lastCreatedId;
    if (createdId == null) return;
    context.pop(createdId);
  }

  bool _listenWhenWriteFailed(ProductsState previous, ProductsState current) {
    return !previous.isWriteFailed && current.isWriteFailed;
  }

  void _onWriteFailed(BuildContext context, ProductsState state) =>
      UiMessageService.showError(
        AppLocalizations.of(context).tSaveFailedGeneric,
      );

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);
    final state = context.watch<ProductsBloc>().state;

    final candidates = scopeProducts(state.products, storeId: widget.storeId);

    return MultiBlocListener(
      listeners: [
        BlocListener<ProductsBloc, ProductsState>(
          listenWhen: _listenWhenCreated,
          listener: _onCreated,
        ),
        BlocListener<ProductsBloc, ProductsState>(
          listenWhen: _listenWhenWriteFailed,
          listener: _onWriteFailed,
        ),
      ],
      child: Scaffold(
        backgroundColor: scheme.bg,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16.0,
              children: [
                HorizontalPadding(
                  child: SheetCloseHeader(
                    title: lo.chooseProduct,
                    onClose: () => _onClose(context),
                  ),
                ),
                Expanded(
                  child: state.isInitial || state.isLoading
                      ? const LoadingDataWidget()
                      : state.isFailed
                      ? ErrorMessageWidget(message: state.errorMessage)
                      : ChooseProductBody(
                          products: candidates,
                          stores: _stores,
                          searchController: _searchController,
                          onQuickCreate: () => _onQuickCreate(context),
                          onPick: (product) => _onPick(context, product),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
