/// Parser stage 1 — text normalizer (design_spendlens.md §6).
///
/// Cleans up a single raw OCR line before any of the later stages (keyword
/// detection, price/quantity extraction) look at it. This is DELIBERATELY
/// narrower than `features/product/domain/normalizer` — it never touches
/// product naming/matching, only the raw text shape OCR tends to mangle:
/// stray whitespace, common OCR character confusions in the numeric
/// portion, and stray punctuation noise.
///
/// Deterministic, no LLM (spec §33) — a pure function over a `String`.
class ReceiptTextNormalizer {
  const ReceiptTextNormalizer();

  /// Collapses whitespace and strips stray punctuation OCR sometimes
  /// injects (`_`, `~`, backtick) without touching the digits/letters a
  /// later stage needs to read.
  String normalizeLine(String raw) {
    final withoutNoise = raw.replaceAll(RegExp(r'[_~`]'), ' ');
    return withoutNoise.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Fixes OCR character confusions that occur INSIDE a numeric token —
  /// `O`/`o` -> `0`, `l`/`I`/`|` -> `1`, `S` -> `5`.
  ///
  /// Only applied to a token that already looks numeric-ish (mostly digits
  /// plus the confusable letters and separators) so a genuine word like
  /// "COLA" is never mangled into "C0LA".
  String fixNumericConfusions(String token) {
    if (token.isEmpty || !_looksNumericContext(token)) return token;

    final buffer = StringBuffer();
    for (final char in token.split('')) {
      switch (char) {
        case 'O':
        case 'o':
          buffer.write('0');
        case 'l':
        case 'I':
        case '|':
          buffer.write('1');
        case 'S':
          buffer.write('5');
        default:
          buffer.write(char);
      }
    }
    return buffer.toString();
  }

  /// A token "looks numeric" if EVERY character is a digit, a decimal
  /// separator, or one of the OCR-confusable letters (`O`/`o`/`l`/`I`/`|`/
  /// `S`) AND at least one character is an unambiguous digit or separator.
  ///
  /// The confusable letters are deliberately allowed to be the MAJORITY —
  /// or even ALL — of the token: that is exactly the failure mode this
  /// method exists to catch (`1O4,OO` has only two real digits left after
  /// OCR mis-reads four of the six characters). What must never happen is
  /// treating a real word as numeric: requiring at least one unambiguous
  /// digit/separator is what keeps "TOTAL" or "SUMA" (zero digits, zero
  /// separators) out, since every one of their letters could otherwise be
  /// misread as fitting the confusable set on its own (e.g. "S" -> 5).
  bool _looksNumericContext(String token) {
    final allowedChar = RegExp(r'^[0-9OolIS|.,]+$');
    if (!allowedChar.hasMatch(token)) return false;
    return RegExp(r'[0-9.,]').hasMatch(token);
  }
}
