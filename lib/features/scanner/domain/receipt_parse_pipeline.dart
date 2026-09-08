import 'dart:typed_data';

import '../../../core/services/ocr/ocr_text_block.dart';
import '../../../core/services/receipt_image_store/receipt_image_store.dart';
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
  final ReceiptImageStore _imageStore;

  ReceiptParsePipeline(
    this._parser,
    this._draftStore, [
    this._imageStore = const ReceiptImageStore(),
  ]);

  /// The capture's FILENAME once written to disk — never the bytes.
  ///
  /// This class is an app-lifetime singleton, so a `Uint8List` field here
  /// kept the last capture's full-resolution JPEG alive until the next scan
  /// replaced it. That was one of five simultaneous retainers behind the
  /// 2 GB `EXC_RESOURCE` kill (see [PendingReceiptDraft.imageFilename]).
  String? _pendingImageFilename;

  /// Writes the capture to disk IMMEDIATELY and keeps only its filename, so
  /// the multi-megabyte buffer becomes garbage as soon as the caller's own
  /// reference goes out of scope.
  ///
  /// The file is named from the capture instant rather than a receipt id,
  /// because no `Receipt` exists yet at this point — a scan the user never
  /// saves must still be able to own a file. `ReviewBloc._persist` renames
  /// it to the receipt's own `receipt_<id>.jpg` on save.
  Future<void> attachImageBytes(Uint8List imageBytes) async {
    _pendingImageFilename = await _imageStore.save(
      receiptId: 'capture_${DateTime.now().microsecondsSinceEpoch}',
      bytes: imageBytes,
    );
  }

  @override
  Future<int> findProducts(List<OcrTextBlock> blocks) async {
    final parsed = _parser.parse(blocks);
    _draftStore.set(
      PendingReceiptDraft(
        parsedReceipt: parsed,
        imageFilename: _pendingImageFilename,
      ),
    );
    _pendingImageFilename = null;
    return parsed.items.length;
  }

  @override
  Future<int> checkPrices(int productCount) async {
    return productCount;
  }
}
