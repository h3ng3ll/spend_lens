import '../../../../product/domain/models/product/e_unit.dart';
import 'receipt_price_extractor.dart';

/// The price/quantity EXPRESSION found on a receipt line — a different
/// entity from the product name (design_spendlens.md §6/§11).
///
/// A Moldovan till prints an item as:
///
/// ```
/// NAME  QTY [UNIT] x UNIT_PRICE (=|-) LINE_TOTAL [TAX_CODE]
/// CEAPA, Moldova  0.488 kg x 7.49- 3.66 B
/// ```
///
/// The name is everything BEFORE that expression. Nothing from the
/// expression may ever leak into the name: they are separate entities, and
/// a name that reads `0.500 kg x 116.99= 58.50 A` is a parse failure, not a
/// product.
class ReceiptLineExpression {
  /// Character offset where the expression starts — the name is
  /// `line.substring(0, startIndex)`.
  final int startIndex;

  final double quantity;
  final EUnit unit;

  /// The printed per-unit price (the figure after `x`/`@`).
  final double? unitPrice;

  /// The printed line total (the figure after `=`/`-`), when present.
  final double? lineTotal;

  /// Whether the line actually printed a total SEPARATOR (`=` / `-`).
  ///
  /// This distinguishes two genuinely different shapes that both lack a
  /// parsed total:
  /// - `ROSII 1.2 kg @ 104` — no separator: `104` IS the line total, and
  ///   the per-kg price is derived from it.
  /// - `0.5 kg x 116.99=` — separator printed but the number lost to OCR
  ///   truncation: the total is `qty × unitPrice`.
  ///
  /// Without it, `qty × unitPrice` was applied to the first shape too and
  /// reported `1.2 kg @ 104` as 124.80 instead of 104.00.
  final bool hasPrintedTotalSeparator;

  const ReceiptLineExpression({
    required this.startIndex,
    required this.quantity,
    required this.unit,
    this.unitPrice,
    this.lineTotal,
    this.hasPrintedTotalSeparator = false,
  });
}

/// Locates and decomposes the quantity/price expression on an item line.
///
/// This exists because the previous approach — stripping trailing
/// numeric tokens anchored with `$` — was a NO-OP on every real receipt
/// line: the trailing tax code (`A`/`B`) sits after the numbers, so no
/// anchored pattern ever matched and the entire expression stayed in the
/// product name. Matching the expression structurally, ANYWHERE on the
/// line, is what makes the name/price split reliable.
///
/// Deterministic, no LLM (spec §33).
class ReceiptLineExpressionExtractor {
  /// Unit tokens INCLUDING the OCR confusions this receipt corpus actually
  /// produces: `kg` is read as `kq` or `ka` (g→q, g→a), and `buc`
  /// ("bucata" — piece) as `buc`/`buk`.
  ///
  /// Without `kq`/`ka` a weighed line like `0.156 kq x 32.99` failed the
  /// weighed test, fell through to the count branch, and reported
  /// `qty 1.00` — silently discarding the weight the user actually bought.
  static const _weightUnits = r'k[gqa]|g[rp]?|l';
  static const _pieceUnits = r'bu[ck]|pcs?|szt';

  /// `QTY [UNIT] (x|×|@) UNIT_PRICE [(=|-|—) LINE_TOTAL] [TAX_CODE]`
  ///
  /// The separator before the line total is `=` or `-` (or an OCR-mangled
  /// dash); both appear in the same corpus, sometimes on adjacent lines.
  /// `LINE_TOTAL` is optional because OCR truncates the right edge of a
  /// receipt often enough that the total is simply missing.
  static final _expression = RegExp(
    r'(\d+(?:\s*[.,]\s*\d+)?)\s*'
    '(?:($_weightUnits|$_pieceUnits)\\s*)?'
    r'(?:(\d+(?:\s*[.,]\s*\d+)?)\s*(?:bu[ck]|pcs?)\s*)?'
    r'[x×@]\s*'
    r'(\d+(?:\s*[.,]\s*\d+)?)'
    r'(\s*[=\-—]\s*)?(\d+(?:\s*[.,]\s*\d+)?)?',
    caseSensitive: false,
  );

  final ReceiptPriceExtractor _priceExtractor;

  const ReceiptLineExpressionExtractor([
    this._priceExtractor = const ReceiptPriceExtractor(),
  ]);

  /// Returns the expression on [line], or `null` when the line carries no
  /// `x`/`@` multiplier at all (a self-priced line such as `BREAD 12.50`,
  /// which the candidate builder handles on its own).
  ReceiptLineExpression? extract(String line) {
    final match = _expression.firstMatch(line);
    if (match == null) return null;

    final leadingNumber = _priceExtractor.parse(_compact(match.group(1)));
    final unitToken = match.group(2)?.toLowerCase();
    final pieceCount = _priceExtractor.parse(_compact(match.group(3)));
    final unitPrice = _priceExtractor.parse(_compact(match.group(4)));
    final hasSeparator = match.group(5) != null;
    final lineTotal = hasSeparator
        ? _priceExtractor.parse(_compact(match.group(6)))
        : null;

    final isWeight = unitToken != null && !RegExp(_pieceUnits).hasMatch(unitToken);

    // `830g 1 buc x 23.99` — a PACK SIZE followed by a piece count. The
    // quantity the user bought is the piece count (1), not the pack's
    // gram weight; the 830 g belongs to the product's name/description.
    if (pieceCount != null) {
      return ReceiptLineExpression(
        startIndex: match.start,
        quantity: pieceCount,
        unit: EUnit.piece,
        unitPrice: unitPrice,
        lineTotal: lineTotal,
        hasPrintedTotalSeparator: hasSeparator,
      );
    }

    if (isWeight) {
      // Grams are normalized to kilograms so `unitPrice` stays a
      // comparable per-kg figure (spec §11: `500 g @ 40 -> 80/kg`).
      final isGrams = unitToken.startsWith('g');
      final quantity = leadingNumber ?? 1.0;
      return ReceiptLineExpression(
        startIndex: match.start,
        quantity: isGrams ? quantity / 1000.0 : quantity,
        unit: unitToken == 'l' ? EUnit.liter : EUnit.kilogram,
        unitPrice: unitPrice,
        lineTotal: lineTotal,
        hasPrintedTotalSeparator: hasSeparator,
      );
    }

    return ReceiptLineExpression(
      startIndex: match.start,
      quantity: leadingNumber ?? 1.0,
      unit: EUnit.piece,
      unitPrice: unitPrice,
      lineTotal: lineTotal,
    );
  }

  /// Closes OCR's spaces around a decimal separator (`14. 99` -> `14.99`)
  /// so the price parser sees one token.
  String _compact(String? token) =>
      token == null ? '' : token.replaceAll(RegExp(r'\s+'), '');
}
