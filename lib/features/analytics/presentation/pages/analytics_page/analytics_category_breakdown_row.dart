import '../../../../category/domain/models/category/category.dart';

/// One row of the per-category breakdown card — already resolved to a
/// display category/amount/share, a plain UI-layer value never stored as
/// bloc state (BLoC rule A3.1 — no `filteredX`/`sortedX` state).
///
/// Bridges the calculator's `CategoryShare` (which carries a raw
/// `categoryId` string) to the UI, which needs the resolved [Category]
/// object for its color/display-name lookups.
class AnalyticsCategoryBreakdownRow {
  final Category category;
  final double amount;
  final double sharePercent;

  const AnalyticsCategoryBreakdownRow({
    required this.category,
    required this.amount,
    required this.sharePercent,
  });
}
