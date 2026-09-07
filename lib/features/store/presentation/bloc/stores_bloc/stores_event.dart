part of 'stores_bloc.dart';

@freezed
sealed class StoresEvent with _$StoresEvent {
  /// Subscribes to the live store list. Idempotent — safe even though it is
  /// dispatched exactly once, from `main()` (BLoC rule A3.8).
  const factory StoresEvent.watch() = _Watch;

  /// The Choose-store artboard's quick-create row: creates a new store from
  /// typed free text only, defaulting its type to [EStoreType.other] — the
  /// bloc resolves the id, the UI never builds a [Store] itself.
  const factory StoresEvent.quickCreate(String name) = _QuickCreate;

  /// `NewStorePage`'s full create form (name, receipt alias, type).
  const factory StoresEvent.create({
    required String name,
    required String receiptAlias,
    required EStoreType type,
  }) = _Create;

  /// Deletes a store by id (`StoreDeleteSection`'s delete action). The
  /// confirm dialog has already run by the time this is dispatched.
  const factory StoresEvent.delete(String storeId) = _Delete;
}
