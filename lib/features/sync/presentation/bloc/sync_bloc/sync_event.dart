part of 'sync_bloc.dart';

@freezed
sealed class SyncEvent with _$SyncEvent {
  /// Subscribes to the combined uid + connectivity + pending-count stream.
  /// Dispatched ONCE from `main()`.
  const factory SyncEvent.watch() = _Watch;

  /// Runs one sync cycle. Dispatched by a `BlocListener` when the state says
  /// a sync is due, and by the user tapping the Cloud-sync row.
  const factory SyncEvent.syncNow() = _SyncNow;
}
