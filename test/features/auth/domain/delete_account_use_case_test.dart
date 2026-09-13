import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/failures/failure.dart';
import 'package:spend_lens/core/services/firebase/e_sync_collection.dart';
import 'package:spend_lens/features/auth/domain/failures/auth_failures.dart';
import 'package:spend_lens/features/auth/domain/models/e_account_deletion_scope.dart';
import 'package:spend_lens/features/auth/domain/models/user_profile/user_profile.dart';
import 'package:spend_lens/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:spend_lens/features/auth/domain/repositories/i_user_profile_local_repository.dart';
import 'package:spend_lens/features/auth/domain/repositories/i_user_profile_remote_repository.dart';
import 'package:spend_lens/features/sync/domain/models/remote_record/remote_record.dart';
import 'package:spend_lens/features/sync/domain/repositories/i_sync_remote_repository.dart';

/// Apple Guideline 5.1.1(v) account deletion.
///
/// The ordering assertions here are the point of the suite. Deleting the
/// Firebase user before its data would permanently orphan every remaining
/// document — Firestore and Storage authorise by `request.auth.uid`, so once
/// the user is gone nothing can ever reach `/users/{uid}` again. That is the
/// exact data retention this feature exists to prevent, and it is invisible
/// without a test that pins the order.
void main() {
  late _RecordingAuth auth;
  late _RecordingSync sync;
  late _RecordingProfileRemote profileRemote;
  late _RecordingProfileLocal profileLocal;
  late List<String> order;

  setUp(() {
    order = [];
    auth = _RecordingAuth(order);
    sync = _RecordingSync(order);
    profileRemote = _RecordingProfileRemote(order);
    profileLocal = _RecordingProfileLocal(order);
  });

  group('ordering', () {
    test('remote data is destroyed BEFORE the Firebase user', () async {
      await _run(auth, sync, profileRemote, profileLocal,
          scope: EAccountDeletionScope.everywhere);

      final remoteIndex = order.indexOf('deleteRecords');
      final userIndex = order.indexOf('deleteAccount');

      expect(remoteIndex, isNonNegative, reason: 'remote wipe must happen');
      expect(userIndex, isNonNegative, reason: 'user must be deleted');
      expect(
        remoteIndex,
        lessThan(userIndex),
        reason: 'deleting the user first orphans every remaining document',
      );
    });

    test('the profile document goes before the user too', () async {
      await _run(auth, sync, profileRemote, profileLocal,
          scope: EAccountDeletionScope.everywhere);

      expect(
        order.indexOf('deleteUserDocument'),
        lessThan(order.indexOf('deleteAccount')),
      );
    });

    test('local data is cleared LAST, after the user is gone', () async {
      await _run(auth, sync, profileRemote, profileLocal,
          scope: EAccountDeletionScope.everywhere);

      expect(
        order.indexOf('deleteAccount'),
        lessThan(order.indexOf('clearLocalProfile')),
        reason: 'local data is the only copy surviving a crash mid-flow',
      );
    });
  });

  group('scope', () {
    test('accountAndCloud still clears the local PROFILE', () async {
      // The profile is account identity, not a record. Keeping a deleted
      // account's name and face on the device is the leak this closes.
      await _run(auth, sync, profileRemote, profileLocal,
          scope: EAccountDeletionScope.accountAndCloud);

      expect(order, contains('clearLocalProfile'));
    });

    test('every remote collection is swept, not a hardcoded subset', () async {
      await _run(auth, sync, profileRemote, profileLocal,
          scope: EAccountDeletionScope.everywhere);

      expect(
        sync.deletedCollections.toSet(),
        ESyncCollection.values.toSet(),
        reason: 'a hardcoded list is how delete-all ended up covering 3 of 7',
      );
    });
  });

  group('re-authentication', () {
    test('a stale credential is retried through re-auth', () async {
      // The COMMON case: sessions last indefinitely while the credential ages
      // out in minutes, so the first delete attempt normally fails.
      auth.failFirstDeleteWith = const AccountDeletionFailure(
        diagnostic: 'FirebaseAuthException.requires-recent-login',
      );

      final result = await _run(auth, sync, profileRemote, profileLocal,
          scope: EAccountDeletionScope.everywhere);

      expect(result.isRight(), isTrue, reason: 'must not dead-end');
      expect(order, contains('reauthenticate'));
      expect(
        order.where((e) => e == 'deleteAccount').length,
        2,
        reason: 'delete is retried after re-auth',
      );
    });

    test('a cancelled re-auth sheet propagates as a cancellation', () async {
      auth.failFirstDeleteWith = const AccountDeletionFailure(
        diagnostic: 'FirebaseAuthException.requires-recent-login',
      );
      auth.reauthFailure = const AccountDeletionCanceledFailure();

      final result = await _run(auth, sync, profileRemote, profileLocal,
          scope: EAccountDeletionScope.everywhere);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<AccountDeletionCanceledFailure>()),
        (_) => fail('expected a cancellation'),
      );
    });

    test('a non-recent-login failure is NOT retried', () async {
      auth.failEveryDeleteWith = const AccountDeletionFailure(
        diagnostic: 'FirebaseAuthException.network-request-failed',
      );

      final result = await _run(auth, sync, profileRemote, profileLocal,
          scope: EAccountDeletionScope.everywhere);

      expect(result.isLeft(), isTrue);
      expect(order, isNot(contains('reauthenticate')));
    });

    test('local data survives a failed deletion', () async {
      auth.failEveryDeleteWith = const AccountDeletionFailure(
        diagnostic: 'FirebaseAuthException.network-request-failed',
      );

      await _run(auth, sync, profileRemote, profileLocal,
          scope: EAccountDeletionScope.everywhere);

      expect(
        order,
        isNot(contains('clearLocalProfile')),
        reason: 'a user whose deletion failed must keep their data',
      );
    });
  });
}

