part of 'sync_bloc.dart';

/// Boolean getters covering EVERY [ESyncUiStatus] value, plus the
/// `isLoading` / `isFailed` / `isReady` trio `state_ext_sibling_test`
/// requires of every bloc in this project.
extension SyncStateExt on SyncState {
  bool get isDisabled => status == ESyncUiStatus.disabled;

  bool get isIdle => status == ESyncUiStatus.idle;

  bool get isSyncing => status == ESyncUiStatus.syncing;

  bool get isUpToDate => status == ESyncUiStatus.upToDate;

  bool get isOffline => status == ESyncUiStatus.offline;

  bool get isFailed => status == ESyncUiStatus.failed;

  bool get isLoading => isSyncing;

  bool get isReady => isUpToDate;

  bool get isSuccess => isUpToDate;

  bool get hasPendingChanges => pendingCount > 0;

  /// 0.0–1.0 for the storage bar. Clamped, so a quota change or an
  /// over-quota account can never paint outside its track.
  double get usedFraction {
    if (quotaBytes <= 0) return 0.0;
    return (usedBytes / quotaBytes).clamp(0.0, 1.0);
  }

  /// Whether a cycle is worth starting: there is something to upload, the
  /// device is online, and sync is enabled.
  ///
  /// Read by a `BlocListener`, never by a handler — dispatching an event
  /// from inside a handler is forbidden by this project's BLoC rules.
  ///
  /// Gated on `hasPendingChanges` ALONE. It used to also fire on `isIdle`,
  /// meaning "nothing has run yet" — but `_stateFrom` reports `idle`
  /// whenever `lastSyncedAt` is null, so before the first successful cycle
  /// EVERY snapshot emission re-satisfied this and the listener
  /// re-dispatched `syncNow` continuously. `droppable()` hid the symptom by
  /// discarding the duplicates, which is why it never surfaced as a hang.
  ///
  /// Nothing is lost by dropping that disjunct: the sign-in transition, app
  /// resume, and the reconnect edge each dispatch a cycle explicitly, so a
  /// first sync on an empty device still runs without a pending row to
  /// trigger it.
  bool get needsSync =>
      !isDisabled && !isSyncing && isOnline && hasPendingChanges;
}
