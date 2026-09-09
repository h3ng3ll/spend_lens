part of 'sync_bloc.dart';

/// What the Cloud-sync row reports.
///
/// [disabled] is NOT an error: signed out, or Firebase unconfigured, is the
/// app's normal anonymous mode. Mapping absence to a failure is a recorded
/// global bug (`absent-data-mapped-to-failed-status-first-launch-shows-
/// something-went-wrong`), so it gets its own value rather than borrowing
/// [failed].
enum ESyncUiStatus { disabled, idle, syncing, upToDate, offline, failed }

@freezed
sealed class SyncState with _$SyncState {
  const factory SyncState({
    @Default(ESyncUiStatus.disabled) ESyncUiStatus status,
    @Default('') String errorMessage,

    /// Rows awaiting upload, across all seven collections.
    @Default(0) int pendingCount,

    /// When the last successful cycle finished. Null until one has.
    DateTime? lastSyncedAt,

    /// Receipt-photo bytes this account occupies, measured from object
    /// metadata — never estimated.
    @Default(0) int usedBytes,

    /// The active tier's quota, so the bar has a denominator.
    @Default(AppLimits.freeCloudQuotaBytes) int quotaBytes,

    @Default(false) bool isPremium,

    /// Whether the device currently has a network path.
    @Default(true) bool isOnline,
  }) = _SyncState;
}
