/// Parser stage 4 — price extractor (design_spendlens.md §6/§11).
///
/// Recognizes the 5 price formats this milestone is verified against:
/// - `104.00` (dot decimal)
/// - `104,00` (comma decimal — Romanian/Moldovan convention)
/// - `104` (bare integer)
/// - `1.234,56` (dot thousands + comma decimal)
/// - `1,234.56` (comma thousands + dot decimal)
///
/// Deterministic, no LLM (spec §33) — pure regex + arithmetic, never a
/// guess at "the largest or last number" on the line.
class ReceiptPriceExtractor {
  static final _priceToken = RegExp(
    r'(\d{1,3}(?:[.,]\d{3})*[.,]\d{2}|\d+)',
  );

  const ReceiptPriceExtractor();

  /// Extracts the LAST price-shaped token on the line — receipt line items
  /// print name-then-price, so the last numeric token is the line's price
  /// (never "the largest number", per §35 — that heuristic is reserved
  /// exclusively for keyword-classified total lines, and even there this
  /// class does not decide which line IS the total; the keyword detector
  /// does).
  double? extractLastPrice(String line) {
    final matches = _priceToken.allMatches(line).toList();
    if (matches.isEmpty) return null;
    return parse(matches.last.group(0)!);
  }

  /// Extracts every price-shaped token on the line, in order.
  List<double> extractAll(String line) {
    return _priceToken
        .allMatches(line)
        .map((m) => parse(m.group(0)!))
        .whereType<double>()
        .toList();
  }

  /// Parses a single price token in ANY of the 5 supported formats into a
  /// `double`. Returns `null` if the token cannot be interpreted as a
  /// price at all.
  double? parse(String token) {
    final trimmed = token.trim();
    if (trimmed.isEmpty) return null;

    final hasDot = trimmed.contains('.');
    final hasComma = trimmed.contains(',');

    String normalized;
    if (hasDot && hasComma) {
      // Whichever separator appears LAST is the decimal separator; the
      // other is a thousands grouping and is stripped.
      final lastDot = trimmed.lastIndexOf('.');
      final lastComma = trimmed.lastIndexOf(',');
      if (lastComma > lastDot) {
        // `1.234,56` — dot thousands, comma decimal.
        normalized = trimmed.replaceAll('.', '').replaceAll(',', '.');
      } else {
        // `1,234.56` — comma thousands, dot decimal.
        normalized = trimmed.replaceAll(',', '');
      }
    } else if (hasComma) {
      // `104,00` — comma decimal (Romanian/Moldovan convention). A comma
      // followed by exactly 3 digits with no other separator is
      // ambiguous with thousands grouping; receipts overwhelmingly use
      // 2-digit comma decimals, so a 3-digit group is treated as
      // thousands and a 1–2 digit group as decimal.
      final parts = trimmed.split(',');
      if (parts.length == 2 && parts[1].length == 3) {
        normalized = trimmed.replaceAll(',', '');
      } else {
        normalized = trimmed.replaceAll(',', '.');
      }
    } else {
      normalized = trimmed;
    }

    return double.tryParse(normalized);
  }
}
