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
      // Derived from the code rather than hardcoded: a new `.list()` call on
      // another folder must fail this test rather than fail silently on device.
      final service = read(
        'lib/core/services/firebase/firebase_storage_service.dart',
      );

      // Folder helpers whose result has `.list(` called on it.
      final listsReceipts = RegExp(r'_receiptsFolder\(uid\)\.list\(')
          .hasMatch(service);

      if (listsReceipts) {
        expect(rules, contains('/users/{uid}/receipts/{prefix=**}'));
      }

      // No other folder helper should be listed without a matching rule. If
      // one appears, this reason explains what to add.
      final otherFolderLists = RegExp(r'_(?!receiptsFolder)\w*Folder\(uid\)\.list\(')
          .allMatches(service)
          .map((m) => m.group(0))
          .toList();
      expect(
        otherFolderLists,
        isEmpty,
        reason: 'a newly listed folder needs its own {prefix=**} list rule',
      );
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
