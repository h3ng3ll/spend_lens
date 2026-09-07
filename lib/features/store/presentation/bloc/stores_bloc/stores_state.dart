part of 'stores_bloc.dart';

enum EStoresStatus { initial, loading, loaded, failed }

@freezed
sealed class StoresState with _$StoresState {
  const factory StoresState({
    @Default(EStoresStatus.initial) EStoresStatus status,
    @Default(<Store>[]) List<Store> stores,
    @Default('') String errorMessage,

    /// The id of the store most recently created by `quickCreate`/`create`.
    /// A one-shot signal a `BlocListener` consumes to pop the picker/create
    /// screen with the new id — never read to derive displayed state.
    String? lastCreatedId,

    /// Whether the most recent write (quickCreate/create/delete) failed. A
    /// one-shot signal for an error-toast listener — never read to derive
    /// displayed state.
    @Default(false) bool lastWriteFailed,
  }) = _StoresState;
}
