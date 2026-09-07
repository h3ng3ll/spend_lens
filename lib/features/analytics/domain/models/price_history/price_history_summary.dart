import 'price_history_point.dart';

/// The price-history calculator's full output for one product (spec
/// §54–57; design_spendlens.md §10/§11).
class PriceHistorySummary {
  final String productId;
  final String currencyCode;
  final List<PriceHistoryPoint> points;

  /// The earliest-to-latest percent change across [points] that actually
  /// [PriceHistoryPoint.hasData], or null when fewer than two data points
  /// exist to compare. Positive means price ROSE.
  final double? percentChangeFirstToLast;

  const PriceHistorySummary({
    required this.productId,
    required this.currencyCode,
    required this.points,
    required this.percentChangeFirstToLast,
  });
}
