import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/failures/sync_failures.dart';
import 'package:spend_lens/core/utils/sync_error_classifier.dart';

/// A full cloud account is not a connectivity problem.
void main() {
  FirebaseException error(String code) =>
      FirebaseException(plugin: 'firestore', code: code);

  test('a full quota is its own failure, not offline', () {
    // It used to be grouped with the transport codes, which told a user on
    // a perfectly good connection that they were offline while their
    // records silently never uploaded. Waiting cannot fix this one.
    final failure = classifySyncError(error('resource-exhausted'));

    expect(failure, isA<SyncQuotaExceededFailure>());
    expect(failure, isNot(isA<SyncOfflineFailure>()));
  });

  test('transport codes still classify as offline', () {
    for (final code in const [
      'unavailable',
      'deadline-exceeded',
      'aborted',
      'cancelled',
    ]) {
      expect(
        classifySyncError(error(code)),
        isA<SyncOfflineFailure>(),
        reason: code,
      );
    }
  });

  test('permission codes are unchanged', () {
    expect(
      classifySyncError(error('permission-denied')),
      isA<SyncPermissionFailure>(),
    );
    expect(
      classifySyncError(error('unauthenticated')),
      isA<SyncPermissionFailure>(),
    );
  });

  test('anything else is unexpected, with the detail kept for logs', () {
    final failure = classifySyncError(error('some-new-code'));

    expect(failure, isA<SyncUnexpectedFailure>());
    expect((failure as SyncUnexpectedFailure).diagnostic, contains('some-new-code'));
  });

  test('the quota message names the remedy, not the symptom', () {
    // "Offline" invited a pointless retry. This has to tell the user what
    // would actually change the outcome.
    const failure = SyncQuotaExceededFailure();

    expect(failure.message.toLowerCase(), contains('full'));
  });
}
