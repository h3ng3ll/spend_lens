import 'package:firebase_core/firebase_core.dart';

import '../failures/sync_failures.dart';

/// Maps a thrown object to the right [SyncFailure].
///
/// This is the second half of offline detection. `ConnectivityService` answers
/// "is there a network?"; this answers "did the operation actually land?" —
/// which is a different question, because a captive portal reports a healthy
/// connection while every Firestore call times out.
///
/// The reference template's use cases all ended in a blanket `catch (_)`
/// returning one generic failure, which collapsed offline, permission-denied
/// and malformed-data into a single message. Branching on the code is what
/// lets the UI say "Offline" (benign, self-healing) instead of "Sync failed"
/// (looks broken, invites a pointless retry).
SyncFailure classifySyncError(Object error) {
  if (error is FirebaseException) {
    return switch (error.code) {
      // Transport-level: no route to the backend, or it did not answer in
      // time. Firestore has already queued any write locally.
      'unavailable' ||
      'deadline-exceeded' ||
      'resource-exhausted' ||
      'aborted' ||
      'cancelled' => const SyncOfflineFailure(),

      // Rules said no, or the session is gone.
      'permission-denied' ||
      'unauthenticated' => const SyncPermissionFailure(),

      _ => SyncUnexpectedFailure(
        diagnostic: '${error.plugin}/${error.code}: ${error.message ?? ''}',
      ),
    };
  }

  return SyncUnexpectedFailure(diagnostic: error.toString());
}
