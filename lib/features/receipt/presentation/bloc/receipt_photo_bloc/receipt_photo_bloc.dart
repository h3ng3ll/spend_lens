import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/services/receipt_image_store/receipt_image_store.dart';
import '../../../domain/models/receipt/receipt.dart';
import '../../../domain/repositories/i_receipt_local_repository.dart';

part 'receipt_photo_event.dart';

part 'receipt_photo_state.dart';

part 'receipt_photo_state_ext.dart';

part 'receipt_photo_bloc.freezed.dart';

/// Screen-scoped bloc (built in `ReceiptPhotoPage.initState`, closed in
/// `dispose` — BLoC rule A3.8).
///
/// `load` is a REACTIVE read via `watchAll()`, NOT the one-shot form-bloc
/// exemption `EditReceiptBloc` uses: this screen DISPLAYS a photo that
/// another surface can replace or clear (Edit Receipt, a delete), and a
/// one-shot read would leave it showing a stale image with no error and no
/// crash — the exact failure hive_rules.md §6 exists to prevent. The
/// filename is watched; the `File` is re-resolved whenever it changes,
/// because `ReceiptImageStore` deliberately stores a FILENAME only (the
/// Documents path moves across iOS reinstalls).
class ReceiptPhotoBloc extends Bloc<ReceiptPhotoEvent, ReceiptPhotoState> {
  final IReceiptLocalRepository _receiptRepository;
  final ReceiptImageStore _imageStore;

  ReceiptPhotoBloc({
    required this._receiptRepository,
    required this._imageStore,
  }) : super(const ReceiptPhotoState()) {
    on<_Load>(_onLoad);
    on<_ReplaceFromFile>(_onReplaceFromFile);
  }

  Future<void> _onLoad(_Load event, Emitter<ReceiptPhotoState> emit) async {
    emit(
      state.copyWith(
        status: EReceiptPhotoStatus.loading,
        receiptId: event.receiptId,
      ),
    );

    await emit.forEach(
      _receiptRepository.watchAll(),
      onData: (receipts) => _stateFor(receipts, event.receiptId),
      onError: (_, _) =>
          state.copyWith(status: EReceiptPhotoStatus.failed),
    );
  }

  ReceiptPhotoState _stateFor(List<Receipt> receipts, String receiptId) {
    final receipt = receipts.where((r) => r.id == receiptId).firstOrNull;

    if (receipt == null) {
      return state.copyWith(
        status: EReceiptPhotoStatus.failed,
        imagePath: null,
      );
    }

    return state.copyWith(
      status: EReceiptPhotoStatus.ready,
      imagePath: receipt.imagePath,
    );
  }

  /// Persists [file]'s bytes as this receipt's photo and points the stored
  /// `Receipt.imagePath` at the result.
  ///
  /// No orphan cleanup is needed: [ReceiptImageStore.save] writes
  /// `receipt_<receiptId>.jpg`, a STABLE per-receipt filename, so a replace
  /// overwrites the previous file in place rather than stacking a new
  /// timestamped one beside it.
  Future<void> _onReplaceFromFile(
    _ReplaceFromFile event,
    Emitter<ReceiptPhotoState> emit,
  ) async {
    final receiptId = state.receiptId;
    if (receiptId == null) return;

    try {
      final receipt = await _receiptRepository.getById(receiptId);
      if (receipt == null) {
        emit(state.copyWith(status: EReceiptPhotoStatus.failed));
        return;
      }

      final Uint8List bytes = await event.file.readAsBytes();
      final filename = await _imageStore.save(
        receiptId: receiptId,
        bytes: bytes,
      );

      await _receiptRepository.save(receipt.copyWith(imagePath: filename));
    } catch (_) {
      emit(state.copyWith(status: EReceiptPhotoStatus.failed));
    }
  }
}
