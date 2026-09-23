import 'package:flutter/material.dart' show Rect;

import 'package:spend_lens/core/services/ocr/ocr_text_block.dart';

/// SYNTHETIC `OcrTextBlock` fixtures modeling REAL OCR noise
/// (design_spendlens.md §10/§11 — "M8 is the only milestone that can slip
/// on quality rather than effort").
///
/// **These are NOT recorded from real receipt photos.** Real photos are
/// gathered by the user separately (see design_spendlens.md §12 — "20-50
/// real receipt photos… blocks M8 parser tuning"). This file exists so the
/// parser is testable and re-tunable RIGHT NOW, and is structured so real
/// photos can be dropped in later WITHOUT REWORK:
///
/// - Each helper below returns `List<OcrTextBlock>` — the EXACT shape
///   `OcrService.recognizeText` returns from a real device. A future
///   fixture recorded from a real photo (e.g. by logging the actual
///   `OcrTextBlock` list a real scan produced) drops into this file as one
///   more `List<OcrTextBlock> receiptXyz()` function with ZERO changes to
///   any parser stage, the orchestrator, or any test that consumes these
///   helpers by name.
/// - Bounding boxes are deliberately laid out on a realistic 1000×2000 px
///   canvas (a plausible photographed-receipt raster size) with correct
///   relative Y positions and X columns, so the LINE GROUPER'S geometry
///   logic is exercised the same way it will be against a real photo's
///   (noisier, less regular) boxes.
/// - Character confusions (O/0, l/1, S/5, rn/m), missing/blurred glyphs,
///   merged lines and stray punctuation are injected EXPLICITLY per helper
///   and named for what they model, so a real photo that reproduces a
///   DIFFERENT noise pattern is added as a NEW helper alongside these
///   rather than by editing an existing one.
class SyntheticReceiptFixtures {
  const SyntheticReceiptFixtures._();

  static OcrTextBlock _block(
    String text, {
    required double left,
    required double top,
    double width = 400.0,
    double height = 40.0,
    double confidence = 0.9,
  }) {
    return OcrTextBlock(
      text: text,
      boundingBox: Rect.fromLTWH(left, top, width, height),
      confidence: confidence,
    );
  }

  /// A receipt whose VAT RATE row prints as its own grouped line, with the
  /// `TVA` label lost — and ABOVE the total keyword.
  ///
  /// This is the shape that became a Product named `1.008 %` priced at
  /// 19.95. Every existing guard misses it: `footerKeywords` needs the
  /// `TVA` token (the grouper put the label on its own row, and here OCR
  /// dropped it entirely), `reachedTotal` has not been set because the
  /// total keyword prints BELOW, and `isNameOnlyLine` requires letters so
  /// it cannot park a letterless line either. The candidate builder then
  /// strips the trailing `19.95`, but the `%` blocks its trailing-digit
  /// strip, leaving a non-empty `1.008 %` that satisfied its only guard.
  ///
  /// The damage was arithmetic, not cosmetic. VAT is already INSIDE the
  /// printed total, so the phantom 19.95 pushes `itemsTotal` (154.75) above
  /// the printed 151.10, `ReceiptParser._plausibleTotal` then judges the
  /// CORRECT printed total impossible and returns null, and the expense is
  /// recorded from the inflated item sum — with the reconciler's mismatch
  /// warning suppressed, because a null printed total reconciles as
  /// "nothing to compare against".
  ///
  /// The rate is placed ABOVE the total line deliberately: below it the
  /// `reachedTotal` flag would already skip it and the fixture would pass
  /// without the guard under test.
  static List<OcrTextBlock> vatRateLineAboveTotalReceipt() => [
    _block('KAUFLAND MOLDOVA', left: 60.0, top: 40.0),
    _block('07.09.2026 14:32', left: 60.0, top: 140.0),
    _block('LAPTE ZUZU 1L 22.90', left: 60.0, top: 260.0),
    _block('FRANZELA GRIU 7.90', left: 60.0, top: 310.0),
    _block('ROSII 1.2 kg x 120.30', left: 60.0, top: 360.0),
    // The bare VAT rate, on its own row, its label gone.
    _block('1.008 % 19.95', left: 500.0, top: 420.0),
    _block('TOTAL DE PLATA 151.10', left: 60.0, top: 500.0),
  ];

