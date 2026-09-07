import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/utils/combine_latest_streams.dart';
import '../../../../category/domain/repositories/i_category_local_repository.dart';
import '../../../../expense/domain/models/expense/expense.dart';
import '../../../../expense/domain/repositories/i_expense_local_repository.dart';
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
/// M5 scope boundary: every record in History at this milestone is an
/// [Expense] with `source: cash` — receipt scanning is M7/M8, so this bloc
/// resolves [recordId] against `IExpenseLocalRepository` only. A future
/// milestone adding the receipt-detail branch extends this bloc/snapshot
/// rather than this screen inventing a receipt lookup ahead of its data.
///
/// Reactive, not static (hive_rules.md §6/§10): combines expenses +
/// categories + stores into ONE [RecordDetailSnapshot] stream via
/// `combineLatest3` and subscribes with a SINGLE `emit.forEach` — never
/// parallel `emit.forEach` calls, never a Dart record type for the combined
/// value. Staying reactive (not a one-shot `getById`) means this screen
/// reflects a delete performed elsewhere (or by its own delete action)
/// while still mounted, mapping the vanished record to `notFound` rather
/// than crashing on a null dereference.
class RecordDetailBloc extends Bloc<RecordDetailEvent, RecordDetailState> {
  final IExpenseLocalRepository _expenseLocalRepository;
  final ICategoryLocalRepository _categoryLocalRepository;
  final IStoreLocalRepository _storeLocalRepository;
  final String recordId;

  RecordDetailBloc({
    required this.recordId,
    required this._expenseLocalRepository,
    required this._categoryLocalRepository,
    required this._storeLocalRepository,
  }) : super(const RecordDetailState()) {
    on<_Watch>(_onWatch);
  }

  Future<void> _onWatch(
    _Watch event,
    Emitter<RecordDetailState> emit,
  ) async {
    emit(state.copyWith(status: ERecordDetailStatus.loading));

    await emit.forEach<RecordDetailSnapshot>(
      combineLatest3(
        _expenseLocalRepository.watchAll(),
        _categoryLocalRepository.watchAll(),
        _storeLocalRepository.watchAll(),
        (expenses, categories, stores) => RecordDetailSnapshot(
          expense: _findExpense(expenses, recordId),
          categories: categories,
          stores: stores,
        ),
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
}
