/// Parser stage 7 — store resolver (design_spendlens.md §6).
///
/// Receipts print the store/chain name at the very top, before any item
/// lines. This stage does NOT try to match against the `Store` Hive
/// collection (that is a repository-layer concern the use case above the
/// parser performs) — it only extracts the most likely store-name
/// candidate string from the OCR'd header lines, deterministically.
///
/// Deterministic, no LLM (spec §33): the first non-empty, non-numeric,
/// non-keyword line is taken as the store name — receipts do not print
/// numbers or total/discount keywords before their own header.
class ReceiptStoreResolver {
  const ReceiptStoreResolver();

  /// [headerLines] should be the first few grouped lines of the receipt
  /// (the caller decides how many to offer — typically the first 3–5).
  String? resolve(List<String> headerLines) {
    for (final line in headerLines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      if (isHeaderNoise(trimmed)) continue;
      return trimmed;
    }
    return null;
  }

  /// True for a header-window line that is administrative noise — an
  /// address, phone number, or fiscal id — rather than a printable product
  /// name. Exposed (not just used internally by [resolve]) so
  /// [ReceiptParser] can ALSO skip these lines when building item
  /// candidates: an address line with a trailing house number (`STR.
  /// GHIOCEILOR 1`) would otherwise be misread as a product priced at 1.00
  /// by the generic price-extraction path, since nothing else marks it as
  /// non-item.
  bool isHeaderNoise(String line) {
    return _looksLikeAddressOrPhone(line) || _isMostlyDigits(line);
  }

  bool _isMostlyDigits(String line) {
    final digitCount =
        line.split('').where((c) => RegExp(r'[0-9]').hasMatch(c)).length;
    return digitCount >= (line.length / 2).ceil();
  }

  bool _looksLikeAddressOrPhone(String line) {
    final upper = line.toUpperCase();
    return upper.contains('STR.') ||
        upper.contains('TEL') ||
        upper.contains('IDNO') ||
        upper.contains('C/F');
  }
}
