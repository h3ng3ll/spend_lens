import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../bloc/history_bloc/history_bloc.dart';

/// Populated / empty presentation for `HistoryPage` (M4 minimal placeholder
/// — the search field and record-type filter chips are M5).
class HistoryBody extends StatelessWidget {
  final HistoryState state;

  const HistoryBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    if (state.expenses.isEmpty) {
      return Center(
        child: Text(
          lo.recent,
          style: textTheme.body17.copyWith(color: scheme.sec),
        ),
      );
    }

    return HorizontalPadding(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        itemCount: state.expenses.length,
        itemBuilder: (context, index) {
          final expense = state.expenses[index];
          return Text(
            '${expense.amount} ${expense.currencyCode}',
            style: textTheme.body17.copyWith(color: scheme.ink),
          );
        },
      ),
    );
  }
}
