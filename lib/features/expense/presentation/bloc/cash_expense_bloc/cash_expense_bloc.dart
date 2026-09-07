import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../store/domain/repositories/i_store_local_repository.dart';
import '../../../domain/models/expense/e_expense_source.dart';
import '../../../domain/models/expense/expense.dart';
import '../../../domain/repositories/i_expense_local_repository.dart';

part 'cash_expense_event.dart';

part 'cash_expense_state.dart';

part 'cash_expense_state_ext.dart';

part 'cash_expense_bloc.freezed.dart';

/// Screen-scoped bloc (`registerFactory` semantics: built in
/// `CashExpensePage.initState`, closed in `dispose` — BLoC rule A3.8).
///
/// Owns logging a cash expense end-to-end — this used to be a UI method
/// (`CashExpensePage._onSave`) that built an [Expense] by hand and wrote it
/// straight to `getIt<IExpenseLocalRepository>()`, with NO bloc at all (the
/// worst instance of the BLoC-layer violation this build fixes: a screen
/// with real persistence logic and zero state-management layer). It also
/// owns the store lookup (`_onPickStore` used to call
/// `getIt<IStoreLocalRepository>().getById(...)` directly from the UI).
///
/// `category`/`currencyCode` are NOT re-fetched here: `CategoriesBloc` and
/// `SettingsBloc` are already-live app-lifetime blocs the page reads via
/// `context.watch` and forwards into the save intent, so this screen-scoped
/// bloc never duplicates their reactive subscriptions.
class CashExpenseBloc extends Bloc<CashExpenseEvent, CashExpenseState> {
  final IExpenseLocalRepository _expenseLocalRepository;
  final IStoreLocalRepository _storeLocalRepository;
  final DateTime Function() _now;

  CashExpenseBloc({
    required this._expenseLocalRepository,
    required this._storeLocalRepository,
    this._now = DateTime.now,
  }) : super(const CashExpenseState()) {
    on<_PickStore>(_onPickStore);
    on<_ClearStore>(_onClearStore);
    on<_Save>(_onSave);
  }

  /// Resolves the picked store id against the repository — used to be a
  /// UI-side `getById` read in `CashExpensePage._onPickStore`.
  Future<void> _onPickStore(
    _PickStore event,
    Emitter<CashExpenseState> emit,
  ) async {
    final store = await _storeLocalRepository.getById(event.storeId);
    if (store == null) return;
    emit(state.copyWith(storeId: store.id, storeName: store.name));
  }

  void _onClearStore(_ClearStore event, Emitter<CashExpenseState> emit) {
    emit(state.copyWith(storeId: null, storeName: null));
  }

  Future<void> _onSave(_Save event, Emitter<CashExpenseState> emit) async {
    if (event.amount <= 0.0) return;

    try {
      final now = _now();
      final expense = Expense(
        id: now.microsecondsSinceEpoch.toString(),
        amount: event.amount,
        currencyCode: event.currencyCode,
        categoryId: event.categoryId,
        storeId: state.storeId,
        note: event.note == null || event.note!.isEmpty ? null : event.note,
        occurredAt: now,
        source: EExpenseSource.cash,
        updatedAt: now,
      );

      await _expenseLocalRepository.save(expense);
      emit(state.copyWith(status: ECashExpenseStatus.saved));
    } catch (_) {
      emit(state.copyWith(status: ECashExpenseStatus.failed));
    }
  }
}
