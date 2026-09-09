/// Where "delete all records" actually deletes from.
///
/// Once records sync, "delete everything" stops having one obvious meaning:
/// clearing the phone would leave the cloud copy to reappear on the next
/// pull, while deleting the cloud copy would silently wipe the user's other
/// devices. Neither is safe to assume, so the user is asked.
enum EDeleteScope {
  /// Clear this device only; the cloud copy survives. `dataCleared` is set
  /// and gates the pull, so the cloud data cannot silently repopulate.
  local,

  /// Push tombstones so the records are removed from the account and from
  /// every other device, but keep them on this one.
  remote,

  /// Both: tombstones pushed AND this device cleared.
  both;

  bool get clearsLocal => this == EDeleteScope.local || this == EDeleteScope.both;

  bool get clearsRemote =>
      this == EDeleteScope.remote || this == EDeleteScope.both;
}
