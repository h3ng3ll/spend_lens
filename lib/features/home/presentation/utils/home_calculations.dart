import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../category/domain/models/category/category.dart';
import '../../../expense/domain/models/expense/expense.dart';
import '../../../store/domain/models/store/store.dart';
import '../../domain/models/home_snapshot.dart';
import 'category_name_resolver.dart';

/// Home shows at most this many category rows (design_spendlens.md — Home
/// artboard's `hint-placeholder-count="4"` on `cats`).
const int kHomeTopCategoryCount = 4;

/// Home shows at most this many recent-activity rows (Home artboard's
/// `hint-placeholder-count="3"` on `recent`).
const int kHomeRecentCount = 3;

/// A single category's spend this month, paired with its share of the
/// month's top category so a progress bar can be drawn — computed here as a
/// plain value, never stored as bloc state (BLoC rule A3.1: no
/// `filteredX`/`sortedX` field or state-extension getter).
class HomeCategorySpend {
  final Category category;
  final double amount;
  final double fractionOfMax;

  const HomeCategorySpend({
    required this.category,
    required this.amount,
    required this.fractionOfMax,
  });
}

/// All expenses whose `occurredAt` falls within [year]/[month] (0-based).
List<Expense> expensesInMonth(
  List<Expense> expenses, {
  required int year,
  required int month,
}) {
  return expenses
      .where((e) => e.occurredAt.year == year && e.occurredAt.month - 1 == month)
      .toList();
}

/// Sums [expenses]' `amount`.
double sumAmounts(List<Expense> expenses) =>
    expenses.fold(0.0, (total, e) => total + e.amount);

/// The previous calendar month/year relative to [year]/[month] (0-based).
({int year, int month}) previousMonth({required int year, required int month}) {
  if (month == 0) return (year: year - 1, month: 11);
  return (year: year, month: month - 1);
}

/// Top [kHomeTopCategoryCount] categories by this-month spend, descending,
/// each paired with its fraction of the highest-spending category's total
/// (used to size each row's progress bar). Categories with zero spend this
/// month are excluded.
List<HomeCategorySpend> topCategoriesThisMonth(
  List<Expense> expensesThisMonth,
  List<Category> categories,
) {
  final byCategory = <String, double>{};
  for (final expense in expensesThisMonth) {
    byCategory.update(
      expense.categoryId,
      (total) => total + expense.amount,
      ifAbsent: () => expense.amount,
    );
  }

  final categoryById = {for (final c in categories) c.id: c};

  final spends = byCategory.entries
      .where((entry) => categoryById.containsKey(entry.key) && entry.value > 0.0)
      .map((entry) => (category: categoryById[entry.key]!, amount: entry.value))
      .toList()
    ..sort((a, b) => b.amount.compareTo(a.amount));

  final top = spends.take(kHomeTopCategoryCount).toList();
  final maxAmount = top.isEmpty ? 0.0 : top.first.amount;

  return top
      .map(
        (entry) => HomeCategorySpend(
          category: entry.category,
          amount: entry.amount,
          fractionOfMax: maxAmount == 0.0 ? 0.0 : entry.amount / maxAmount,
        ),
      )
      .toList();
}

/// The [kHomeRecentCount] most-recently-occurred expenses, descending by
/// `occurredAt`, across the WHOLE expense list (not scoped to the current
/// month — the design's "Recent" card shows the latest activity regardless
/// of period).
List<Expense> recentExpenses(List<Expense> expenses) {
  final sorted = [...expenses]..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
  return sorted.take(kHomeRecentCount).toList();
}

/// Whether [snapshot] has zero expenses at all — the truly-empty condition
/// that swaps the whole hero/actions/cards body for [AppEmptyState]
/// (distinct from "no spend recorded in the CURRENT month", which still
/// shows the hero at 0).
bool isHomeTrulyEmpty(HomeSnapshot snapshot) => snapshot.expenses.isEmpty;

/// "Today" / "Yesterday" / the calendar day, comparing full
/// year+month+day — NOT the shared `DateTimeExt.isToday()`/`isYesterday()`
/// (`core/utils/extensions/date_time_ext.dart`), which compares `day` alone
/// and misfires across a month boundary (e.g. any 1st reads as "yesterday"
/// on the 2nd of an unrelated month). That file is shared core
/// infrastructure this slice does not own; this is a local, correct
/// replacement scoped to Home's own Recent-card meta line.
String _relativeDayLabel(AppLocalizations lo, DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(date.year, date.month, date.day);
  final dayDiff = today.difference(target).inDays;

  if (dayDiff == 0) return lo.today;
  if (dayDiff == 1) return lo.yesterday;
  return '${date.day.toString().padLeft(2, '0')}.'
      '${date.month.toString().padLeft(2, '0')}.${date.year}';
}

