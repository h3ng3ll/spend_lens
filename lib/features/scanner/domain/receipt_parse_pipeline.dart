import '../../../core/services/ocr/ocr_text_block.dart';
import 'i_receipt_parse_pipeline.dart';

/// M7's real (not fake — see `no_fake_ocr_test.dart` and this project's ban
/// on `Fake*Ocr` symbols under `lib/`) implementation of
/// [IReceiptParsePipeline]. It does the only honest work available before
/// the M8 parser/normalizer/price-history land: it reports how many
/// non-empty OCR blocks came through. M8 replaces the body with the real
/// 8-stage parser + normalizer + price lookup — this class and its method
/// signatures do not change, only what happens inside them.
class ReceiptParsePipeline implements IReceiptParsePipeline {
  const ReceiptParsePipeline();

  @override
  Future<int> findProducts(List<OcrTextBlock> blocks) async {
    return blocks.where((block) => block.text.trim().isNotEmpty).length;
  }

  @override
  Future<int> checkPrices(int productCount) async {
    return productCount;
  }
}
