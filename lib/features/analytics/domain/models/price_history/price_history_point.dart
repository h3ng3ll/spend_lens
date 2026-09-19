/// One bar on the price-history chart (design v1's bar chart,
/// `SpendLens.dc.html`; spec §54–57) — a single period's observed unit
/// price for a product, optionally at a specific store.
///
/// [hasData] is what the chart's bar-fill decision is gated on
/// (`db:chart-zero-value-bar-paints-the-data-fill-so-empty-reads-as-
/// measured` — a period with NO observation must render as a muted,
/// border-only stub, never the same saturated fill as a real measurement).
/// `unitPrice == 0` and "no observation this period" are DELIBERATELY the
/// same rendering (both `hasData: false`) — a price is never legitimately
/// zero, so there is no third state to distinguish here.
class PriceHistoryPoint {
  final DateTime periodStart;
  final double unitPrice;
  final String? storeId;
  final bool hasData;

  const PriceHistoryPoint({
    required this.periodStart,
    required this.unitPrice,
    required this.storeId,
    required this.hasData,
  });

  factory PriceHistoryPoint.empty(DateTime periodStart) => PriceHistoryPoint(
    periodStart: periodStart,
    unitPrice: 0.0,
    storeId: null,
    hasData: false,
  );
}
