import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/routes/presentation/error_message_widget.dart';
import '../../../../../core/routes/presentation/loading_data_widget.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../bloc/stores_bloc/stores_bloc.dart';
import 'widgets/store_body.dart';

/// `StorePageRoute` — the Stores branch of the 5-tab shell
/// (design_spendlens.md §5). Selecting a store pushes `StoreDetailPageRoute`
/// as a TOP-LEVEL route (above the shell), which is why that push hides the
/// bottom pill structurally rather than via a flag.
///
/// [StoresBloc] is an app-lifetime, `registerLazySingleton` bloc dispatched
/// once from `main()` (BLoC rule A3.8) — this page reads the EXISTING
/// instance via `context.read`, it never constructs its own.
class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: CustomAppBar(title: Text(lo.tabStores)),
      body: BlocBuilder<StoresBloc, StoresState>(
        builder: (context, state) {
          if (state.isInitial || state.isLoading) {
            return const LoadingDataWidget();
          }
          if (state.isFailed) {
            return ErrorMessageWidget(message: state.errorMessage);
          }
          return StoreBody(state: state);
        },
      ),
    );
  }
}
