import '../../../../core/services/ocr/ocr_text_block.dart';
import 'parsed_receipt.dart';
import 'stages/receipt_candidate_builder.dart';
import 'stages/receipt_date_extractor.dart';
import 'stages/receipt_keyword_detector.dart';
import 'stages/receipt_line_grouper.dart';
import 'stages/receipt_price_extractor.dart';
import 'stages/receipt_store_resolver.dart';
import 'stages/receipt_text_normalizer.dart';

/// Orchestrates the 8 parser stages into one [ParsedReceipt]
/// (design_spendlens.md §6/§11).
///
/// Deterministic, no LLM (spec §33). Every stage is independently
/// constructible/testable (see `test/features/receipt/domain/parser/`) —
/// this class only sequences them; it contains no extraction logic of its
/// own.
///
/// The total is resolved EXCLUSIVELY from a keyword-classified line (spec
/// §35) — never from "the largest or last number" on the receipt, which is
/// why a receipt whose largest printed number is a barcode still resolves
/// the correct total (the barcode line is never keyword-classified as
/// `total`).
class ReceiptParser {
  static const _headerLineScanDepth = 5;

  final ReceiptTextNormalizer _textNormalizer;
  final ReceiptLineGrouper _lineGrouper;
  final ReceiptKeywordDetector _keywordDetector;
  final ReceiptPriceExtractor _priceExtractor;
  final ReceiptCandidateBuilder _candidateBuilder;
  final ReceiptStoreResolver _storeResolver;
  final ReceiptDateExtractor _dateExtractor;

  const ReceiptParser({
    this._textNormalizer = const ReceiptTextNormalizer(),
    this._lineGrouper = const ReceiptLineGrouper(),
    this._keywordDetector = const ReceiptKeywordDetector(),
    this._priceExtractor = const ReceiptPriceExtractor(),
    this._candidateBuilder = const ReceiptCandidateBuilder(),
    this._storeResolver = const ReceiptStoreResolver(),
    this._dateExtractor = const ReceiptDateExtractor(),
  });

  ParsedReceipt parse(List<OcrTextBlock> blocks) {
    // Stage 2 — group OCR blocks into logical print lines (handles
    // two-column layouts via bounding-box geometry).
    final groupedLines = _lineGrouper.group(blocks);

    // Stage 1 — normalize each grouped line's text.
    final normalizedLines = groupedLines
        .map(
          (g) => (
            text: _textNormalizer.normalizeLine(g.text),
            confidence: g.averageConfidence,
            lineIndex: g.lineIndex,
          ),
        )
        .where((l) => l.text.isNotEmpty)
        .toList();

    // Stage 7 — store resolver, scanning only the header lines. Resolved
    // BEFORE the item loop so the header line the store name came from
    // (e.g. "KAUFLAND MOLDOVA") is never ALSO offered to the candidate
    // builder as a product line.
    final headerLines = normalizedLines
        .take(_headerLineScanDepth)
        .map((l) => l.text)
        .toList();
    final storeName = _storeResolver.resolve(headerLines);

    // Stage 8 — date extractor, scanning every line (the date can print
    // anywhere in the header/footer depending on the till software).
    // Resolved BEFORE the item loop for the same reason: a header line
    // like "07.09.2026 14:32" carries no product and must never be
    // candidate-built into a spurious item from its trailing digits.
    DateTime? purchasedAt;
    String? dateLine;
    for (final line in normalizedLines) {
      final date = _dateExtractor.extract(line.text);
      if (date != null) {
        purchasedAt = date;
        dateLine = line.text;
        break;
      }
    }

    double? total;
    double? discount;
    final items = <ParsedLineCandidate>[];
    var itemLineIndex = 0;

    final headerLineTexts = headerLines.toSet();

    for (final line in normalizedLines) {
      // A line already consumed as the store name or the purchase date is
      // never ALSO a product candidate — receipts do not print an item on
      // their own header line. The same holds for any OTHER header-window
      // line the store resolver recognizes as administrative noise (an
      // address, phone number, or fiscal id) — e.g. "STR. GHIOCEILOR 1"
      // would otherwise be misread as a product priced at 1.00.
      if (line.text == storeName || line.text == dateLine) continue;
      if (headerLineTexts.contains(line.text) &&
          _storeResolver.isHeaderNoise(line.text)) {
        continue;
      }

      // Stage 3 — classify by printed keyword.
      final kind = _keywordDetector.classify(line.text);

      switch (kind) {
        case EReceiptLineKind.total:
          // §35 — the total is resolved from a keyword-matched line's own
          // price token, never from scanning the whole receipt for the
          // largest number.
          final value = _priceExtractor.extractLastPrice(line.text);
          if (value != null) total = value;
        case EReceiptLineKind.discount:
          final value = _priceExtractor.extractLastPrice(line.text);
          if (value != null) discount = value;
        case EReceiptLineKind.itemCandidate:
          // Stages 4–6 — price + quantity extraction, candidate assembly.
          final candidate = _candidateBuilder.build(
            line: line.text,
            lineConfidence: line.confidence,
            lineIndex: itemLineIndex,
          );
          if (candidate != null) {
            items.add(candidate);
            itemLineIndex++;
          }
      }
    }

    return ParsedReceipt(
      storeName: storeName,
      purchasedAt: purchasedAt,
      total: total,
      discount: discount,
      items: items,
    );
  }
}
