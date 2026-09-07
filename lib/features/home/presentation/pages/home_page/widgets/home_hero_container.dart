import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../settings/presentation/bloc/settings_bloc/settings_bloc.dart';
import '../../../../domain/models/home_snapshot.dart';
import '../../../utils/home_calculations.dart';
import 'home_hero_section.dart';

/// Computes this month's total, the previous month's total, and the trend
/// direction/percent from [snapshot], then hands the formatted result to
/// [HomeHeroSection] (design_spendlens.md — Home artboard's hero block).
///
/// Reads [SettingsBloc] for the display currency — never a foreign bloc's
/// state read inside `build()` of the PRESENTATIONAL widget itself; this
/// container is the one place that subscribes, matching BLoC rule A3.6.
class HomeHeroContainer extends StatelessWidget {
  final HomeSnapshot snapshot;

  const HomeHeroContainer({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);
    final now = DateTime.now();
    final year = now.year;
    final month = now.month - 1;

    final thisMonthExpenses = expensesInMonth(
      snapshot.expenses,
      year: year,
      month: month,
    );
    final previous = previousMonth(year: year, month: month);
    final previousMonthExpenses = expensesInMonth(
      snapshot.expenses,
      year: previous.year,
      month: previous.month,
    );

    final thisMonthTotal = sumAmounts(thisMonthExpenses);
    final previousMonthTotal = sumAmounts(previousMonthExpenses);
    final spendingRose = thisMonthTotal >= previousMonthTotal;

    final deltaPercent = previousMonthTotal == 0.0
        ? (thisMonthTotal == 0.0 ? 0 : 100)
        : (((thisMonthTotal - previousMonthTotal) / previousMonthTotal) * 100).round();
    final deltaText = '${deltaPercent >= 0 ? '+' : ''}$deltaPercent%';

    final monthLabels = fullMonthLabels(lo);

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        final currencyCode = settingsState.settings.currencyCode;
        final numberFormat = NumberFormat.decimalPattern();

        return HomeHeroSection(
          totalText: numberFormat.format(thisMonthTotal.round()),
          currencyCode: currencyCode,
          deltaText: deltaText,
          spendingRose: spendingRose,
          previousMonthLabel: monthLabels[previous.month],
          previousMonthTotalText: numberFormat.format(previousMonthTotal.round()),
        );
      },
    );
  }
}
