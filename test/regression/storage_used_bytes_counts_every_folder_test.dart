import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// REGRESSION: the Profile storage bar read 0 MB with a full bucket.
///
/// `FirebaseStorageService.usedBytes` summed `users/{uid}/receipts/` alone,
/// on the reasoning that the UI copy calls the figure receipt photos. But the
/// quota Firebase actually enforces covers the WHOLE bucket, so store logos,
/// product photos and the avatar consumed it while going uncounted.
///
/// The user's report: they deleted everything in Firestore and Storage by
/// hand, uploaded one store logo, and the bar still said `0 MB из 100 MB`.
/// The upload had worked; the measurement was looking at one of four folders.
///
/// Worse than a wrong label: near the ceiling the bar would show room that
/// was not there, and the upload would be refused with a quota error the UI
/// had just contradicted.
///
/// This is a SOURCE test because `FirebaseStorageService` takes a concrete
/// `FirebaseStorage`, which cannot be constructed without the platform
/// plugin. Pinning the folder list is what is actually at stake — a folder
/// added later and left out of the sum reproduces the bug exactly.
void main() {
  late String service;

  setUp(() {
    final file = File(
      'lib/core/services/firebase/firebase_storage_service.dart',
    );
    expect(file.existsSync(), isTrue);
    service = file.readAsStringSync();
  });

  /// The `_billedFolders` body — the single list `usedBytes` iterates.
  String billedFolders() {
    final start = service.indexOf('List<Reference> _billedFolders(');
    expect(start, isNot(-1), reason: '_billedFolders is what usedBytes sums');
    final end = service.indexOf('];', start);
    expect(end, isNot(-1));
    return service.substring(start, end);
  }

  test('counts the receipts folder', () {
    expect(billedFolders(), contains('_receiptsFolder(uid)'));
  });

  test('counts store logos — the folder the user actually uploaded to', () {
    expect(
      billedFolders(),
      contains("users/\$uid/stores"),
      reason: 'THE BUG: a logo consumed the quota and the bar showed 0 MB',
    );
  });

  test('counts product photos', () {
    expect(billedFolders(), contains("users/\$uid/products"));
  });

  test('counts the avatar folder', () {
    // One small object, but still billed. Omitting it would reintroduce the
    // same class of error at a smaller scale.
    expect(billedFolders(), contains("users/\$uid/profile"));
  });

  test('every folder the service writes to is billed', () {
    // Derived from the code, so a NEW folder helper fails here rather than
    // silently going uncounted on device. This is the check that would have
    // caught the original bug: `_storeLogoRef` and `_productImageRef` both
    // existed while `usedBytes` ignored them.
    final writtenFolders = RegExp(r"child\('users/\$uid/(\w+)")
        .allMatches(service)
        .map((match) => match.group(1)!)
        .toSet();

    expect(
      writtenFolders,
      isNotEmpty,
      reason: 'the source parse must not silently fail',
    );

    final billed = billedFolders();
    for (final folder in writtenFolders) {
      expect(
        billed.contains(folder) ||
            // `receipts/` is reached through its named helper.
            (folder == 'receipts' && billed.contains('_receiptsFolder')),
        isTrue,
        reason: "'$folder' is written but not counted by usedBytes — its "
            'bytes consume the quota while the bar under-reports them',
      );
    }
  });

  test('usedBytes iterates the billed list rather than one folder', () {
    final start = service.indexOf('Future<int> usedBytes(');
    expect(start, isNot(-1));
    final body = service.substring(start, service.indexOf('\n  }', start));

    expect(
      body,
      contains('_billedFolders(uid)'),
      reason: 'summing a single folder inline is how this broke the first time',
    );
  });
}
