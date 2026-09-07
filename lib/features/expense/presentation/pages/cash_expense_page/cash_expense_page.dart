import 'package:flutter/material.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/widgets/custom_app_bar.dart';

/// `CashExpensePageRoute` (design_spendlens.md §5) — a top-level push above
/// the shell for logging a cash expense (`EExpenseSource.cash`) with no
/// receipt.
///
/// M4 minimal placeholder — the real form (amount/category/store/note/date +
/// Save wired to [IExpenseLocalRepository]) is M5.
class CashExpensePage extends StatelessWidget {
  const CashExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: CustomAppBar(title: Text(lo.cashExpense)),
    );
  }
}
