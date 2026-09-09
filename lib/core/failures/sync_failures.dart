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

/// Sync was requested with no signed-in user. Not an error: the app is
/// fully usable signed out, and this is the normal anonymous path.
class SyncSignedOutFailure extends SyncFailure {
  const SyncSignedOutFailure() : super('Sign in to back up your records');
}
