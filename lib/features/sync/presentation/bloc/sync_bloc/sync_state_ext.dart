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

  /// Whether a cycle is worth starting: there is something to upload (or
  /// nothing has run yet), the device is online, and sync is enabled.
  ///
  /// Read by a `BlocListener`, never by a handler — dispatching an event
  /// from inside a handler is forbidden by this project's BLoC rules.
  bool get needsSync =>
      !isDisabled && !isSyncing && isOnline && (hasPendingChanges || isIdle);
}
