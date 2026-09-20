/// What `PricePointSheet` returns — a named class, never a Dart record, per
/// the project's combined-value discipline.
class PricePointResult {
  final double unitPrice;
  final DateTime observedAt;
  final String? storeId;

  const PricePointResult({
    required this.unitPrice,
    required this.observedAt,
    required this.storeId,
  });
}
