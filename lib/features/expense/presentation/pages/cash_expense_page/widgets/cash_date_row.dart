import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';

/// The Cash-expense "Date" row (design_spendlens.md's Cash-expense
/// artboard): label + value, always "Today" — M5 does not add a past-date
/// picker (not named in the milestone's scope list); every cash expense is
/// entered for `DateTime.now()`.
class CashDateRow extends StatelessWidget {
  const CashDateRow({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(lo.date, style: textTheme.subhead15.copyWith(color: scheme.sec)),
        Text(lo.today, style: textTheme.subhead15.copyWith(color: scheme.ink)),
      ],
    );
  }
}
