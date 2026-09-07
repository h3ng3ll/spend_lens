import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/routes/presentation/error_message_widget.dart';
import '../../../../../core/routes/presentation/loading_data_widget.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../category/domain/repositories/i_category_local_repository.dart';
import '../../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../../store/domain/repositories/i_store_local_repository.dart';
import '../../bloc/history_bloc/history_bloc.dart';
import 'widgets/history_body.dart';

/// `HistoryPageRoute` — the History branch of the 5-tab shell
/// (design_spendlens.md §5).
///
/// [HistoryBloc] is screen-scoped (`registerFactory` semantics): built here
/// in `initState`, closed in `dispose` — never registered in `main()`
/// (BLoC rule A3.8).
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final HistoryBloc _historyBloc = HistoryBloc(
    expenseLocalRepository: getIt<IExpenseLocalRepository>(),
    categoryLocalRepository: getIt<ICategoryLocalRepository>(),
    storeLocalRepository: getIt<IStoreLocalRepository>(),
  )..add(const HistoryEvent.watch());

  @override
  void dispose() {
    _historyBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: CustomAppBar(title: Text(lo.tabHistory)),
      body: BlocProvider<HistoryBloc>.value(
        value: _historyBloc,
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state.isInitial || state.isLoading) {
              return const LoadingDataWidget();
            }
            if (state.isFailed) {
              return ErrorMessageWidget(message: state.errorMessage);
            }
            return HistoryBody(state: state);
          },
        ),
      ),
    );
  }
}
