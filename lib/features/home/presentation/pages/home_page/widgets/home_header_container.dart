import 'package:flutter/material.dart';

import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../utils/home_calculations.dart';
import 'home_header_row.dart';

/// Resolves the current month/year label and hands it to [HomeHeaderRow] —
/// kept separate from that presentational widget so [HomeHeaderRow] itself
/// stays a pure "given a label, render it" component.
class HomeHeaderContainer extends StatelessWidget {
  const HomeHeaderContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);
    final now = DateTime.now();
    final monthLabels = fullMonthLabels(lo);

    return HomeHeaderRow(monthYearLabel: '${monthLabels[now.month - 1]} ${now.year}');
  }
}
