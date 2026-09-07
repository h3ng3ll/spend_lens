/// One category's share of a period's spending — the calculator's per-row
/// output (design_spendlens.md §10/§11: "per-category share and count").
/// Plain value class, never bloc state.
class CategoryShare {
  final String categoryId;
  final double amount;
  final int count;
  final double sharePercent;

  const CategoryShare({
    required this.categoryId,
    required this.amount,
    required this.count,
    required this.sharePercent,
  });
}
