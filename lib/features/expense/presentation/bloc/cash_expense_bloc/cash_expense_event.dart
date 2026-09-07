part of 'cash_expense_bloc.dart';

@freezed
sealed class CashExpenseEvent with _$CashExpenseEvent {
  /// Resolves [storeId] against `IStoreLocalRepository` and applies it —
  /// dispatched after `ChooseStorePageRoute` pops with a picked id.
  const factory CashExpenseEvent.pickStore(String storeId) = _PickStore;

  /// Toggle intent — NO payload (BLoC rule A3.11). Clears the currently
  /// attached store.
  const factory CashExpenseEvent.clearStore() = _ClearStore;

  /// Saves the cash expense. `categoryId`/`currencyCode` are forwarded from
  /// the already-live `CategoriesBloc`/`SettingsBloc` the UI reads — this
  /// screen-scoped bloc does not duplicate those subscriptions.
  const factory CashExpenseEvent.save({
    required double amount,
    required String categoryId,
    required String currencyCode,
    String? note,
  }) = _Save;
}
