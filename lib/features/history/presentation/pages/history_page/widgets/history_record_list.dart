import 'package:flutter/material.dart';

import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../category/domain/models/category/category.dart';
import '../../../../../expense/domain/models/expense/expense.dart';
import '../../../../../store/domain/models/store/store.dart';
import 'history_record_row.dart';

/// The populated list card (design_spendlens.md — History artboard's
/// `historyRows` card): one [HistoryRecordRow] per filtered/sorted
/// [expenses] entry, most-recent first, wrapped in the shared
/// [AppSectionCard] shell.
///
/// Layout only (A6, Container Rule) — [HistoryRecordRow] resolves its own
/// view data and navigation; this widget only sorts and lays the rows out.
class HistoryRecordList extends StatelessWidget {
  final List<Expense> expenses;
  final List<Category> categories;
  final List<Store> stores;

  const HistoryRecordList({
    super.key,
    required this.expenses,
    required this.categories,
    required this.stores,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...expenses]
      ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));

    return AppSectionCard(
      // The design's `padding:0 20px` on the rows card: horizontal inset
      // only, so each row's text clears the card edge while its bottom
      // divider still spans the full inner width. Vertical spacing belongs
      // to the rows themselves (each is a fixed-height row), so the card
      // adds none.
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < sorted.length; i++)
            HistoryRecordRow(
              expense: sorted[i],
              categories: categories,
              stores: stores,
              showBottomDivider: i != sorted.length - 1,
            ),
        ],
      ),
    );
  }
}
