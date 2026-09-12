import 'failure.dart';

/// Sync-layer failures (`Either<Failure, T>`, Left = failure — the project's
/// side order).
///
/// One hierarchy, `extends` throughout with a const constructor forwarding to
/// `super(message)`. The reference template mixed `extends` and `implements`
/// (the latter re-declaring `message` as a getter to dodge the const ctor);
/// that inconsistency is not reproduced here.
abstract class SyncFailure extends Failure {
  const SyncFailure(super.message);
}

/// The device could not reach Firestore. Expected, recoverable, and NOT an
/// error state the user should be alarmed by — writes stay queued locally and
/// replay on reconnect.
class SyncOfflineFailure extends SyncFailure {
  const SyncOfflineFailure() : super('Offline — changes will sync later');
}

/// Firestore rejected the operation. In practice this means the security
/// rules and the requested path disagree, or the session expired mid-flight.
class SyncPermissionFailure extends SyncFailure {
  const SyncPermissionFailure() : super('Sync not permitted for this account');
}

/// Anything else. Carries the underlying detail for logs, while [message]
/// stays user-facing.
class SyncUnexpectedFailure extends SyncFailure {
  final String diagnostic;

  const SyncUnexpectedFailure({this.diagnostic = ''})
    : super('Sync failed — tap to retry');
}

/// Cloud storage is full — the account is at its quota.
///
/// Distinct from [SyncOfflineFailure], which it used to be lumped in with
/// (`resource-exhausted` was classified as offline). That misreported a full
/// account as a connectivity problem, so the user saw "Offline" while online
/// and had no idea why records never synchronized. This one is NOT
/// self-healing: waiting does not fix it, only freeing space or upgrading
/// does, and the message has to say so.
class SyncQuotaExceededFailure extends SyncFailure {
  const SyncQuotaExceededFailure()
    : super('Cloud storage is full — free up space or upgrade');
}

/// Sync was requested with no signed-in user. Not an error: the app is
/// fully usable signed out, and this is the normal anonymous path.
class SyncSignedOutFailure extends SyncFailure {
  const SyncSignedOutFailure() : super('Sign in to back up your records');
}