  /// A VERBATIM device OCR dump of a faint Kaufland thermal print.
  ///
  /// Captured from `OCR_DIAG` on a real scan, blocks in the order the
  /// recognizer emitted them — deliberately unsorted and un-cleaned,
  /// because both properties were load-bearing in the failure:
  ///
  ///  * the separator is MISSING, not merely spaced: `17 98 A` (the
  ///    existing `206. 11` repair does not cover this, and the price read
  ///    as **98.00**);
  ///  * `0` is read as `8`, so `1.000 x` arrives as `1.888` or `1008`;
  ///  * name and amount are ~8px apart vertically and must group as one
  ///    row, while the `qty x unit` line sits ~20px below as its own row.
  static List<OcrTextBlock> faintThermalPrintReceipt() => [
    _block('SACOSA ECOTAX8, 15Te1', left: 211.0, top: 19.0, height: 26.0),
    _block('1 098 x 17 98', left: 366.0, top: 48.0, height: 26.0),
    _block('TESS CEAI 180G', left: 214.0, top: 77.0, height: 26.0),
    _block('FILEU PUT 8,9KG', left: 212.0, top: 141.0, height: 26.0),
    _block('BABUS PELHENI 988 G', left: 210.0, top: 197.0, height: 26.0),
    _block('TALIEI VITA 858', left: 212.0, top: 319.0, height: 26.0),
    _block('1. B08 x 71.98', left: 366.0, top: 169.0, height: 26.0),
    _block('DET CAPSULE 288UC', left: 209.0, top: 257.0, height: 26.0),
    _block('POLONIG', left: 209.0, top: 445.0, height: 26.0),
    _block('SET 2 LAVETE NF', left: 210.0, top: 380.0, height: 26.0),
    _block('1. 888 x 139 88', left: 377.0, top: 106.0, height: 26.0),
    _block('BANANE', left: 208.0, top: 569.0, height: 26.0),
    _block('1W16688804811', left: 419.0, top: -2.0, height: 26.0),
    _block('1. 888 x 88 58', left: 379.0, top: 222.0, height: 26.0),
    _block('2. 088 x 13. 48', left: 365.0, top: 344.0, height: 26.0),
    _block('1. 088 x 99 08', left: 376.0, top: 280.0, height: 26.0),
    _block('1,008 x 59.98', left: 367.0, top: 408.0, height: 26.0),
    _block('GARTOF1 ALBI SPALATI', left: 208.0, top: 502.0, height: 26.0),
    _block('1. 088 x 6.58', left: 368.0, top: 532.0, height: 26.0),
    _block('8.868 x 25.58', left: 367.0, top: 594.0, height: 26.0),
    _block('OREZ CLASIC 908G', left: 208.0, top: 628.0, height: 26.0),
    _block('1. 808', left: 381.0, top: 656.0, height: 26.0),
    _block('PAN MACARON SC IKG', left: 207.0, top: 692.0, height: 26.0),
    _block('AVITON OUA XL 188', left: 205.0, top: 758.0, height: 26.0),
    _block('K. EHMENT. 4886', left: 201.0, top: 891.0, height: 26.0),
    _block('1. 889 x 14.58', left: 382.0, top: 722.0, height: 26.0),
    _block('1.088 x 48. 98', left: 369.0, top: 788.0, height: 26.0),
    _block('HILINA FRANZELA SUD', left: 203.0, top: 824.0, height: 26.0),
    _block('1.908 x 6.48', left: 369.0, top: 855.0, height: 26.0),
    _block('x 19 35', left: 435.0, top: 654.0, height: 26.0),
    _block('1. 086 x 99. 98', left: 383.0, top: 921.0, height: 26.0),
    _block('DOLCE IAURT CAP 1156', left: 201.0, top: 955.0, height: 26.0),
    _block('2. 688 x 12. 95', left: 366.0, top: 991.0, height: 26.0),
    _block('CASUIA HEA CHEF939G', left: 201.0, top: 1029.0, height: 26.0),
    _block('1.888 x 23 45', left: 369.0, top: 1057.0, height: 26.0),
    _block('APIFERA MIERE 15806', left: 200.0, top: 1098.0, height: 26.0),
    _block('17 98 A', left: 635.0, top: 27.0, height: 26.0),
    _block('139 88 A', left: 625.0, top: 82.0, height: 26.0),
    _block('71. 98 A', left: 641.0, top: 138.0, height: 26.0),
    _block('88 58 A', left: 638.0, top: 196.0, height: 26.0),
    _block('99 88 A', left: 640.0, top: 257.0, height: 26.0),
    _block('26.88 A', left: 642.0, top: 316.0, height: 26.0),
    _block('59. 98 A', left: 643.0, top: 376.0, height: 26.0),
    _block('119 88 A', left: 643.0, top: 432.0, height: 26.0),
    _block('6 55 B', left: 658.0, top: 500.0, height: 26.0),
    _block('22. 13 A', left: 649.0, top: 560.0, height: 26.0),
    _block('19.95 A', left: 653.0, top: 623.0, height: 26.0),
    _block('14.58 A', left: 655.0, top: 690.0, height: 26.0),
    _block('48 99 A', left: 655.0, top: 754.0, height: 26.0),
    _block('6 48 B', left: 674.0, top: 820.0, height: 26.0),
    _block('99. 98 A', left: 658.0, top: 889.0, height: 26.0),
    _block('25. 98 B', left: 659.0, top: 955.0, height: 26.0),
    _block('23. 45 B', left: 661.0, top: 1021.0, height: 26.0),
    _block('179.38', left: 654.0, top: 1097.0, height: 26.0),
  ];

