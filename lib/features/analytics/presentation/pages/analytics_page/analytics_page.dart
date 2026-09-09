import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/routes/presentation/error_message_widget.dart';
import '../../../../../core/routes/presentation/loading_data_widget.dart';
import '../../../../../core/utils/selected_period.dart';
import '../../../../../core/widgets/period_sheet/period_sheet.dart';
import '../../../../category/domain/repositories/i_category_local_repository.dart';
import '../../../../expense/domain/models/expense/expense.dart';
import '../../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../../settings/presentation/bloc/settings_bloc/settings_bloc.dart';
import '../../bloc/analytics_bloc/analytics_bloc.dart';
import 'analytics_view_helpers.dart';
import 'widgets/analytics_body.dart';

/// `AnalyticsPageRoute` — the Analytics branch of the 5-tab shell
/// (design_spendlens.md §5).
///
/// [AnalyticsBloc] is screen-scoped (`registerFactory` semantics): built
/// here in `initState`, closed in `dispose` — never registered in `main()`
/// (BLoC rule A3.8).
///
/// `StatefulWidget` because the selected reporting period is UI-LOCAL
/// selection state (`SelectedPeriod`, per its own doc comment) — never bloc
/// state, and never a `filteredX` derived field (BLoC rule A3.1).
///
/// This screen builds its own header/title row in the scrolling body
/// (`AnalyticsHeader`) rather than using `CustomAppBar`, matching the
/// design's artboard exactly (title + PDF pill share one row, with the
/// period pill directly beneath) — so it owns its own top inset via
/// `SafeArea` (root_page.dart's doc comment: "If a future branch page
/// renders a header WITHOUT the `appBar:` slot, that page must handle the
/// top inset itself").
class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  late final AnalyticsBloc _analyticsBloc = AnalyticsBloc(
    expenseLocalRepository: getIt<IExpenseLocalRepository>(),
    categoryLocalRepository: getIt<ICategoryLocalRepository>(),
  )..add(const AnalyticsEvent.watch());

  SelectedPeriod _selectedPeriod = SelectedPeriod.now();

  /// Which donut slice the category card highlights. UI-local selection
  /// state, exactly like `_selectedPeriod` — never bloc state (BLoC rule
  /// A3.1). Held here rather than inside the card so a bloc emission
  /// (which rebuilds the whole body) cannot silently reset the user's pick.
  int _selectedCategoryIndex = 0;

  @override
  void dispose() {
    _analyticsBloc.close();
    super.dispose();
  }

  void _onSelectPeriod(SelectedPeriod period) {
    // A new month has its own category ranking, so a slice index carried
    // over from the old one would point at an unrelated category.
    setState(() {
      _selectedPeriod = period;
      _selectedCategoryIndex = 0;
    });
  }

  void _onSelectCategory(int index) {
    setState(() => _selectedCategoryIndex = index);
  }

  Future<void> _onOpenPeriod(List<Expense> allExpenses) async {
    await PeriodSheet.show(
      context,
      selected: _selectedPeriod,
      minSelectableMonth: minSelectableMonth(allExpenses),
      maxSelectableMonth: SelectedPeriod.now().month,
      onSelect: _onSelectPeriod,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final currencyCode = context
        .watch<SettingsBloc>()
        .state
        .settings
        .currencyCode;

    return Scaffold(
      backgroundColor: scheme.bg,
      body: SafeArea(
        bottom: false,
        child: BlocProvider<AnalyticsBloc>.value(
          value: _analyticsBloc,
          child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
            builder: (context, state) {
              if (state.isInitial || state.isLoading) {
                return const LoadingDataWidget();
              }
              if (state.isFailed) {
                return ErrorMessageWidget(message: state.errorMessage);
              }
              return AnalyticsBody(
                state: state,
                selectedPeriod: _selectedPeriod,
                currencyCode: currencyCode,
                onOpenPeriod: () =>
                    _onOpenPeriod(state.snapshot?.expenses ?? const []),
                selectedCategoryIndex: _selectedCategoryIndex,
                onSelectCategory: _onSelectCategory,
              );
            },
          ),
        ),
      ),
    );
  }
}
