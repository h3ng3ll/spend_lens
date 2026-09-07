import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../settings/presentation/bloc/settings_bloc/settings_bloc.dart';
import '../../../../domain/models/home_snapshot.dart';
import '../../../utils/home_calculations.dart';
import 'home_categories_card.dart';

/// Computes this month's top [kHomeTopCategoryCount] categories from
/// [snapshot] and hands them to [HomeCategoriesCard]. Renders nothing when
/// there is no spend recorded in the current month — a truly-empty app is
/// handled one level up by [HomeEmptyState], and a month with zero spend
/// but a non-empty history simply omits this card, matching the design
/// (`hint-placeholder-count="4"` describes the MAX, not a guaranteed count).
class HomeCategoriesContainer extends StatelessWidget {
  final HomeSnapshot snapshot;

  const HomeCategoriesContainer({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final thisMonthExpenses = expensesInMonth(
      snapshot.expenses,
      year: now.year,
      month: now.month - 1,
    );
    final topCategories = topCategoriesThisMonth(
      thisMonthExpenses,
      snapshot.categories,
    );

    if (topCategories.isEmpty) return const SizedBox.shrink();

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        final numberFormat = NumberFormat.decimalPattern();
        final currencyCode = settingsState.settings.currencyCode;

        return HomeCategoriesCard(
          categories: topCategories,
          formatAmount: (amount) =>
              '${numberFormat.format(amount.round())} $currencyCode',
        );
      },
    );
  }
}
