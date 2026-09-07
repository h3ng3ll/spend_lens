import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../bloc/home_bloc/home_bloc.dart';

/// Populated / empty presentation for `HomePage` (M4 minimal placeholder —
/// the hero total, insight card and Recent-activity list are M5/M6).
class HomeBody extends StatelessWidget {
  final HomeState state;

  const HomeBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    final expenses = state.snapshot?.expenses ?? const [];

    if (expenses.isEmpty) {
      return Center(
        child: Text(
          lo.scanReceipt,
          style: textTheme.body17.copyWith(color: scheme.sec),
        ),
      );
    }

    return Center(
      child: Text(
        '${expenses.length}',
        style: textTheme.detailAmount40.copyWith(color: scheme.ink),
      ),
    );
  }
}