  /// The Kaufland two-row layout: `NAME ... TOTAL` then an INDENTED
  /// `qty x unitPrice` detail line beneath it.
  ///
  /// This is the shape that produced items named after their own prices
  /// (`TESS CEAI 188G 139.88 A`), quantities of `1` on two-packs, and a
  /// receipt whose printed `SUMA 1054.38` was read as 38.00 and then
  /// discarded as implausible.
  ///
  /// Distinct from a WRAPPED name, where the continuation completes the
  /// name of a line that had no price. Here the item is already complete
  /// and priced; the line below only details how that price was reached.
  static List<OcrTextBlock> quantityDetailLineReceipt() => [
    _block('KAUFLAND S.R.L.', left: 200.0, top: 40.0),
    _block('IDNO 1016600004811', left: 200.0, top: 90.0),

    // Single-quantity item: name + right-aligned total, then its detail.
    _block('TESS CEAI 180G', left: 60.0, top: 150.0),
    _block('139.80 A', left: 600.0, top: 150.0, width: 120.0),
    _block('1.000 x 139.80', left: 250.0, top: 190.0),

    // TWO-pack — the quantity is only on the detail line.
    _block('TAITEI VITA 85G', left: 60.0, top: 230.0),
    _block('26.80 A', left: 600.0, top: 230.0, width: 120.0),
    _block('2.000 x 13.40', left: 250.0, top: 270.0),

    // Weighed, and its `qty x unit` does NOT equal the printed total
    // (0.868 x 25.50 = 22.134 against a printed 22.13).
    _block('BANANE', left: 60.0, top: 310.0),
    _block('22.13 A', left: 600.0, top: 310.0, width: 120.0),
    _block('0.868 x 25.50', left: 250.0, top: 350.0),

    // A four-digit total with NO thousands separator.
    _block('SUMA', left: 60.0, top: 500.0),
    _block('1054.38', left: 600.0, top: 500.0, width: 120.0),
  ];

  /// A receipt where an AMOUNT plus its VAT CLASS CODE lands on its own
  /// grouped row — `99.88 A`.
  ///
  /// The single trailing letter is the tax class the receipt prints, not a
  /// product word, but it was enough to clear a "has any letter" test: the
  /// row became a Product named `99.88 A` priced at 99.88, i.e. a product
  /// named after its own price. Hence the two-letter minimum.
  static List<OcrTextBlock> amountWithVatClassCodeReceipt() => [
    _block('KAUFLAND MOLDOVA', left: 60.0, top: 40.0),
    _block('07.09.2026 14:32', left: 60.0, top: 140.0),
    _block('LAPTE ZUZU 1L 22.90', left: 60.0, top: 260.0),
    // An amount and a tax class letter, stranded on their own row.
    _block('99.88 A', left: 500.0, top: 320.0),
    _block('TOTAL DE PLATA 22.90', left: 60.0, top: 500.0),
  ];

