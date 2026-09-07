import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/routes/presentation/error_message_widget.dart';
import '../../../../../core/routes/presentation/loading_data_widget.dart';
import '../../../../category/domain/repositories/i_category_local_repository.dart';
import '../../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../../store/domain/repositories/i_store_local_repository.dart';
import '../../bloc/home_bloc/home_bloc.dart';
import 'widgets/home_body.dart';

/// `HomePageRoute` — the Home branch of the 5-tab shell
/// (design_spendlens.md §5).
///
/// [HomeBloc] is screen-scoped (`registerFactory` semantics): built here in
/// `initState`, closed in `dispose` — never registered in `main()`
/// (BLoC rule A3.8).
///
/// No `CustomAppBar` — the Home artboard (`SpendLens Prototype.dc.html`,
/// `data-screen-label="Home"`) has no conventional title bar; its own
/// scrolling body opens directly with the month/year + sync-status row
/// (`HomeHeaderRow`), so the screen shell here is just the themed
/// `Scaffold` background.
///
/// Because there is no `appBar:` slot, this page owns its own TOP inset via
/// `SafeArea(bottom: false)` — `root_page.dart`'s doc comment is explicit
/// that the shell's own `SafeArea` covers only the BOTTOM inset (the tab
/// pill), and "if a future branch page renders a header WITHOUT the
/// `appBar:` slot, that page must handle the top inset itself." `bottom:
/// false` because the shell already owns that inset once; a second one here
/// would double-pad it (recorded chronic bug
/// `db:missing-safearea-top-inset-header-behind-statusbar`).
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeBloc _homeBloc = HomeBloc(
    expenseLocalRepository: getIt<IExpenseLocalRepository>(),
    categoryLocalRepository: getIt<ICategoryLocalRepository>(),
    storeLocalRepository: getIt<IStoreLocalRepository>(),
  )..add(const HomeEvent.watch());

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      body: SafeArea(
        bottom: false,
        child: BlocProvider<HomeBloc>.value(
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
      ),
    );
  }
}
