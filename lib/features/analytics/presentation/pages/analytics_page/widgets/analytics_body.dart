import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../bloc/analytics_bloc/analytics_bloc.dart';

/// Populated / empty presentation for `AnalyticsPage` (M4 minimal
/// placeholder — the category breakdown chart and insights card are M6).
class AnalyticsBody extends StatelessWidget {
  final AnalyticsState state;

  const AnalyticsBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    if (state.expenses.isEmpty) {
      return Center(
        child: Text(
          lo.insights,
          style: textTheme.body17.copyWith(color: scheme.sec),
        ),
      );
    }

    return Center(
      child: Text(
        '${state.expenses.length}',
        style: textTheme.statValue20.copyWith(color: scheme.ink),
      ),
    );
  }
}
