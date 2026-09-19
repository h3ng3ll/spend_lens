import 'package:flutter/material.dart';

import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../domain/models/home_snapshot.dart';
import '../../../utils/home_calculations.dart';
import 'home_month_chart_section.dart';

/// Computes the current month's per-day spend from [snapshot] and hands it
/// to [HomeMonthChartSection].
///
/// The container half of the A3.6 split: every read and computation happens
/// here, and the section widget below receives plain values. The daily
/// series is derived on build and never stored in bloc state (BLoC rule
/// A3.1 — no derived/`filteredX` fields).
class HomeMonthChartContainer extends StatelessWidget {
  final HomeSnapshot snapshot;

  const HomeMonthChartContainer({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);
    final now = DateTime.now();

    final days = dailySpendInMonth(
      snapshot.expenses,
      year: now.year,
      // `dailySpendInMonth` takes a 0-based month, matching every other
      // helper in `home_calculations.dart`.
      month: now.month - 1,
    );

    return HomeMonthChartSection(days: days, label: lo.thisMonth);
  }
}