  /// A price-CONTINUATION line with no name line above it — the first
  /// priced row on the receipt is the continuation half of a wrapped item
  /// whose name never survived OCR.
  ///
  /// `ReceiptCandidateBuilder` deliberately allows an empty `rawName` on the
  /// expression path, trusting the parser to pair it with the held name
  /// fragments. With nothing pending there is nothing to pair, and the
  /// parser emitted the empty-named candidate anyway — producing a
  /// BLANK-named product. That is worse than it looks twice over: an empty
  /// name also normalizes to an empty matching key (so later blank lines
  /// collapse onto the same row), and an empty `rawName` is the app's
  /// sentinel for "manually added by the user", making a parser-emitted row
  /// indistinguishable from a typed one.
  static List<OcrTextBlock> unpairedContinuationLineReceipt() => [
    _block('KAUFLAND MOLDOVA', left: 60.0, top: 40.0),
    _block('07.09.2026 14:32', left: 60.0, top: 140.0),
    // A continuation line with NO name row above it.
    _block('1 _ x 25.50= 25.50 A', left: 80.0, top: 260.0),
    _block('LAPTE ZUZU 1L 22.90', left: 60.0, top: 320.0),
    _block('TOTAL DE PLATA 48.40', left: 60.0, top: 500.0),
  ];

  /// A product whose NAME legitimately contains a percentage, wrapped across
  /// two physical lines.
  ///
  /// The false-positive guard for [vatRateLineAboveTotalReceipt]'s fix: a
  /// 45%-fat cheese is a real product, and an earlier over-broad guard on a
  /// `%`-bearing line dropped this line — which then stranded its price
  /// line as a bogus item of its own. It must survive as ONE item at 47.50.
  static List<OcrTextBlock> percentageInProductNameReceipt() => [
    _block('KAUFLAND MOLDOVA', left: 60.0, top: 40.0),
    _block('07.09.2026 14:32', left: 60.0, top: 140.0),
    _block('Branza Maasdam 45% 130g BREST', left: 60.0, top: 260.0),
    _block('1 _ x 47.50= 47.50 A', left: 80.0, top: 310.0),
    _block('TOTAL DE PLATA 47.50', left: 60.0, top: 500.0),
  ];

  /// A clean, well-lit single-column receipt — the baseline case every
  /// other fixture is a noisy variant of.
  static List<OcrTextBlock> cleanSingleColumnReceipt() => [
    _block('KAUFLAND MOLDOVA', left: 60.0, top: 40.0),
    _block('STR. GHIOCEILOR 1', left: 60.0, top: 90.0),
    _block('07.09.2026 14:32', left: 60.0, top: 140.0),
    _block('LAPTE ZUZU 1L 22.90', left: 60.0, top: 260.0),
    _block('FRANZELA GRIU 7.90', left: 60.0, top: 310.0),
    _block('ROSII 1.2 kg x 104.00', left: 60.0, top: 360.0),
    _block('TOTAL DE PLATA 151.10', left: 60.0, top: 500.0),
  ];

  /// Character confusions: O<->0, l<->1, S<->5, rn<->m — modeling the
  /// specific glyph-confusion classes design_spendlens.md §10 names.
  static List<OcrTextBlock> characterConfusionReceipt() => [
    _block('KAUFLAND M0LD0VA', left: 60.0, top: 40.0),
    _block('O7.O9.2O26', left: 60.0, top: 140.0),
    _block('LAPTE ZUZU 1L 22,9O', left: 60.0, top: 260.0),
    // "rn" merges visually into "m" in low-resolution OCR — modeled as an
    // actual product name where the printer's "RN" is misread.
    _block('SM0RNTANA 15,5O', left: 60.0, top: 310.0),
    _block('T0TAL 5UMA 1O4,OO', left: 60.0, top: 500.0),
  ];

  /// Two-column layout: product name block and price block share the same
  /// visual row but arrive as two SEPARATE OcrTextBlocks with distinct X
  /// positions — this is what the line grouper's bounding-box geometry
  /// must merge into one logical line.
  static List<OcrTextBlock> twoColumnReceipt() => [
    _block('LIDL', left: 60.0, top: 40.0, width: 200.0),
    _block('06/09/2026', left: 60.0, top: 140.0, width: 250.0),
    // Row 1 — name column (left) + price column (right), same Y.
    _block('MILK 1L', left: 60.0, top: 300.0, width: 300.0),
    _block('22.90', left: 700.0, top: 300.0, width: 150.0),
    // Row 2.
    _block('BREAD', left: 60.0, top: 360.0, width: 300.0),
    _block('7.90', left: 700.0, top: 360.0, width: 150.0),
    // Row 3.
    _block('TOMATOES', left: 60.0, top: 420.0, width: 300.0),
    _block('16.30', left: 700.0, top: 420.0, width: 150.0),
    _block('TOTAL 47.10', left: 60.0, top: 560.0),
  ];

