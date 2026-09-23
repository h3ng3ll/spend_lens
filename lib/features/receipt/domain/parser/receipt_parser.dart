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

    // The NAME fragments of a wrapped item, awaiting the price line below
    // them — a LIST, because a long product name wraps across more than
    // one line and a single slot silently kept only the last fragment.
    //
    // `Conserva cu carne tocata de` / `porc/gain 1 buc x 54.99- 54.99 A`
    // reported its name as just `porc/gain`: the price line's own prefix
    // won because the fragment above had already been overwritten.
    final pendingNameParts = <String>[];

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

        // TWO receipt layouts print a continuation line, and they mean
        // opposite things:
        //
        //   wrapped name     NAME (no price)          <- held as pending
        //                    ...rest 1 x 54.99 54.99  <- completes it
        //
        //   detail line      NAME            17.90 A  <- ALREADY an item
        //                      1.000 x 17.90          <- its qty/unit
        //
        // The second is what Kaufland prints, and it was being read as the
        // first: with nothing pending, the line was dropped and the item
        // above kept `quantity: 1, unitPrice: null`. So `2.000 x 13.40`
        // was thrown away and a two-pack reported as one.
        //
        // Nothing pending + an item already emitted + this line carries a
        // quantity expression => it DETAILS that item. The line total is
        // not taken from here: the item's own right-aligned total is the
        // authoritative figure, and `qty x unit` can disagree with it
        // through rounding.
        if (pendingNameParts.isEmpty &&
            built != null &&
            built.rawName.trim().isEmpty &&
            items.isNotEmpty) {
          final last = items.last;
          items[items.length - 1] = ParsedLineCandidate(
            rawName: last.rawName,
            name: last.name,
            quantity: _reconciledQuantity(
              quantity: built.quantity,
              unitPrice: built.unitPrice,
              lineTotal: last.lineTotal,
            ),
            unit: built.unit,
            // The detail line's own `qty x unit` is the printed unit
            // price; fall back to whatever the item line could infer.
            unitPrice: built.unitPrice ?? last.unitPrice,
            // NOT `built.lineTotal`: the item's right-aligned total is the
            // authoritative figure, and `qty x unit` can disagree with it
            // by a rounding step (`0.868 x 25.50` = 22.134 against a
            // printed 22.13).
            lineTotal: last.lineTotal,
            confidence: last.confidence,
            lineIndex: last.lineIndex,
          );
          continue;
        }
        if (built != null) {
          // The name comes from EVERY held fragment above, joined in print
          // order; the numbers come from this line. `built.rawName` is
          // appended last because a continuation line can carry a trailing
          // name fragment of its own (`porc/gain 1 buc x 54.99`), which is
          // the final piece of the name, not a separate product.
          final nameParts = [...pendingNameParts, built.rawName]
              .map((part) => part.trim())
              .where((part) => part.isNotEmpty)
              .toList();

          // An empty `nameParts` means nothing was pending above AND this
          // line carries no prefix of its own — so the builder's
          // deliberately-empty name was never paired with anything and
          // names no product. Emitting `built` unpaired here is what
          // created blank-named products, which are worse than they look:
          // an empty name also normalizes to an empty matching key, so
          // every later blank line EXACT-MATCHES the same blank product
          // and piles unrelated prices onto one row.
          //
          // `itemLineIndex` is deliberately NOT incremented on this path —
          // it counts EMITTED items, so skipping leaves no gap in
          // `lineIndex` and shifts nothing (same as the footer skips).
          if (nameParts.isNotEmpty) {
            items.add(
              ParsedLineCandidate(
                rawName: nameParts.join(' '),
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
        }
        pendingNameParts.clear();
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
            // A promo banner (`O ! PRET MIC`) sits above an item and is
            // not part of its name — accumulating it would prepend the
            // banner to the product.
            if (!_structureResolver.isPromoBanner(line.text)) {
              pendingNameParts.add(line.text);
            }
            continue;
          }

          // Stages 4–6 — price + quantity extraction, candidate assembly.
          final candidate = _candidateBuilder.build(
            line: line.text,
            lineConfidence: line.confidence,
            lineIndex: itemLineIndex,
          );
          if (candidate != null) {
            // A priced line, with any held name fragments PREPENDED.
            //
            // A receipt prints an item as: one line of name text, then a
            // second line carrying the REST of the name (only when the
            // name was too long to fit) plus the price, right-aligned. So
            // this line's own leading text is the TAIL of the name above,
            // not a new product — `Conserva cu carne tocata de` +
            // `porc/gain 1 buc x 54.99` is ONE item whose full name is
            // `Conserva cu carne tocata de porc/gain`.
            //
            // Without this, the fragments were simply discarded here and
            // the item was named `porc/gain` — the price line's prefix
            // alone.
            final nameParts = [...pendingNameParts, candidate.rawName]
                .map((part) => part.trim())
                .where((part) => part.isNotEmpty)
                .toList();

            // A name with no letters at all names no product — a bare VAT
            // rate row (`1.008 %`), a stray `20 %`, a punctuation run. Its
            // amount is footer/tax detail that the printed total already
            // includes, so counting it would inflate `itemsTotal` and, via
            // `_plausibleTotal`, discard the real total (see
            // `hasNoProductName`).
            //
            // Tested on the JOINED name, so a wrapped item whose fragments
            // carry the letters survives on the strength of those
            // fragments. `itemLineIndex` is not incremented when the line
            // is dropped, so `lineIndex` stays contiguous.
            final joinedName = nameParts.join(' ');
            if (!_structureResolver.hasNoProductName(joinedName)) {
              items.add(
                ParsedLineCandidate(
                  rawName: joinedName,
                  quantity: candidate.quantity,
                  unit: candidate.unit,
                  unitPrice: candidate.unitPrice,
                  lineTotal: candidate.lineTotal,
                  confidence: candidate.confidence,
                  lineIndex: itemLineIndex,
                ),
              );
              itemLineIndex++;
            }
            // Cleared either way: these fragments belong to the line just
            // resolved, and carrying them forward would prepend them to the
            // NEXT product.
            pendingNameParts.clear();
          } else {
            // No price on this line. On a wrapping receipt that is the
            // NAME half of an item whose numbers print on the next row, so
            // it is held rather than discarded. On a non-wrapping receipt
            // it is simply stray text, and holding it is harmless: it is
            // only ever consumed by an immediately following continuation
            // line, and cleared by the next completed item otherwise.
            if (!_structureResolver.isPromoBanner(line.text)) {
              pendingNameParts.add(line.text);
            }
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

  /// Tolerance for "these three printed numbers agree", in currency units.
  /// A cent of rounding on a weighed line is normal; more is a mis-read.
  static const _quantityAgreementTolerance = 0.02;

  /// The largest quantity a single receipt line can plausibly carry.
  /// Bounds a division that a mis-read unit price could otherwise blow up.
  static const _maxPlausibleQuantity = 1000.0;

  /// How far from a whole number a derived quantity may sit and still be
  /// treated as that whole number.
  ///
  /// A till prints counts as exact integers, so `1.994` is not a quantity
  /// anyone bought — it is `2` seen through a mis-read digit. 1% leaves
  /// room for that while staying far below the gap to the next integer, and
  /// weighed lines (`0.868`) are nowhere near an integer to begin with.
  static const _wholeQuantitySnapTolerance = 0.01;

  /// Recovers a quantity OCR mangled, using the two numbers it read more
  /// reliably.
  ///
  /// A receipt prints three related figures — `qty x unitPrice = total` —
  /// and the total is by far the most legible: it is right-aligned, printed
  /// larger, and this parser already trusts it over the multiplication.
  /// So when `qty x unitPrice` does NOT reproduce the printed total, the
  /// quantity is the term to doubt.
  ///
  /// This is not hypothetical. On a faint print the digit `0` reads as `8`,
  /// so `1.000 x 139.88` came through as `1.888` and `1.000 x 59.98` as
  /// `1008`, and the Review screen showed quantities of `1.1`, `2.7` and
  /// `1008` against perfectly correct prices. Character substitution cannot
  /// fix that — `0` and `8` are both digits, so nothing marks which is
  /// wrong — but the arithmetic can.
  ///
  /// Deliberately conservative: it returns the OCR value untouched whenever
  /// that value already explains the total, so a legitimate `2 x 13.40 =
  /// 26.80` is never second-guessed. A near-integer result is snapped to
  /// the whole number (a two-pack reads as `2`, not `1.994`); anything else
  /// keeps three decimals, which is what a weighed line needs.
  double _reconciledQuantity({
    required double quantity,
    required double? unitPrice,
    required double lineTotal,
  }) {
    if (unitPrice == null || unitPrice <= 0) return quantity;

    // The printed numbers already agree — nothing to repair.
    if ((quantity * unitPrice - lineTotal).abs() <=
        _quantityAgreementTolerance) {
      return quantity;
    }

    final implied = lineTotal / unitPrice;
    if (implied <= 0 || implied > _maxPlausibleQuantity) return quantity;

    // Snapped on the QUANTITY's own scale, not the money's. A count line's
    // unit price is already known to be slightly mis-read here (that is why
    // the figures disagreed), so scaling the tolerance by it made a genuine
    // two-pack land on `1.994` — a quantity no till ever prints.
    final whole = implied.roundToDouble();
    if (whole >= 1 && (implied - whole).abs() <= _wholeQuantitySnapTolerance) {
      return whole;
    }

    return (implied * 1000).round() / 1000;
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
