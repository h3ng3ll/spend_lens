import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The rules files must cover every path the client actually writes.
///
/// **The bug this exists for.** `storage.rules` declared only
/// `/users/{uid}/receipts/{fileName}`, while `FirebaseStorageService` also
/// writes `users/{uid}/profile/avatar.jpg`. Storage denies any path no `match`
/// block covers — there is no wildcard fallthrough — so every avatar upload
/// failed with `403 Permission denied` / StorageException `-13021`.
///
/// Nothing in the Dart toolchain reads these files, so `flutter analyze` and
/// every widget test passed while the feature was broken on device. This is
/// the only place the two halves are compared.
void main() {
  String read(String path) {
    final file = File(path);
    expect(
      file.existsSync(),
      isTrue,
      reason: '$path is referenced by firebase.json and must be in the repo',
    );
    return file.readAsStringSync();
  }

  /// Strips comments so a path MENTIONED in prose cannot satisfy a check that
  /// a real `match` block is what covers it.
  String stripComments(String source) => source
      .split('\n')
      .map((line) {
        final index = line.indexOf('//');
        return index == -1 ? line : line.substring(0, index);
      })
      .join('\n');

  group('storage.rules', () {
    late String rules;

    setUp(() => rules = stripComments(read('storage.rules')));

    test('covers the receipt photo path', () {
      expect(rules, contains('/users/{uid}/receipts/{fileName}'));
    });

    test('covers the avatar path', () {
      // `FirebaseStorageService._avatarRef` writes exactly this object.
      expect(
        rules,
        contains('/users/{uid}/profile/avatar.jpg'),
        reason: 'an uncovered path is denied — this is the 403 that broke '
            'avatar upload',
      );
    });

    test('the receipt FOLDER allows list', () {
      // `Reference.list()` enumerates a PREFIX; it does not read a file, so the
      // per-file block never authorises it however permissive that block is.
      //
      // THE REGRESSION THIS CATCHES: without a folder rule,
      // `uploadedReceiptIds` and `usedBytes` both fail with
      // `[firebase_storage/unauthorized]`, and because
      // `UploadReceiptPhotosUseCase` calls `uploadedReceiptIds` first, the
      // ENTIRE sync cycle fails — not just photo upload.
      expect(
        rules,
        contains('/users/{uid}/receipts/{prefix=**}'),
        reason: 'list is granted on the folder prefix, not on objects',
      );

      final listBlock = rules.substring(
        rules.indexOf('/users/{uid}/receipts/{prefix=**}'),
      );
      expect(listBlock, contains('allow list'));
    });

    test('every folder the client lists has a list rule', () {
      // Derived from the code rather than hardcoded: a new listed folder must
      // fail this test rather than fail silently on device.
      //
      // The earlier version of this test only recognised the shape
      // `_xxxFolder(uid).list(`, so when `usedBytes` grew to enumerate the
      // `stores/`, `products/` and `profile/` prefixes through a collected
      // list, it saw nothing to check. Every folder the service references is
      // now checked, which does not depend on how the call is spelled.
      final service = read(
        'lib/core/services/firebase/firebase_storage_service.dart',
      );

      expect(
        rules,
        contains('/users/{uid}/receipts/{prefix=**}'),
        reason: 'uploadedReceiptIds lists this prefix',
      );

      // `usedBytes` enumerates every BILLED folder, so each needs a grant.
      final billedStart = service.indexOf('List<Reference> _billedFolders(');
      expect(
        billedStart,
        isNot(-1),
        reason: 'usedBytes sums the folders this list names',
      );
      final billed = service.substring(
        billedStart,
        service.indexOf('];', billedStart),
      );

      final folders = <String>{
        if (billed.contains('_receiptsFolder')) 'receipts',
        ...RegExp(r"users/\$uid/(\w+)")
            .allMatches(billed)
            .map((match) => match.group(1)!),
      };

      expect(folders, isNotEmpty, reason: 'the source parse must not fail');

      for (final folder in folders) {
        expect(
          rules,
          contains('/users/{uid}/$folder/{prefix=**}'),
          reason: 'usedBytes lists $folder/ — without a {prefix=**} list rule '
              'it fails with [firebase_storage/unauthorized], which takes the '
              'whole sync cycle down, not just the usage figure',
        );
      }
    });

    test('every folder the client WRITES has an object rule', () {
      // THE REGRESSION: product photo upload shipped with no `products/`
      // block at all, so every upload failed with 403 / -13021 — the third
      // time this omission broke a feature here (receipts, avatar, logos).
      // Storage has no wildcard fallthrough.
      final service = read(
        'lib/core/services/firebase/firebase_storage_service.dart',
      );

      final written = RegExp(r"child\('users/\$uid/(\w+)")
          .allMatches(service)
          .map((match) => match.group(1)!)
          .toSet();

      expect(written, isNotEmpty, reason: 'the source parse must not fail');

      for (final folder in written) {
        // An OBJECT rule granting write — not merely any block mentioning the
        // folder. The `{prefix=**}` list blocks match that path too, and they
        // grant `list` only, so checking for the path alone would report a
        // folder as covered while every upload to it is still denied.
        // The trailing segment is either a `{wildcard}` (receipts, stores,
        // products) or a literal filename — `profile/avatar.jpg` is pinned
        // because there is exactly one avatar per user.
        final objectRule = RegExp(
          'match /users/\\{uid\\}/$folder/(?:\\{[^}]+\\}|[\\w.]+) \\{'
          '(?:(?!\n    \\}).)*?allow write',
          dotAll: true,
        );

        expect(
          objectRule.hasMatch(rules),
          isTrue,
          reason: 'the client writes $folder/ but no match block grants write '
              'there — every upload is denied with 403 / -13021',
        );
      }
    });

    test('the avatar can be deleted', () {
      // Required by account deletion and by the staged "Remove photo" action.
      // A missing delete leaves the image behind after the account is gone.
      final avatarBlock = rules.substring(
        rules.indexOf('/users/{uid}/profile/avatar.jpg'),
      );
      expect(avatarBlock, contains('allow delete'));
    });
  });

  group('firestore.rules', () {
    late String rules;

    setUp(() => rules = stripComments(read('firestore.rules')));

    test('covers the profile document', () {
      expect(rules, contains('/users/{uid}'));
    });

    test('covers the record subcollections separately', () {
      // A rule on `/users/{uid}` does NOT cascade to its subcollections.
      expect(rules, contains('/users/{uid}/{collection}/{docId}'));
    });

    test('allowlists every collection ESyncCollection names', () {
      // The enum's own doc comment records this coupling: adding an entity
      // means adding it to the enum AND to the rules.
      final enumSource = read(
        'lib/core/services/firebase/e_sync_collection.dart',
      );

      final names = RegExp(r"ESyncCollection\.\w+ => '(\w+)'")
          .allMatches(enumSource)
          .map((match) => match.group(1)!)
          .toSet();

      expect(names, isNotEmpty, reason: 'the enum parse must not silently fail');

      for (final name in names) {
        expect(
          rules,
          contains("'$name'"),
          reason: '$name syncs but the rules do not allowlist it',
        );
      }
    });

    test('the profile document can be deleted', () {
      // Account deletion (Apple Guideline 5.1.1(v)) removes it last; without
      // this the user's name and email outlive the account.
      expect(rules, contains('delete'));
    });
  });
}
