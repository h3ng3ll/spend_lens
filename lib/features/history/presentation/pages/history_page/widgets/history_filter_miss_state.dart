import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_empty_state.dart';

/// History's FILTER-MISS condition — the raw expense list has records, but
/// the current search text + record-type filter combination matches none of
/// them.
///
/// CHRONIC BUG GUARD
/// (`sig:filter-miss-empty-state-absent-only-the-unfiltered-empty-state-exists`):
/// this is the branch the last build of this screen OMITTED, letting a
/// filter miss fall through to the list-rendering branch and paint a blank
/// body. It is DELIBERATELY a distinct widget/copy from
/// [HistoryEmptyState] — `historyNoMatchTitle`/`historyNoMatchBody`, never
/// the truly-empty copy — and the caller (`HistoryBody`) must keep the
/// search field and filter row VISIBLE above this state (unlike the
/// truly-empty branch, which hides them) so the user can change what they
/// typed or picked.
class HistoryFilterMissState extends StatelessWidget {
  const HistoryFilterMissState({super.key});

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);

    return AppEmptyState(
      icon: AppIcons.search,
      title: lo.historyNoMatchTitle,
      body: lo.historyNoMatchBody,
    );
  }
}
