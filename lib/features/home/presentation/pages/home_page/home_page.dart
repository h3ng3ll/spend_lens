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
import '../../bloc/home_bloc/home_bloc.dart';
import 'widgets/home_body.dart';

/// `HomePageRoute` — the Home branch of the 5-tab shell
/// (design_spendlens.md §5).
///
/// [HomeBloc] is screen-scoped (`registerFactory` semantics): built here in
/// `initState`, closed in `dispose` — never registered in `main()`
/// (BLoC rule A3.8).
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeBloc _homeBloc = HomeBloc(
    expenseLocalRepository: getIt<IExpenseLocalRepository>(),
    categoryLocalRepository: getIt<ICategoryLocalRepository>(),
  )..add(const HomeEvent.watch());

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: CustomAppBar(title: Text(lo.tabHome)),
      body: BlocProvider<HomeBloc>.value(
        value: _homeBloc,
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.isInitial || state.isLoading) {
              return const LoadingDataWidget();
            }
            if (state.isFailed) {
              return ErrorMessageWidget(message: state.errorMessage);
            }
            return HomeBody(state: state);
          },
        ),
      ),
    );
  }
}
