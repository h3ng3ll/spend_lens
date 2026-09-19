import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/routes/presentation/error_message_widget.dart';
import '../../../../../core/routes/presentation/loading_data_widget.dart';
import '../../../../analytics/domain/repositories/i_price_observation_local_repository.dart';
import '../../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../../product/domain/repositories/i_product_local_repository.dart';
import '../../bloc/store_page_bloc/store_page_bloc.dart';
import '../../bloc/stores_bloc/stores_bloc.dart';
import '../../../domain/repositories/i_store_local_repository.dart';
import 'widgets/store_body.dart';
import 'widgets/store_page_app_bar.dart';

/// `StorePageRoute` — the Stores branch of the 5-tab shell
/// (design_spendlens.md §5). Selecting a store pushes `StoreDetailPageRoute`
/// as a TOP-LEVEL route (above the shell), which is why that push hides the
/// bottom pill structurally rather than via a flag.
///
/// [StoresBloc] is an app-lifetime, `registerLazySingleton` bloc dispatched
/// once from `main()` (BLoC rule A3.8) — this page does NOT read it, since
/// this screen additionally needs per-store visit-count / spent-this-month
/// figures derived from Expenses, and combining a second app-lifetime stream
/// into that bloc's state would violate the "no filtered/derived state"
/// rule (A3.1). Instead it builds its OWN screen-scoped [StorePageBloc]
/// (`registerFactory` semantics — built in `initState`, closed in
/// `dispose`), which independently re-subscribes to
/// [IStoreLocalRepository.watchAll] alongside
/// [IExpenseLocalRepository.watchAll]. Both are app-lifetime singletons
/// resolved via `getIt`, so this does not duplicate any bloc dispatch that
/// `main()` already performs (BLoC rule A3.8 — the rule bars re-dispatching
/// the SAME bloc's stream event twice, not resolving a repository twice).
class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  late final StorePageBloc _storePageBloc = StorePageBloc(
    storeLocalRepository: getIt<IStoreLocalRepository>(),
    expenseLocalRepository: getIt<IExpenseLocalRepository>(),
    productLocalRepository: getIt<IProductLocalRepository>(),
    priceObservationLocalRepository: getIt<IPriceObservationLocalRepository>(),
  )..add(const StorePageEvent.watch());

  @override
  void dispose() {
    _storePageBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: const StorePageAppBar(),
      body: BlocProvider<StorePageBloc>.value(
        value: _storePageBloc,
        child: BlocBuilder<StorePageBloc, StorePageState>(
          builder: (context, state) {
            if (state.isInitial || state.isLoading) {
              return const LoadingDataWidget();
            }
            if (state.isFailed) {
              return ErrorMessageWidget(message: state.errorMessage);
            }
            return StoreBody(snapshot: state.snapshot);
          },
        ),
      ),
    );
  }
}
