import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';

import '../../../../../../core/widgets/app_empty_state.dart';

/// Home's truly-empty condition — zero expenses across the whole app, not
/// merely zero this month (design_spendlens.md's carried-forward v1 "Empty
/// state" component, `SpendLens.dc.html`, combined with the Home artboard's
/// copy keys).
///
/// The CTA behaves exactly like the Scan Receipt action button: M5 has no
/// real scanner, so it only shows the same info toast.
class HomeEmptyState extends StatelessWidget {
  final VoidCallback onScanFirstReceipt;

  const HomeEmptyState({super.key, required this.onScanFirstReceipt});

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);

    return AppEmptyState(
      icon: AppIcons.emptyReceipt,
      title: lo.homeNoExpensesTitle,
      body: lo.homeNoExpensesBody,
      actionLabel: lo.scanFirstReceipt,
      onAction: onScanFirstReceipt,
    );
  }
}
