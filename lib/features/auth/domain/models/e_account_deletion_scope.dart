/// What a "delete account" action destroys.
///
/// The user chooses between these explicitly, because "delete my account" is
/// genuinely ambiguous: some people mean "close the account", others mean
/// "erase every trace of me". Guessing either way destroys data the user
/// expected to keep, or keeps data they expected gone.
enum EAccountDeletionScope {
  /// The account, all cloud data, AND every record on this device.
  everywhere,

  /// The account and all cloud data. Records on this device are KEPT, so the
  /// user walks away with their own history intact.
  accountAndCloud;

  bool get clearsLocalRecords => this == EAccountDeletionScope.everywhere;
}
