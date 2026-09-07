import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/routes/presentation/error_message_widget.dart';
import '../../../../../core/routes/presentation/loading_data_widget.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../bloc/analytics_bloc/analytics_bloc.dart';
import 'widgets/analytics_body.dart';

/// `AnalyticsPageRoute` — the Analytics branch of the 5-tab shell
/// (design_spendlens.md §5).
///
/// [AnalyticsBloc] is screen-scoped (`registerFactory` semantics): built
/// here in `initState`, closed in `dispose` — never registered in `main()`
/// (BLoC rule A3.8).
class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  late final AnalyticsBloc _analyticsBloc = AnalyticsBloc(
    expenseLocalRepository: getIt<IExpenseLocalRepository>(),
  )..add(const AnalyticsEvent.watch());

  @override
  void dispose() {
    _analyticsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: CustomAppBar(title: Text(lo.tabAnalytics)),
      body: BlocProvider<AnalyticsBloc>.value(
        value: _analyticsBloc,
        child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
          builder: (context, state) {
            if (state.isInitial || state.isLoading) {
              return const LoadingDataWidget();
            }
            if (state.isFailed) {
              return ErrorMessageWidget(message: state.errorMessage);
            }
            return AnalyticsBody(state: state);
          },
        ),
      ),
    );
  }
}
