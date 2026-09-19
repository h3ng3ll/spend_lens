import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/routes/presentation/error_message_widget.dart';
import '../../../../../core/routes/presentation/loading_data_widget.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../../../core/utils/extensions/color_ext.dart';
import '../../../../../core/utils/selected_period.dart';
import '../../../../../core/widgets/period_sheet/period_sheet.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../category/domain/models/category/category.dart';
import '../../../../category/domain/models/category/category_display_x.dart';
import '../../../../category/domain/repositories/i_category_local_repository.dart';
import '../../../../expense/domain/models/expense/expense.dart';
import '../../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../../report/domain/models/pdf_report_data.dart';
import '../../../../report/domain/use_cases/export_pdf_report_use_case.dart';
import '../../../../store/domain/repositories/i_store_local_repository.dart';
import '../../../domain/calculator/analytics_calculator.dart';
import '../../../domain/insights/analytics_insight_generator.dart';
import '../../../../settings/presentation/bloc/settings_bloc/settings_bloc.dart';
import '../../bloc/analytics_bloc/analytics_bloc.dart';
import 'analytics_insight_resolver.dart';
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
    storeLocalRepository: getIt<IStoreLocalRepository>(),
  )..add(const AnalyticsEvent.watch());

  /// Guards against a second export starting while one is in flight — each
  /// would spawn its own isolate and write its own temp file.
  bool _isExporting = false;

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

  /// Builds the month report and hands it to the share sheet.
  ///
  /// Everything context-bound — the localized labels, the resolved category
  /// names and colours, the formatted numbers — is computed HERE, on the UI
  /// isolate, because `AppLocalizations`, `AppColorScheme` and `intl`'s
  /// locale data are all unreachable from a background isolate. Only the
  /// finished [PdfReportData] crosses over; the CPU-bound page layout runs
  /// off-thread inside the use case, so the screen keeps scrolling while the
  /// report renders.
  Future<void> _onExportPdf() async {
    if (_isExporting) return;

    final lo = AppLocalizations.of(context);
    final state = _analyticsBloc.state;
    final snapshot = state.snapshot;
    if (snapshot == null) return;

    final currencyCode = context
        .read<SettingsBloc>()
        .state
        .settings
        .currencyCode;

    final periodExpenses = expensesInPeriod(
      snapshot.expenses,
      _selectedPeriod,
    );
    if (periodExpenses.isEmpty) {
      await UiMessageService.showInfo(lo.analyticsEmptyMonthTitle);
      return;
    }

    setState(() => _isExporting = true);
    try {
      final data = _buildReportData(
        lo: lo,
        currencyCode: currencyCode,
        expenses: snapshot.expenses,
        categories: snapshot.categories,
      );

      final result = await getIt<ExportPdfReportUseCase>().call(
        (regular, semiBold) => data(regular, semiBold),
      );

      await SharePlus.instance.share(
        ShareParams(files: [XFile(result.file.path)]),
      );
      await UiMessageService.showSuccess(lo.pdfToast(result.monthLabel));
    } catch (_) {
      await UiMessageService.showError(lo.pdfExportFailed);
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  /// Resolves the whole report payload up-front, returning a builder that
  /// only needs the font bytes the use case loads.
  PdfReportData Function(Uint8List, Uint8List) _buildReportData({
    required AppLocalizations lo,
    required String currencyCode,
    required List<Expense> expenses,
    required List<Category> categories,
  }) {
    final summary = buildMonthlySummary(
      allExpenses: expenses,
      categories: categories,
      year: _selectedPeriod.year,
      month: _selectedPeriod.month,
      displayCurrencyCode: currencyCode,
    );

    final monthLabels = _fullMonthLabels(lo);
    final monthLabel =
        '${monthLabels[_selectedPeriod.month]} ${_selectedPeriod.year}';

    final numberFormat = NumberFormat.decimalPattern();
    final categoryById = {for (final c in categories) c.id: c};

    final rows = <PdfReportCategoryRow>[];
    for (final share in summary.categoryShares) {
      final category = categoryById[share.categoryId];
      if (category == null) continue;
      rows.add(
        PdfReportCategoryRow(
          name: category.displayName(lo),
          amountText: numberFormat.format(share.amount.round()),
          sharePercentText: '${share.sharePercent.round()}%',
          colorArgb: ColorExtension.fromHex(category.colorHex).toARGB32(),
        ),
      );
    }

    final isCurrentMonth = _selectedPeriod == SelectedPeriod.now();
    final topShare = summary.categoryShares.isEmpty
        ? null
        : summary.categoryShares.first;
    final insights = topShare == null
        ? const <String>[]
        : generateInsights(
                summary: summary,
                isCurrentMonth: isCurrentMonth,
                topCategoryId: topShare.categoryId,
                previousMonthAverageDisplay: summary
                    .previousMonthAveragePurchase
                    ?.round()
                    .toString(),
                currentMonthAverageDisplay: summary.averagePurchase
                    .round()
                    .toString(),
              )
              .map(
                (insight) => resolveAnalyticsInsight(lo, categories, insight),
              )
              .toList();

    final percentChange = summary.percentChangeVsPreviousMonth;
    final previousMonthLabel =
        monthLabels[_selectedPeriod.month == 0
            ? 11
            : _selectedPeriod.month - 1];

    final cashPercent = (summary.cashShare * 100).round();

    return (regular, semiBold) => PdfReportData(
      regularFontBytes: regular,
      semiBoldFontBytes: semiBold,
      monthLabel: monthLabel,
      currencyCode: currencyCode,
      totalText: numberFormat.format(summary.total.round()),
      averageText: numberFormat.format(summary.averagePurchase.round()),
      purchaseCountText: summary.purchaseCount.toString(),
      cashSharePercentText: '$cashPercent%',
      receiptSharePercentText: '${100 - cashPercent}%',
      deltaText: percentChange == null
          ? null
          : '${percentChange >= 0 ? '+' : '-'}${percentChange.abs().round()}%',
      deltaLabel: percentChange == null ? null : lo.vs(previousMonthLabel),
      categoryRows: rows,
      insights: insights,
      titleText: lo.tabAnalytics,
      averageLabel: lo.average,
      purchasesLabel: lo.purchases,
      cashLabel: lo.cash,
      categoriesLabel: lo.categories,
      insightsLabel: lo.insights,
      cashVsReceiptsLabel: lo.cashVsReceipts,
      receiptsLowerLabel: lo.receiptsLower,
      cashLowerLabel: lo.cashLower,
      generatedAtText: lo.reportGeneratedAt(
        DateFormat.yMMMd().add_Hm().format(DateTime.now()),
      ),
    );
  }

  List<String> _fullMonthLabels(AppLocalizations lo) => [
    lo.months0,
    lo.months1,
    lo.months2,
    lo.months3,
    lo.months4,
    lo.months5,
    lo.months6,
    lo.months7,
    lo.months8,
    lo.months9,
    lo.months10,
    lo.months11,
  ];

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
                onExportPdf: _onExportPdf,
                isExporting: _isExporting,
              );
            },
          ),
        ),
      ),
    );
  }
}
