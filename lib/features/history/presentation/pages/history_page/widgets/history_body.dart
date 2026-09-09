import 'package:flutter/material.dart';

import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../../core/widgets/section_label.dart';
import '../../../bloc/history_bloc/history_bloc.dart';
import 'e_history_filter.dart';
import 'history_empty_state.dart';
import 'history_filter_miss_state.dart';
import 'history_filter_row.dart';
import 'history_record_list.dart';
import 'history_search_field.dart';
import 'history_view_helpers.dart';

/// Populated / empty presentation for `HistoryPage` (design_spendlens.md
/// §10, History artboard).
///
/// CHRONIC BUG GUARD
/// (`sig:filter-miss-empty-state-absent-only-the-unfiltered-empty-state-exists`):
/// this widget branches on TWO DIFFERENT emptiness conditions, and they are
/// kept as two textually distinct `if` blocks on purpose — do not collapse
/// them:
///
/// 1. **Truly empty** — `state.snapshot!.expenses` (the RAW, unfiltered
///    list) is itself empty. Renders [HistoryEmptyState] ALONE — the search
///    field and filter row are NOT built at all, because there is nothing to
///    search or filter yet.
/// 2. **Filter/search miss** — the raw list is non-empty, but
///    [filterHistoryExpenses]'s RESULT is empty for the current
///    `_searchQuery`/`_filter`. Renders the search field + filter row
///    (UNCHANGED, still interactive) ABOVE [HistoryFilterMissState], so the
///    user can see and change what they typed/picked.
///
/// Both branches read from the SAME live snapshot
/// (`IExpenseLocalRepository.watchAll()`, combined in [HistoryBloc]), so
/// branch 1 also renders correctly after a future "Delete all records"
/// action clears the store elsewhere.
class HistoryBody extends StatefulWidget {
  final HistoryState state;

  const HistoryBody({super.key, required this.state});

  @override
  State<HistoryBody> createState() => _HistoryBodyState();
}

class _HistoryBodyState extends State<HistoryBody> {
  String _searchQuery = '';
  EHistoryFilter _filter = EHistoryFilter.all;

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);
  }

  void _onFilterSelected(EHistoryFilter filter) {
    setState(() => _filter = filter);
  }

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);
    final snapshot = widget.state.snapshot;
    final expenses = snapshot?.expenses ?? const [];
    final categories = snapshot?.categories ?? const [];
    final stores = snapshot?.stores ?? const [];

    // Branch 1 — TRULY empty: nothing to search/filter, so neither control
    // is built. See the class doc comment's chronic-bug-guard note.
    if (expenses.isEmpty) {
      return const Center(child: HistoryEmptyState());
    }

    final filtered = filterHistoryExpenses(
      expenses: expenses,
      categories: categories,
      stores: stores,
      lo: lo,
      query: _searchQuery,
      filter: _filter,
    );

    // The search field and filter row are PINNED (they must stay put and
    // interactive in both branches); only what sits beneath them differs.
    // Splitting the two lets the filter-miss card centre itself in the
    // leftover space without the header drifting with it.
    return Padding(
      // 5dp on top of HorizontalPadding's shared 16dp inset. Kept local to
      // History rather than raised in the shared widget, which every other
      // screen also uses.
      padding: const EdgeInsets.only(top: 16.0, left: 5.0, right: 5.0),
      child: HorizontalPadding(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            HistorySearchField(onChanged: _onSearchChanged),
            HistoryFilterRow(selected: _filter, onSelected: _onFilterSelected),
            // Branch 2 — FILTER/SEARCH MISS: the raw list has records, but
            // this exact query+filter combination matches none of them. The
            // search field and filter row above stay visible and
            // interactive; only the body below differs from branch 1.
            if (filtered.isEmpty)
              // Centred in the space left below the pinned header, and
              // stretched to full width: `AppEmptyState`'s Column is
              // `MainAxisSize.min`, so on its own the card shrink-wraps its
              // text and the parent's `CrossAxisAlignment.start` pins that
              // narrow card to the left edge.
              const Expanded(
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: HistoryFilterMissState(),
                  ),
                ),
              )
            else
              // Only the LIST scrolls; the header above it does not.
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16.0,
                    children: [
                      SectionLabel(text: lo.historyAllRecords),
                      HistoryRecordList(
                        expenses: filtered,
                        categories: categories,
                        stores: stores,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