/// The Recent row's TITLE for one [expense]: the resolved store name for a
/// receipt-derived expense, or the "Cash" label for a cash one.
///
/// The store is the title rather than the meta line because it is what
/// actually distinguishes one row from another. The category used to hold this
/// slot, and since most expenses fall back to the built-in "Other"
/// (`kUncategorizedCategoryId`), the list read as three identical "Other" rows
/// whose real subject — the shop — was demoted to grey subtext.
String recentExpenseTitle(
  AppLocalizations lo,
  Expense expense,
  List<Store> stores,
) {
  final storeById = {for (final s in stores) s.id: s};
  return expense.storeId != null
      ? (storeById[expense.storeId]?.name ?? lo.cashType)
      : lo.cashType;
}

/// The Recent card's meta line for one [expense]: the category name, then a
/// relative day label, then the clock time in `HH:mm`
/// (design_spendlens.md — Home artboard's `r.meta`).
///
/// The category moves DOWN here from the title (see [recentExpenseTitle]); it
/// still identifies the row, just no longer at the expense of the store.
String recentExpenseMeta(
  AppLocalizations lo,
  Expense expense,
  String categoryName,
) {
  final occurredAt = expense.occurredAt;
  // 24-hour, zero-padded, and built by hand rather than through `DateFormat`:
  // the day label beside it is already locale-resolved through `lo`, and a
  // locale-dependent clock here would render "5:00 PM" next to "Today" in one
  // locale and "17:00" in another for the same row.
  final time =
      '${occurredAt.hour.toString().padLeft(2, '0')}:'
      '${occurredAt.minute.toString().padLeft(2, '0')}';

  return '$categoryName · ${_relativeDayLabel(lo, occurredAt)} · $time';
}

/// One resolved row's presentation data for Home's "Recent" card — resolved
/// once per expense here (category/store lookups + formatting), never
/// recomputed inside the widget layer.
class HomeRecentEntry {
  final Expense expense;
  final String initial;
  final Color tileBackground;
  final Color tileForeground;
  final String title;
  final String meta;
  final String amountText;

  const HomeRecentEntry({
    required this.expense,
    required this.initial,
    required this.tileBackground,
    required this.tileForeground,
    required this.title,
    required this.meta,
    required this.amountText,
  });
}

/// Builds a [HomeRecentEntry] for every expense in [expenses], resolving
/// each one's category (for the tile color/initial and the fallback title)
/// against [categories] and its store (for the meta line) against [stores].
List<HomeRecentEntry> buildRecentEntries(
  AppLocalizations lo,
  List<Expense> expenses,
  List<Category> categories,
  List<Store> stores,
  String currencyCode,
) {
  final categoryById = {for (final c in categories) c.id: c};
  final numberFormat = NumberFormat.decimalPattern();

  return expenses.map((expense) {
    final category = categoryById[expense.categoryId];
    final name = category != null ? resolveCategoryName(lo, category) : lo.catOther;
    final color = category != null
        ? resolveCategoryColor(category)
        : resolveCategoryColorForOther();

    final title = recentExpenseTitle(lo, expense, stores);

    return HomeRecentEntry(
      expense: expense,
      // Keyed off the TITLE now, so the tile letter matches the row's heading
      // rather than showing a category initial beside a store name.
      initial: title.isNotEmpty ? title[0].toUpperCase() : '?',
      // The tile COLOUR still comes from the category — it is the app's
      // category colour coding, and the store carries no colour of its own.
      tileBackground: color.withValues(alpha: 0.13),
      tileForeground: color,
      title: title,
      meta: recentExpenseMeta(lo, expense, name),
      amountText: '${numberFormat.format(expense.amount.round())} $currencyCode',
    );
  }).toList();
}

/// `months0..11` as an ordered list, so callers don't repeat the 12-getter
/// unroll (`PeriodSheet`'s own `_fullMonthLabels` does the same thing,
/// scoped to that widget — this is Home's copy, since neither slice owns
/// the other).
List<String> fullMonthLabels(AppLocalizations lo) => [
  lo.months0,
  lo.months1,
  lo.months2,
  lo.months3,
  lo.months4,
  lo.months5,
  lo.months6,
  lo.months7,
  lo.months8,
  lo.months9,
  lo.months10,
  lo.months11,
];
