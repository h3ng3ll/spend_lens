import '../parsed_receipt.dart';
import 'receipt_price_extractor.dart';
import 'receipt_quantity_extractor.dart';
import 'receipt_text_normalizer.dart';

/// Parser stage 6 — product-candidate builder (design_spendlens.md §6/§11).
///
/// Takes a grouped, item-classified line and turns it into a
/// [ParsedLineCandidate]: the raw name (everything before the trailing
/// quantity/price tokens), quantity, unit, unit price, and line total.
///
/// Deterministic, no LLM (spec §33).
class ReceiptCandidateBuilder {
  final ReceiptTextNormalizer _textNormalizer;
  final ReceiptPriceExtractor _priceExtractor;
  final ReceiptQuantityExtractor _quantityExtractor;

  const ReceiptCandidateBuilder({
    this._textNormalizer = const ReceiptTextNormalizer(),
    this._priceExtractor = const ReceiptPriceExtractor(),
    this._quantityExtractor = const ReceiptQuantityExtractor(),
  });

  /// Builds a candidate from an already-grouped, already-classified line.
  /// Returns `null` when the line has no extractable price at all — a bare
  /// header/footer fragment with no numeric content is not a product line.
  ParsedLineCandidate? build({
    required String line,
    required double lineConfidence,
    required int lineIndex,
  }) {
    final lineTotal = _priceExtractor.extractLastPrice(line);
    if (lineTotal == null) return null;

    final extractedQuantity = _quantityExtractor.extract(line);

    final rawName = _stripTrailingNumericTokens(line);
    if (rawName.isEmpty) return null;

    // A weighed line's `unitPrice` from the quantity extractor is the
    // PER-UNIT figure printed on the receipt (e.g. `104` in `1.2 kg @
    // 104`) — but ONLY when the extractor actually matched an explicit
    // `@`/`x` marker. When it fell through to the bare-line default
    // (quantity 1, unit piece, no explicit unit price), the comparable
    // unit price must be computed from the line total instead so a plain
    // weighed line without an explicit multiplier still gets one.
    final unitPrice =
        extractedQuantity.unitPrice ??
        _quantityExtractor.comparableUnitPrice(
          quantity: extractedQuantity.quantity,
          lineTotal: lineTotal,
          unit: extractedQuantity.unit,
        );

    return ParsedLineCandidate(
      rawName: rawName,
      quantity: extractedQuantity.quantity,
      unit: extractedQuantity.unit,
      unitPrice: unitPrice,
      lineTotal: lineTotal,
      confidence: lineConfidence,
      lineIndex: lineIndex,
    );
  }

  /// Removes the trailing quantity/price tokens from the line, leaving
  /// only the product name portion — normalized for stray whitespace but
  /// NOT case-folded or abbreviation-expanded (that is the product
  /// normalizer's job, not the parser's).
  String _stripTrailingNumericTokens(String line) {
    final withoutQuantityMarker = line.replaceAll(
      RegExp(
        r'\s*\d+(?:[.,]\d+)?\s*(?:kg|g)?\s*[x×@]\s*\d+(?:[.,]\d{1,2})?\s*$',
        caseSensitive: false,
      ),
      '',
    );

    final withoutTrailingPrice = withoutQuantityMarker.replaceAll(
      RegExp(r'\s*\d{1,3}(?:[.,]\d{3})*[.,]\d{2}\s*$'),
      '',
    );

    final withoutBareTrailingNumber = withoutTrailingPrice.replaceAll(
      RegExp(r'\s*\d+\s*$'),
      '',
    );

    return _textNormalizer.normalizeLine(withoutBareTrailingNumber);
  }
}
