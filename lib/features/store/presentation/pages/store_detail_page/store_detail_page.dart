import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/routes/presentation/error_message_widget.dart';
import '../../../../../core/routes/presentation/loading_data_widget.dart';
import '../../../../../core/utils/extensions/go_router_x.dart';
import '../../../../analytics/domain/repositories/i_price_observation_local_repository.dart';
import '../../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../../product/domain/repositories/i_product_local_repository.dart';
import '../../bloc/store_detail_bloc/store_detail_bloc.dart';
import '../../../domain/repositories/i_store_local_repository.dart';
import 'widgets/edit_store_sheet/edit_store_sheet.dart';
import 'widgets/store_detail_body.dart';
import 'widgets/store_detail_header.dart';

/// `StoreDetailPageRoute` (design_spendlens.md §5) — a TOP-LEVEL push above
/// the shell (`parentNavigatorKey: rootNavigatorKey`), never a branch-2
/// child, because the design hides the bottom pill once a store is
/// selected. That hiding is structural: the pill is built only inside the
/// shell's `builder` (see `root_page.dart`), and a root-navigator push sits
/// above the whole shell widget, so it is absent here by construction.
///
/// [StoreDetailBloc] is screen-scoped (`registerFactory` semantics): built
/// here in `initState`, closed in `dispose` — never registered in `main()`
/// (BLoC rule A3.8).
class StoreDetailPage extends StatefulWidget {
  final String storeId;

  const StoreDetailPage({super.key, required this.storeId});

  @override
  State<StoreDetailPage> createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailPage> {
  late final StoreDetailBloc _storeDetailBloc = StoreDetailBloc(
    storeId: widget.storeId,
    storeLocalRepository: getIt<IStoreLocalRepository>(),
    expenseLocalRepository: getIt<IExpenseLocalRepository>(),
    productLocalRepository: getIt<IProductLocalRepository>(),
    priceObservationLocalRepository:
        getIt<IPriceObservationLocalRepository>(),
  )..add(const StoreDetailEvent.watch());

  @override
  void dispose() {
    _storeDetailBloc.close();
    super.dispose();
  }

  void _onClose() {
    context.goBack();
  }

  /// Opens the edit sheet for this store's name and logo.
  ///
  /// Nothing is read back from it: `StoreDetailBloc` is already subscribed to
  /// the store box, so a committed save repaints this screen through the same
  /// stream that any other write would.
  Future<void> _onEdit() async {
    await EditStoreSheet.show(context, storeId: widget.storeId);
  }

  bool _listenWhenNotFound(
    StoreDetailState previous,
    StoreDetailState current,
  ) {
    return !previous.isNotFound && current.isNotFound;
  }

  void _onNotFound(BuildContext context, StoreDetailState state) {
    context.goBack();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      body: BlocProvider<StoreDetailBloc>.value(
        value: _storeDetailBloc,
        child: SafeArea(
          child: BlocConsumer<StoreDetailBloc, StoreDetailState>(
            listenWhen: _listenWhenNotFound,
            listener: _onNotFound,
            builder: (context, state) {
              if (state.isFailed) {
                return Column(
                  children: [
                    StoreDetailHeader(storeName: '', onClose: _onClose),
                    Expanded(
                      child: ErrorMessageWidget(message: state.errorMessage),
                    ),
                  ],
                );
              }
              if (state.isReady && state.snapshot?.store != null) {
                return StoreDetailBody(
                  snapshot: state.snapshot!,
                  onClose: _onClose,
                  onEdit: _onEdit,
                );
              }
              // Covers isInitial, isLoading and isNotFound (the listener
              // above navigates away on isNotFound; this frame still needs
              // something non-crashing to paint before that pop lands).
              return Column(
                children: [
                  StoreDetailHeader(storeName: '', onClose: _onClose),
                  const Expanded(child: LoadingDataWidget()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
