import 'dart:typed_data';

import '../../../core/services/ocr/ocr_text_block.dart';
import '../../receipt/domain/parser/parsed_receipt.dart';
import '../../receipt/domain/parser/receipt_parser.dart';
import 'i_receipt_parse_pipeline.dart';
import 'pending_receipt_draft_store.dart';

/// M8's real implementation of [IReceiptParsePipeline] — runs the 8-stage
/// [ReceiptParser] (design_spendlens.md §6) and stashes the resulting
/// [ParsedReceipt] on [PendingReceiptDraftStore] for the Review screen to
/// pick up. `findProducts`/`checkPrices` keep their M7 signatures and
/// counting contract unchanged (`IReceiptParsePipeline` — "the method names
/// and this contract do not change") — the real work now happens inside
/// [findProducts]; [checkPrices] stays a pass-through because price-history
/// cross-referencing for the processing-step UI count is already reflected
/// in how many item candidates the parser found.
class ReceiptParsePipeline implements IReceiptParsePipeline {
  final ReceiptParser _parser;
  final PendingReceiptDraftStore _draftStore;

  ReceiptParsePipeline(this._parser, this._draftStore);

  /// Stashes [blocks] and the captured [imageBytes] so [findProducts] can
  /// build the full [PendingReceiptDraft] once parsing completes. Set by the
  /// caller (`CameraPreviewLayer`) immediately before invoking the
  /// processing pipeline for a capture.
  Uint8List? _pendingImageBytes;

  void attachImageBytes(Uint8List imageBytes) {
    _pendingImageBytes = imageBytes;
  }

  @override
  Future<int> findProducts(List<OcrTextBlock> blocks) async {
    final parsed = _parser.parse(blocks);
    final imageBytes = _pendingImageBytes;
    if (imageBytes != null) {
      _draftStore.set(
        PendingReceiptDraft(parsedReceipt: parsed, imageBytes: imageBytes),
      );
    }
    return parsed.items.length;
  }

  @override
  Future<int> checkPrices(int productCount) async {
    return productCount;
  }
}
