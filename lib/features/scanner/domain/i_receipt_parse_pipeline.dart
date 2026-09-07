import '../../../core/services/ocr/ocr_text_block.dart';

/// The scanner's third and fourth processing steps — "Finding products" and
/// "Checking prices" (design_spendlens.md §5/§6/§8).
///
/// The first two steps (`detectReceiptRect`/`cropPerspective` and
/// `recognizeText`) already have real interfaces in `core/services/ocr/`.
/// These two do NOT yet — the parser (8 stages under
/// `features/receipt/domain/parser/`), the normalizer
/// (`features/product/domain/normalizer/`) and price-observation lookup all
/// land in M8. This interface exists so `ScannerBloc` can await a REAL call
/// for every processing step now, rather than a `Future.delayed` standing in
/// for work that doesn't exist yet (design_spendlens.md §8 — every
/// transition is a real event, never a simulated timer). M8 replaces
/// [ReceiptParsePipeline]'s implementation body with the real parser +
/// normalizer + price-lookup calls; the method names and this contract do
/// not change.
abstract interface class IReceiptParsePipeline {
  /// Groups/parses OCR blocks into product line candidates
  /// (design_spendlens.md §6 parser stages: text normalizer, line grouper,
  /// keyword detector, price extractor, quantity extractor, product-
  /// candidate builder, store resolver, date extractor — plus the
  /// normalizer's cleanup/abbreviation/fuzzy-match pipeline). Returns the
  /// count of line candidates found, which is all the processing-step UI
  /// needs at this milestone.
  Future<int> findProducts(List<OcrTextBlock> blocks);

  /// Looks up price-history context for the parsed line candidates
  /// (features/analytics's price-history calculator, M8). Returns the count
  /// of prices successfully cross-referenced.
  Future<int> checkPrices(int productCount);
}
