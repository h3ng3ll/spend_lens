import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/utils/combine_latest_streams.dart';
import '../../../../category/domain/repositories/i_category_local_repository.dart';
import '../../../../expense/domain/models/expense/expense.dart';
import '../../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../../receipt/domain/models/receipt/receipt.dart';
import '../../../../receipt/domain/models/receipt_item/receipt_item.dart';
import '../../../../receipt/domain/repositories/i_receipt_item_local_repository.dart';
import '../../../../receipt/domain/repositories/i_receipt_local_repository.dart';
import '../../../../store/domain/repositories/i_store_local_repository.dart';
import '../../../domain/models/record_detail_snapshot.dart';

part 'record_detail_event.dart';

part 'record_detail_state.dart';

part 'record_detail_state_ext.dart';

part 'record_detail_bloc.freezed.dart';

/// Screen-scoped bloc (`registerFactory` semantics: built in
/// `RecordDetailPage.initState`, closed in `dispose` — never `main()`, per
/// BLoC rule A3.8), taking [recordId] as a constructor param. Mirrors
/// `StoreDetailBloc`'s shape.
///
/// Resolves BOTH branches of the design's Record detail artboard. The
/// receipt branch works by id identity, which is not a coincidence:
/// `CreateExpenseFromReceiptUseCase` writes the mirrored [Expense] with
/// `id: receipt.id` precisely so that "History's `RecordDetailBloc` looks a
/// record up by id, and a receipt-sourced row must resolve to the receipt it
/// came from". So the single [recordId] this bloc is constructed with
/// resolves the expense, its receipt, and that receipt's items.
///
/// A cash expense simply finds no receipt, leaving [RecordDetailSnapshot]'s
/// `receipt`/`items` null/empty — the branch is data-driven, never a flag
/// the caller passes in.
///
/// Reactive, not static (hive_rules.md §6/§10): combines expenses +
/// categories + stores + receipts + receipt items into ONE
/// [RecordDetailSnapshot] stream via `combineLatest5` and subscribes with a
/// SINGLE `emit.forEach` — never
/// parallel `emit.forEach` calls, never a Dart record type for the combined
/// value. Staying reactive (not a one-shot `getById`) means this screen
/// reflects a delete performed elsewhere (or by its own delete action)
/// while still mounted, mapping the vanished record to `notFound` rather
/// than crashing on a null dereference.
class RecordDetailBloc extends Bloc<RecordDetailEvent, RecordDetailState> {
  final IExpenseLocalRepository _expenseLocalRepository;
  final ICategoryLocalRepository _categoryLocalRepository;
  final IStoreLocalRepository _storeLocalRepository;
  final IReceiptLocalRepository _receiptLocalRepository;
  final IReceiptItemLocalRepository _receiptItemLocalRepository;
  final String recordId;

  RecordDetailBloc({
    required this.recordId,
    required this._expenseLocalRepository,
    required this._categoryLocalRepository,
    required this._storeLocalRepository,
    required this._receiptLocalRepository,
    required this._receiptItemLocalRepository,
  }) : super(const RecordDetailState()) {
    on<_Watch>(_onWatch);
    on<_DeleteRecord>(_onDeleteRecord);
  }

  Future<void> _onWatch(_Watch event, Emitter<RecordDetailState> emit) async {
    emit(state.copyWith(status: ERecordDetailStatus.loading));

    await emit.forEach<RecordDetailSnapshot>(
      combineLatest5(
        _expenseLocalRepository.watchAll(),
        _categoryLocalRepository.watchAll(),
        _storeLocalRepository.watchAll(),
        _receiptLocalRepository.watchAll(),
        _receiptItemLocalRepository.watchAll(),
        (expenses, categories, stores, receipts, receiptItems) {
          final receipt = _findReceipt(receipts, recordId);

          return RecordDetailSnapshot(
            expense: _findExpense(expenses, recordId),
            categories: categories,
            stores: stores,
            receipt: receipt,
            items: _itemsOf(receipt, receiptItems),
          );
        },
      ),
      onData: (snapshot) => snapshot.expense == null
          ? state.copyWith(status: ERecordDetailStatus.notFound)
          : state.copyWith(
              status: ERecordDetailStatus.ready,
              snapshot: snapshot,
            ),
      onError: (error, stackTrace) => state.copyWith(
        status: ERecordDetailStatus.failed,
        errorMessage: error.toString(),
      ),
    );
  }

  Expense? _findExpense(List<Expense> expenses, String id) {
    for (final expense in expenses) {
      if (expense.id == id) return expense;
    }
    return null;
  }

  /// The receipt sharing [id] with the expense, or null for a cash expense.
  Receipt? _findReceipt(List<Receipt> receipts, String id) {
    for (final receipt in receipts) {
      if (receipt.id == id) return receipt;
    }
    return null;
  }

  /// [receipt]'s items, in printed order.
  ///
  /// Filtered here rather than through
  /// `IReceiptItemLocalRepository.watchByReceiptId`: that method needs
  /// `Receipt.itemIds`, which is not known until the receipt stream emits,
  /// so reaching for it would mean a second subscription nested inside the
  /// first — two `emit.forEach`-shaped reads on one emitter, which
  /// hive_rules.md §7/§10 forbids. One combined stream, filtered in the
  /// combiner, keeps the single-subscription contract.
  ///
  /// Sorted explicitly by `lineIndex`: Hive's `box.values` is INSERTION
  /// order, so the print order the parser recorded is not guaranteed by the
  /// box, and an unsorted list would silently reorder a receipt's lines.
  List<ReceiptItem> _itemsOf(Receipt? receipt, List<ReceiptItem> allItems) {
    if (receipt == null) return const <ReceiptItem>[];

    final itemIds = receipt.itemIds.toSet();
    final items = allItems
        .where((item) => itemIds.contains(item.id))
        .toList();
    items.sort((a, b) => a.lineIndex.compareTo(b.lineIndex));
    return items;
  }

  /// Deletes [recordId] (`RecordDetailDeleteButton`'s delete action — used
  /// to call `getIt<IExpenseLocalRepository>().delete(recordId)` directly
  /// from the UI, fire-and-forget, a BLoC-layer violation). SUCCESS is not
  /// signalled here: once the write lands, the reactive `_onWatch` stream
  /// above already sees the record vanish and flips to `notFound`, which
  /// `RecordDetailPage`'s `BlocListener` turns into the exit navigation.
  /// This handler only surfaces a write FAILURE, via
  /// [RecordDetailState.lastDeleteFailed].
  Future<void> _onDeleteRecord(
    _DeleteRecord event,
    Emitter<RecordDetailState> emit,
  ) async {
    try {
      await _expenseLocalRepository.delete(event.recordId);
      emit(state.copyWith(lastDeleteFailed: false));
    } catch (_) {
      emit(state.copyWith(lastDeleteFailed: true));
    }
  }
}