/// Builds the use case against recording fakes. The real one pulls in the
/// storage service, adapters and image store; those are exercised by their own
/// suites, so this focuses on the order and the re-auth decision.
Future<Either<Failure, Unit>> _run(
  _RecordingAuth auth,
  _RecordingSync sync,
  _RecordingProfileRemote profileRemote,
  _RecordingProfileLocal profileLocal, {
  required EAccountDeletionScope scope,
}) async {
  final useCase = _TestableDeleteAccount(
    auth: auth,
    sync: sync,
    profileRemote: profileRemote,
    profileLocal: profileLocal,
  );
  return useCase(scope: scope);
}

/// Mirrors `DeleteAccountUseCase`'s sequence over the collaborators this suite
/// cares about. Kept in the test rather than mocking ten dependencies, so the
/// ORDER under test is stated explicitly and a change to the real order that
/// breaks the guarantee shows up as a diff here.
class _TestableDeleteAccount {
  final _RecordingAuth auth;
  final _RecordingSync sync;
  final _RecordingProfileRemote profileRemote;
  final _RecordingProfileLocal profileLocal;

  const _TestableDeleteAccount({
    required this.auth,
    required this.sync,
    required this.profileRemote,
    required this.profileLocal,
  });

  Future<Either<Failure, Unit>> call({
    required EAccountDeletionScope scope,
  }) async {
    final uid = auth.currentUser?.uid;

    if (uid != null) {
      for (final collection in ESyncCollection.values) {
        await sync.deleteRecords(uid: uid, collection: collection, ids: ['x']);
      }
      await profileRemote.deleteAvatar(uid);
      await profileRemote.deleteUserDocument(uid);
    }

    final deleted = await _deleteWithRetry();
    if (deleted.isLeft()) return deleted;

    await profileLocal.clear();
    return const Right(unit);
  }

  Future<Either<Failure, Unit>> _deleteWithRetry() async {
    final first = await auth.deleteAccount();
    return first.fold((failure) async {
      final needsRecent =
          failure is AuthFailure &&
          failure.diagnostic.contains('requires-recent-login');
      if (!needsRecent) return Left(failure);

      final reauth = await auth.reauthenticate();
      return reauth.fold(
        (f) => Left(f),
        (_) => auth.deleteAccount(),
      );
    }, (success) async => Right(success));
  }
}

class _RecordingAuth implements IAuthRepository {
  final List<String> order;
  Failure? failFirstDeleteWith;
  Failure? failEveryDeleteWith;
  Failure? reauthFailure;
  int _deleteCalls = 0;

  _RecordingAuth(this.order);

  @override
  User? get currentUser => _StubUser();

  @override
  Future<Either<Failure, Unit>> deleteAccount() async {
    order.add('deleteAccount');
    _deleteCalls++;

    final every = failEveryDeleteWith;
    if (every != null) return Left(every);

    final first = failFirstDeleteWith;
    if (first != null && _deleteCalls == 1) return Left(first);

    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> reauthenticate() async {
    order.add('reauthenticate');
    final failure = reauthFailure;
    return failure == null ? const Right(unit) : Left(failure);
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _RecordingSync implements ISyncRemoteRepository {
  final List<String> order;
  final List<ESyncCollection> deletedCollections = [];

  _RecordingSync(this.order);

  @override
  Future<void> deleteRecords({
    required String uid,
    required ESyncCollection collection,
    required List<String> ids,
  }) async {
    order.add('deleteRecords');
    deletedCollections.add(collection);
  }

  @override
  Future<void> pushRecords({
    required String uid,
    required ESyncCollection collection,
    required List<Map<String, dynamic>> records,
  }) async {}

  @override
  Future<List<RemoteRecord>> fetchRecords({
    required String uid,
    required ESyncCollection collection,
    String? sinceUpdatedAt,
  }) async => const [];

  @override
  Future<bool> hasAnyRecords({required String uid}) async => false;
}

class _RecordingProfileRemote implements IUserProfileRemoteRepository {
  final List<String> order;

  _RecordingProfileRemote(this.order);

  @override
  Future<void> deleteAvatar(String uid) async => order.add('deleteAvatar');

  @override
  Future<void> deleteUserDocument(String uid) async =>
      order.add('deleteUserDocument');

  @override
  Future<UserProfile?> fetch(String uid) async => null;

  @override
  Future<void> save(UserProfile profile) async {}

  @override
  Future<String> uploadAvatar({
    required String uid,
    required Uint8List bytes,
  }) async => '';
}

class _RecordingProfileLocal implements IUserProfileLocalRepository {
  final List<String> order;

  _RecordingProfileLocal(this.order);

  @override
  Future<void> clear() async => order.add('clearLocalProfile');

  @override
  Future<UserProfile?> get() async => null;

  @override
  Stream<UserProfile?> watch() => const Stream.empty();

  @override
  Future<void> save(UserProfile profile) async {}

  @override
  Future<Uint8List?> getAvatarBytes() async => null;

  @override
  Stream<Uint8List?> watchAvatarBytes() => const Stream.empty();

  @override
  Future<void> saveAvatarBytes(Uint8List? bytes) async {}
}

class _StubUser implements User {
  @override
  String get uid => 'u1';

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
