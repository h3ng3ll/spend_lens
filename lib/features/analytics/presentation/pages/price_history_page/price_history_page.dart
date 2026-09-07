import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/app_icons.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/routes/presentation/error_message_widget.dart';
import '../../../../../core/routes/presentation/loading_data_widget.dart';
import '../../../../../core/widgets/app_empty_state.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../product/domain/repositories/i_product_local_repository.dart';
import '../../../../store/domain/repositories/i_store_local_repository.dart';
import '../../../domain/price_history/dominant_observation_currency.dart';
import '../../../domain/price_history/price_history_calculator.dart';
import '../../../domain/repositories/i_price_observation_local_repository.dart';
import '../../bloc/price_history_bloc/price_history_bloc.dart';
import 'widgets/price_history_body.dart';

/// `PriceHistoryPageRoute` (design_spendlens.md §5) — a top-level push above
/// the shell showing one product's price-over-time bar chart across stores.
///
/// [PriceHistoryBloc] is screen-scoped (`registerFactory` semantics): built
/// here in `initState`, closed in `dispose` — never registered in `main()`
/// (BLoC rule A3.8). Follows `StoreDetailPage`'s exact shape.
class PriceHistoryPage extends StatefulWidget {
  final String productId;

  const PriceHistoryPage({super.key, required this.productId});

  @override
  State<PriceHistoryPage> createState() => _PriceHistoryPageState();
}

class _PriceHistoryPageState extends State<PriceHistoryPage> {
  late final PriceHistoryBloc _priceHistoryBloc = PriceHistoryBloc(
    productId: widget.productId,
    productLocalRepository: getIt<IProductLocalRepository>(),
    priceObservationLocalRepository:
        getIt<IPriceObservationLocalRepository>(),
    storeLocalRepository: getIt<IStoreLocalRepository>(),
  )..add(const PriceHistoryEvent.watch());

  @override
  void dispose() {
    _priceHistoryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: CustomAppBar(title: Text(lo.priceHistoryTitle)),
      body: BlocProvider<PriceHistoryBloc>.value(
        value: _priceHistoryBloc,
        child: BlocBuilder<PriceHistoryBloc, PriceHistoryState>(
          builder: (context, state) {
            if (state.isInitial || state.isLoading) {
              return const LoadingDataWidget();
            }
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
            final snapshot = state.snapshot!;
            final product = snapshot.product!;
            if (state.isEmpty) {
              return Center(
                child: HorizontalPadding(
                  child: AppEmptyState(
                    icon: AppIcons.emptyReceipt,
                    title: lo.priceHistoryNoDataTitle,
                    body: lo.priceHistoryNoDataBody,
                  ),
                ),
              );
            }

            final summary = buildPriceHistory(
              productId: widget.productId,
              allObservations: snapshot.observations,
              displayCurrencyCode: dominantObservationCurrency(
                snapshot.observations,
                widget.productId,
              ),
            );

            return PriceHistoryBody(
              productDisplayName: product.displayName,
              summary: summary,
            );
          },
        ),
      ),
    );
  }
}
