import '../parsed_receipt.dart';
import 'receipt_line_expression.dart';
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
  final ReceiptLineExpressionExtractor _expressionExtractor;

  const ReceiptCandidateBuilder({
    this._textNormalizer = const ReceiptTextNormalizer(),
    this._priceExtractor = const ReceiptPriceExtractor(),
    this._quantityExtractor = const ReceiptQuantityExtractor(),
    this._expressionExtractor = const ReceiptLineExpressionExtractor(),
  });

  /// Builds a candidate from an already-grouped, already-classified line.
  /// Returns `null` when the line has no extractable price at all — a bare
  /// header/footer fragment with no numeric content is not a product line.
  ParsedLineCandidate? build({
    required String line,
    required double lineConfidence,
    required int lineIndex,
  }) {
    // The price/quantity EXPRESSION is a separate entity from the name, so
    // it is located structurally and the name is taken as the text BEFORE
    // it. The old approach stripped trailing numeric tokens anchored with
    // `$`, which was a NO-OP on every real line — the tax code (`A`/`B`)
    // prints after the numbers, so nothing ever matched and names came out
    // as `0.500 kg x 116.99= 58.50 A`.
    final expression = _expressionExtractor.extract(line);
    if (expression != null) {
      final lineTotal =
          expression.lineTotal ??
          _impliedLineTotal(expression) ??
          _priceExtractor.extractLastPrice(line);
      if (lineTotal == null) return null;

      final rawName = _textNormalizer.normalizeLine(
        line.substring(0, expression.startIndex),
      );
      // An EMPTY name here is legitimate and must not be discarded: it is
      // the continuation half of a wrapped item whose name printed on the
      // line above (`ReceiptParser` pairs it with its `pendingName`).
      return ParsedLineCandidate(
        rawName: rawName,
        quantity: expression.quantity,
        unit: expression.unit,
        unitPrice:
            expression.unitPrice ??
            _quantityExtractor.comparableUnitPrice(
              quantity: expression.quantity,
              lineTotal: lineTotal,
              unit: expression.unit,
            ),
        lineTotal: lineTotal,
        confidence: lineConfidence,
        lineIndex: lineIndex,
      );
    }

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

  /// `qty x unitPrice` with the printed total cut off by OCR — the total
  /// is recoverable arithmetically, which is strictly better than falling
  /// back to "the last number on the line" (that would pick the unit price
  /// and under-report a multi-quantity line).
  double? _impliedLineTotal(ReceiptLineExpression expression) {
    // ONLY when the receipt printed a total separator whose number OCR
    // lost. Without that condition this also fired on `ROSII 1.2 kg @ 104`
    // — where `104` IS the total, not a per-kg rate — and reported 124.80.
    if (!expression.hasPrintedTotalSeparator) return null;
    final unitPrice = expression.unitPrice;
    if (unitPrice == null || expression.quantity <= 0) return null;
    return (unitPrice * expression.quantity * 100).round() / 100;
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

    // The optional trailing letter is the VAT CLASS CODE, and without it
    // this whole method was a no-op on the most common receipt shape there
    // is. `TESS CEAI 180G 139.80 A` ends with `A`, so a `$`-anchored price
    // pattern never matched and the price stayed IN the product name —
    // which is exactly what shipped: items called
    // `TESS CEAI 188G 139.88 A`.
    //
    // A single letter only. Requiring the price immediately before it
    // keeps a real name ending in a short word (`... 1L`) out of range,
    // because the price has to match first.
    final withoutTrailingPrice = withoutQuantityMarker.replaceAll(
      RegExp(r'\s*\d{1,3}(?:[.,]\d{3})*[.,]\d{2}\s*[A-Za-z]?\s*$'),
      '',
    );

    final withoutBareTrailingNumber = withoutTrailingPrice.replaceAll(
      RegExp(r'\s*\d+\s*$'),
      '',
    );

    return _textNormalizer.normalizeLine(withoutBareTrailingNumber);
  }
}
