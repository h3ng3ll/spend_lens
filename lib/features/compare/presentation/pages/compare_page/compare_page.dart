import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/routes/init_router/init_router.dart';
import '../../../../../core/routes/presentation/error_message_widget.dart';
import '../../../../../core/routes/presentation/loading_data_widget.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../analytics/domain/repositories/i_price_observation_local_repository.dart';
import '../../../../product/domain/models/product/product.dart';
import '../../../../product/domain/repositories/i_product_local_repository.dart';
import '../../../../store/domain/repositories/i_store_local_repository.dart';
import '../../bloc/compare_bloc/compare_bloc.dart';
import 'widgets/compare_body.dart';

/// `ComparePageRoute` — the Compare tab: two stores side by side, each
/// showing its own products and what they cost there.
///
/// This replaces the per-product manual linking flow, which required the
/// user to pair up products one at a time before anything could be compared.
/// Picking two shops answers the same question in one gesture.
///
/// [CompareBloc] is screen-scoped (`registerFactory` semantics): built here
/// in `initState`, closed in `dispose` — never `main()` (BLoC rule A3.8).
///
/// NO `SafeArea`: this is a shell branch, and `RootPage` owns the bottom
/// inset while `Scaffold`'s `appBar:` slot owns the top. Adding one here
/// would double-pad.
class ComparePage extends StatefulWidget {
  const ComparePage({super.key});

  @override
  State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  late final CompareBloc _compareBloc = CompareBloc(
    storeLocalRepository: getIt<IStoreLocalRepository>(),
    productLocalRepository: getIt<IProductLocalRepository>(),
    priceObservationLocalRepository:
        getIt<IPriceObservationLocalRepository>(),
  )..add(const CompareEvent.watch());

  @override
  void dispose() {
    _compareBloc.close();
    super.dispose();
  }

  Future<void> _onPickLeft() async {
    final pickedId = await ChooseStorePageRoute().push<String>(context);
    if (pickedId == null || !mounted) return;
    _compareBloc.add(CompareEvent.selectLeftStore(pickedId));
  }

  Future<void> _onPickRight() async {
    final pickedId = await ChooseStorePageRoute().push<String>(context);
    if (pickedId == null || !mounted) return;
    _compareBloc.add(CompareEvent.selectRightStore(pickedId));
  }

  void _onOpenProduct(Product product) {
    ProductDetailPageRoute(productId: product.id).push<void>(context);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: CustomAppBar(
        title: Text(lo.compareTitle),
        canGoBack: false,
      ),
      body: BlocProvider<CompareBloc>.value(
        value: _compareBloc,
        child: BlocBuilder<CompareBloc, CompareState>(
          builder: (context, state) {
            if (state.isInitial || state.isLoading) {
              return const LoadingDataWidget();
            }
            if (state.isFailed) {
              return ErrorMessageWidget(message: state.errorMessage);
            }
            return CompareBody(
              snapshot: state.snapshot!,
              leftStoreId: state.leftStoreId,
              rightStoreId: state.rightStoreId,
              onPickLeft: _onPickLeft,
              onPickRight: _onPickRight,
              onOpenProduct: _onOpenProduct,
            );
          },
        ),
      ),
    );
  }
}
