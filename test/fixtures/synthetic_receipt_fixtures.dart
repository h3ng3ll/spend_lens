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
