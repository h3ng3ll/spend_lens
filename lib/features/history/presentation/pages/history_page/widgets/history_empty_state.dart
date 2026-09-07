import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_empty_state.dart';

/// History's TRULY-empty condition — the raw, unfiltered expense stream is
/// itself empty (zero records across the whole app), not merely "the current
/// search/filter matches nothing".
///
/// CHRONIC BUG GUARD
/// (`sig:filter-miss-empty-state-absent-only-the-unfiltered-empty-state-exists`):
/// this is ONE of the two required, visually distinct empty branches — see
/// `HistoryFilterMissState` for the other. The caller (`HistoryBody`) must
/// render ONLY this branch (search field + filter row HIDDEN) when the raw
/// list is empty, and ONLY the filter-miss branch (search field + filter row
/// STILL VISIBLE) when the raw list is non-empty but the filtered result is.
/// No CTA — M5 has no scanner and Cash-expense entry is reached from the
/// Home/global add action, not from History itself.
///
/// Reads live from the same `IExpenseLocalRepository.watchAll()` stream
/// every other History branch does, so this state also renders correctly
/// after a future "Delete all records" action clears the store elsewhere
/// (`~/.claude/rules/delete_all_records_rules.md`) — no separate wiring
/// needed for that case.
class HistoryEmptyState extends StatelessWidget {
  const HistoryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);

    return AppEmptyState(
      icon: AppIcons.emptyReceipt,
      title: lo.historyNoRecordsTitle,
      body: lo.historyNoRecordsBody,
    );
  }
}