  /// Weighed lines (`1.2 kg @ 104`, `500 g @ 40`) — quantity extraction
  /// must recognize both the kilogram and gram forms and normalize the
  /// comparable unit price consistently.
  static List<OcrTextBlock> weighedLinesReceipt() => [
    _block('METRO CASH & CARRY', left: 60.0, top: 40.0),
    _block('07.09.2026', left: 60.0, top: 140.0),
    _block('ROSII 1.2 kg @ 104', left: 60.0, top: 260.0),
    _block('CASTRAVETI 500 g @ 40', left: 60.0, top: 310.0),
    _block('SUMA DE PLATA 144.85', left: 60.0, top: 500.0),
  ];

  /// Missing/blurred glyphs — a partially-unreadable line (as OCR would
  /// emit for a crease or ink smear) and stray punctuation noise.
  static List<OcrTextBlock> blurredAndPunctuationNoiseReceipt() => [
    _block('N R.1 SRL', left: 60.0, top: 40.0), // stray internal space
    _block('07.O9.2O26', left: 60.0, top: 140.0),
    // "APA" printed as "AP_" with a blurred final glyph replaced by '_'.
    _block('AP_ PLATA 12.00', left: 60.0, top: 260.0),
    _block('|BISCUITI| 18,50', left: 60.0, top: 310.0), // stray pipe noise
    _block('TOTAL GENERAL 30.50', left: 60.0, top: 500.0),
  ];

  /// Merged lines — two logical print lines collapse into ONE OCR block
  /// (a common failure when two rows sit too close together for the
  /// recognizer's line-segmentation).
  static List<OcrTextBlock> mergedLinesReceipt() => [
    _block('FIDESCO SUPERMARKET', left: 60.0, top: 40.0),
    _block('07.09.2026', left: 60.0, top: 140.0),
    // Two products merged onto one physical OCR block/line.
    _block('APA MINERALA 9.50 SUC PORTOCALE 24.00', left: 60.0, top: 260.0),
    _block('TOTAL 33.50', left: 60.0, top: 500.0),
  ];

  /// A receipt whose printed BARCODE (a long digit string, larger than the
  /// actual total) sits among the item lines — the parser must resolve the
  /// total from the `TOTAL`-keyword line, never from "the largest number
  /// on the page" (spec §35).
  static List<OcrTextBlock> barcodeLargerThanTotalReceipt() => [
    _block('NR.1 SRL', left: 60.0, top: 40.0),
    _block('07.09.2026', left: 60.0, top: 140.0),
    _block('PAINE 7.90', left: 60.0, top: 260.0),
    _block('LAPTE 22.90', left: 60.0, top: 310.0),
    // The barcode number (5941234567890) is numerically far larger than
    // the real total (30.80) — a naive "largest number" heuristic would
    // pick this instead.
    _block('5941234567890', left: 60.0, top: 400.0),
    _block('TOTAL DE PLATA 30.80', left: 60.0, top: 500.0),
  ];

  /// All 5 supported price formats on one synthetic receipt.
  static List<OcrTextBlock> allPriceFormatsReceipt() => [
    _block('DOT DECIMAL 104.00', left: 60.0, top: 40.0),
    _block('COMMA DECIMAL 104,00', left: 60.0, top: 90.0),
    _block('BARE INTEGER 104', left: 60.0, top: 140.0),
    _block('DOT THOUSANDS 1.234,56', left: 60.0, top: 190.0),
    _block('COMMA THOUSANDS 1,234.56', left: 60.0, top: 240.0),
  ];

  /// The 4 supported date formats, one per line, each unambiguous.
  static List<OcrTextBlock> allDateFormatsReceipt() => [
    _block('07.09.2026', left: 60.0, top: 40.0), // DD.MM.YYYY
    _block('07/09/2026', left: 60.0, top: 90.0), // DD/MM/YYYY
    _block('07-09-2026', left: 60.0, top: 140.0), // DD-MM-YYYY
    _block('2026-09-07', left: 60.0, top: 190.0), // ISO YYYY-MM-DD
  ];

  /// A date whose day component is `<= 12` (day and month values could
  /// both, in the abstract, be read either way) — this parser's FIXED
  /// day-first convention resolves it deterministically rather than
  /// guessing (see `ReceiptDateExtractor`'s class doc for why this is not
  /// itself the spec §36 ambiguity case — that is exercised directly in
  /// `receipt_date_extractor_test.dart`'s `resolveAmbiguous` group, which
  /// models the genuine case: two independently-plausible readings for the
  /// same digits that disagree).
  static List<OcrTextBlock> dayFirstLowValueDateReceipt() => [
    _block('05.03.2026', left: 60.0, top: 40.0),
  ];
}
