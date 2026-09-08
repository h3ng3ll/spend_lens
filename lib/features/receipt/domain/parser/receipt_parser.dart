import '../../../../core/services/ocr/ocr_text_block.dart';
import 'parsed_receipt.dart';
import 'stages/receipt_candidate_builder.dart';
import 'stages/receipt_date_extractor.dart';
import 'stages/receipt_keyword_detector.dart';
import 'stages/receipt_line_grouper.dart';
import 'stages/receipt_price_extractor.dart';
import 'stages/receipt_store_resolver.dart';
import 'stages/receipt_structure_resolver.dart';
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

  /// Rounding-noise tolerance for the total-plausibility floor. Mirrors
  /// `ReceiptReconciler`'s own match tolerance.
  static const _totalPlausibilityTolerance = 0.02;

  final ReceiptTextNormalizer _textNormalizer;
  final ReceiptLineGrouper _lineGrouper;
  final ReceiptKeywordDetector _keywordDetector;
  final ReceiptPriceExtractor _priceExtractor;
  final ReceiptCandidateBuilder _candidateBuilder;
  final ReceiptStoreResolver _storeResolver;
  final ReceiptDateExtractor _dateExtractor;
  final ReceiptStructureResolver _structureResolver;

  const ReceiptParser({
    this._textNormalizer = const ReceiptTextNormalizer(),
    this._lineGrouper = const ReceiptLineGrouper(),
    this._keywordDetector = const ReceiptKeywordDetector(),
    this._priceExtractor = const ReceiptPriceExtractor(),
    this._candidateBuilder = const ReceiptCandidateBuilder(),
    this._storeResolver = const ReceiptStoreResolver(),
    this._dateExtractor = const ReceiptDateExtractor(),
    this._structureResolver = const ReceiptStructureResolver(),
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

    // A receipt's item region ENDS at the total line. Everything printed
    // below it (`CARD`, `REST`, `BRUT A`, `TVA 20%`, `Articole 5`,
    // `Z:0855 BON:0067`, the QR block) carries price-shaped tokens and so
    // would otherwise pass as a product: a real scan produced 18 "items"
    // including `Articole` at 5.00. Tracked as a flag rather than by
    // slicing the list, because the total keyword itself must still be
    // read for `total` below.
    var reachedTotal = false;

    // The NAME half of a wrapped item, awaiting the price line below it.
    String? pendingName;

    for (final line in normalizedLines) {
      // ── Structural filters, applied BEFORE keyword classification ──

      // Fiscal/administrative header lines. The store resolver's own noise
      // check covers `IDNO`/`STR.` but missed `INR N: J403005312`, which
      // became an item priced at 3,005,312.00.
      if (_structureResolver.isHeaderLine(line.text)) continue;

      if (reachedTotal) continue;

      // A wrapped item's price line (`1 _ x 25.50= 25.50 A`) is NOT a
      // product — it completes the NAME-ONLY line above it. Emitting it as
      // its own item is what double-counted every price and pushed the
      // subtotal to 380.21 on a 206.11 receipt.
      //
      // It is paired with `pendingName` rather than merged into
      // `items.last`, because a name-only line has no price and so never
      // became an item in the first place (`ReceiptCandidateBuilder.build`
      // returns null without a price). Merging into `items.last` would
      // therefore attach these numbers to the WRONG product — or, on a
      // receipt whose first item wraps, to nothing at all.
      if (_structureResolver.isPriceContinuation(line.text)) {
        final built = _candidateBuilder.build(
          line: line.text,
          lineConfidence: line.confidence,
          lineIndex: itemLineIndex,
        );
        if (built != null) {
          items.add(
            pendingName == null
                ? built
                : ParsedLineCandidate(
                    // The name comes from the line above, the numbers from
                    // this one.
                    rawName: pendingName,
                    quantity: built.quantity,
                    unit: built.unit,
                    unitPrice: built.unitPrice,
                    lineTotal: built.lineTotal,
                    confidence: built.confidence,
                    lineIndex: itemLineIndex,
                  ),
          );
          itemLineIndex++;
        }
        pendingName = null;
        continue;
      }

      if (_structureResolver.isFooterLine(line.text)) continue;
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
          // Everything below this line is payment/tax/footer detail.
          reachedTotal = true;
        case EReceiptLineKind.discount:
          final value = _priceExtractor.extractLastPrice(line.text);
          if (value != null) discount = value;
        case EReceiptLineKind.itemCandidate:
          // A line with letters but no DECIMAL price is the NAME half of a
          // wrapped item. Checked before the candidate builder runs,
          // because that builder treats a bare integer as a price and so
          // would price `...Paste W93...` at 93.00 from the product code
          // and `...45% 130g BREST` at 130.00 from the gram weight,
          // stranding their real price lines below.
          if (_structureResolver.isNameOnlyLine(line.text)) {
            pendingName = line.text;
            continue;
          }

          // Stages 4–6 — price + quantity extraction, candidate assembly.
          final candidate = _candidateBuilder.build(
            line: line.text,
            lineConfidence: line.confidence,
            lineIndex: itemLineIndex,
          );
          if (candidate != null) {
            // A self-contained item line: name AND price on one row.
            items.add(candidate);
            itemLineIndex++;
            pendingName = null;
          } else {
            // No price on this line. On a wrapping receipt that is the
            // NAME half of an item whose numbers print on the next row, so
            // it is held rather than discarded. On a non-wrapping receipt
            // it is simply stray text, and holding it is harmless: it is
            // only ever consumed by an immediately following continuation
            // line, and overwritten by the next name-only line otherwise.
            pendingName = line.text;
          }
      }
    }

    return ParsedReceipt(
      storeName: storeName,
      purchasedAt: purchasedAt,
      total: _plausibleTotal(total: total, items: items, discount: discount),
      discount: discount,
      items: items,
    );
  }

  /// Rejects an arithmetically impossible printed total.
  ///
  /// A receipt's total can never be LESS than the sum of its own item lines
  /// (a discount only ever reduces the total by the discount amount, which
  /// is accounted for here). A parsed total below that floor is therefore
  /// not a real total — it is a mis-read.
  ///
  /// The failure this guards against is a decimal split by OCR: `206. 11`
  /// (a space after the separator) cannot match the price pattern, which
  /// then fell back to the bare trailing integer and reported the total as
  /// **11.00** while the items correctly summed to 206.11. The normalizer
  /// now closes those gaps, so this is the second line of defence: any
  /// future mis-read of the same shape surfaces as "no printed total"
  /// (which the UI already has distinct copy for, and which leaves the
  /// item sum as the receipt's value) rather than as a confident, wrong
  /// number the user might save.
  ///
  /// Returning `null` rather than substituting the item sum is deliberate:
  /// the parser reports only what it actually read, and the reconciler
  /// already treats a null total as "nothing to compare against" instead
  /// of a mismatch.
  double? _plausibleTotal({
    required double? total,
    required List<ParsedLineCandidate> items,
    required double? discount,
  }) {
    if (total == null || items.isEmpty) return total;

    final itemsTotal = items.fold<double>(
      0.0,
      (sum, item) => sum + item.lineTotal,
    );
    final floor = itemsTotal - (discount ?? 0.0);

    // The same tolerance the reconciler uses for rounding noise on weighed
    // lines — a total a cent or two under the floor is not a mis-read.
    if (total < floor - _totalPlausibilityTolerance) return null;

    return total;
  }
}
