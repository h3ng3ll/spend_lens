part of 'sync_bloc.dart';

@freezed
sealed class SyncEvent with _$SyncEvent {
  /// Subscribes to the combined uid + connectivity + pending-count stream.
  /// Dispatched ONCE from `main()`.
  const factory SyncEvent.watch() = _Watch;

  /// Runs one sync cycle. Dispatched by a `BlocListener` when the state says
  /// a sync is due, and by the user tapping the Cloud-sync row.
  /// Runs a cycle now.
  ///
  /// [fullResync] ignores the stored pull cursor and fetches every remote
  /// record. The USER-initiated path passes true: someone tapping
  /// Synchronize is usually trying to repair something an incremental pull
  /// cannot see, because the cursor has already moved past it. Automatic
  /// cycles leave it false and stay cheap.
  const factory SyncEvent.syncNow({@Default(false) bool fullResync}) =
      _SyncNow;
}
