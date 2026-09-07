import '../../../../product/domain/models/product/e_unit.dart';
import 'receipt_price_extractor.dart';

/// The parsed quantity/unit-price portion of a receipt line
/// (design_spendlens.md §6/§11 — weighed lines like `1.2 kg @ 104`).
class ExtractedQuantity {
  final double quantity;
  final EUnit unit;
  final double? unitPrice;

  const ExtractedQuantity({
    required this.quantity,
    required this.unit,
    this.unitPrice,
  });
}

/// Parser stage 5 — quantity extractor (design_spendlens.md §6/§11).
///
/// Recognizes:
/// - weighed lines: `1.2 kg @ 104`, `500 g @ 40` (unit + `@`/`x` + unit
///   price)
/// - simple count lines: `2 x 22.90`, `1 × 7.90`
/// - a bare line with no quantity marker at all -> quantity 1, unit piece
///
/// Deterministic, no LLM (spec §33).
class ReceiptQuantityExtractor {
  static final _weighedPattern = RegExp(
    r'(\d+(?:[.,]\d+)?)\s*(kg|g)\s*[x×@]\s*(\d+(?:[.,]\d{1,2})?)',
    caseSensitive: false,
  );

  static final _countPattern = RegExp(
    r'(\d+(?:[.,]\d+)?)\s*[x×@]\s*(\d+(?:[.,]\d{1,2})?)',
    caseSensitive: false,
  );

  final ReceiptPriceExtractor _priceExtractor;

  const ReceiptQuantityExtractor([
    this._priceExtractor = const ReceiptPriceExtractor(),
  ]);

  ExtractedQuantity extract(String line) {
    final weighed = _weighedPattern.firstMatch(line);
    if (weighed != null) {
      final rawQuantity = _priceExtractor.parse(weighed.group(1)!);
      final rawUnitPrice = _priceExtractor.parse(weighed.group(3)!);
      final unitToken = weighed.group(2)!.toLowerCase();

      // `500 g @ 40` is priced per kg on the receipt even though the line
      // itself is in grams — normalize the quantity to kilograms so
      // `unitPrice` is always a comparable per-kg figure (spec §11:
      // `500 g @ 40 -> 80/kg`).
      final quantityInKg = unitToken == 'g'
          ? (rawQuantity ?? 0.0) / 1000.0
          : (rawQuantity ?? 0.0);

      return ExtractedQuantity(
        quantity: quantityInKg,
        unit: EUnit.kilogram,
        unitPrice: rawUnitPrice,
      );
    }

    final count = _countPattern.firstMatch(line);
    if (count != null) {
      final quantity = _priceExtractor.parse(count.group(1)!) ?? 1.0;
      final unitPrice = _priceExtractor.parse(count.group(2)!);
      return ExtractedQuantity(
        quantity: quantity,
        unit: EUnit.piece,
        unitPrice: unitPrice,
      );
    }

    return const ExtractedQuantity(quantity: 1.0, unit: EUnit.piece);
  }

  /// The comparable unit price for a weighed line — e.g. `1.2 kg @ 104`
  /// (line total 104 for 1.2 kg) resolves to `86.67`/kg (spec §11: the
  /// normalizer's unit-normalization test).
  double? comparableUnitPrice({
    required double quantity,
    required double lineTotal,
    required EUnit unit,
  }) {
    if (unit != EUnit.kilogram && unit != EUnit.liter) return null;
    if (quantity <= 0) return null;
    return _roundToCents(lineTotal / quantity);
  }

  double _roundToCents(double value) => (value * 100).round() / 100;
}
