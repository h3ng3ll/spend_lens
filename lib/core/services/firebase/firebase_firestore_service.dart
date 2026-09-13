import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import '../logger_service.dart';
import 'e_sync_collection.dart';

typedef DocRef = DocumentReference<Map<String, dynamic>>;
typedef DocSnap = DocumentSnapshot<Map<String, dynamic>>;
typedef QuerySnap = QuerySnapshot<Map<String, dynamic>>;
typedef ColRef = CollectionReference<Map<String, dynamic>>;
typedef QueryRef = Query<Map<String, dynamic>>;

/// The single Firestore access point: reference paths, the auth gate, and
/// batching. Every remote repository resolves this one instance rather than
/// touching `FirebaseFirestore.instance` directly, so the collection layout
/// lives in exactly one file and is testable with a fake Firestore.
///
/// Entities serialize with their own `toJson()`/`fromJson`, with no
/// `withConverter` and no `TimestampConverter`. That is deliberate: every
/// model already emits `DateTime` as an ISO-8601 string via
/// `toIso8601String()`, which Firestore stores verbatim and `fromJson` parses
/// back. Because that format is fixed-width and zero-padded, lexicographic
/// ordering equals chronological ordering, so `where('updatedAt', isGreaterThan:
/// cursor)` is a correct incremental-pull query over strings.
///
/// Do NOT "improve" these fields into Firestore `Timestamp`s: `fromJson`
/// expects a String and would throw on read for every existing document.
class FirebaseFirestoreService {
  /// Firestore's hard cap on operations per `WriteBatch`.
  static const int kBatchLimit = 500;

  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;
  final LoggerService _loggerService;

  // Named public constructor redirecting to a private positional one — the
  // shape `MethodChannelOcrService` and `ApphudSubscriptionRepository`
  // already use, which keeps named arguments at the call site (three
  // same-shaped Firebase singletons are easy to transpose positionally)
  // while satisfying `prefer_initializing_formals`.
  FirebaseFirestoreService({
    required FirebaseFirestore firebaseFirestore,
    required FirebaseAuth firebaseAuth,
    required LoggerService loggerService,
  }) : this._(firebaseFirestore, firebaseAuth, loggerService);

  FirebaseFirestoreService._(
    this._firebaseFirestore,
    this._firebaseAuth,
    this._loggerService,
  );

  /// Enables the on-device write queue.
  ///
  /// Set explicitly rather than left to the platform default so the offline
  /// contract is a recorded decision: a write made with no connection is
  /// queued locally by the SDK and replayed on reconnect, which is why the
  /// sync engine never needs its own outbound retry queue.
  void configure() {
    _firebaseFirestore.settings = const Settings(persistenceEnabled: true);
  }

  /// Current auth state, mirroring `FirebaseAuthRepository.watchUser()` so
  /// gated streams react to the same signal that drives `AuthBloc`. Distinct
  /// on uid, so the gate only rebuilds when the signed-in user actually
  /// changes (sign-in / sign-out / account swap) rather than on every token
  /// refresh.
  Stream<User?> get authState => Rx.merge([
    _firebaseAuth.userChanges(),
    _firebaseAuth.authStateChanges(),
    _firebaseAuth.idTokenChanges(),
  ]).distinct((a, b) => a?.uid == b?.uid);

  /// The signed-in uid, or null. One-shot companion to [authState].
  String? get currentUid => _firebaseAuth.currentUser?.uid;

  /// Gates a Firestore stream on the auth state.
  ///
  /// While a user is signed in, [build] runs with the current uid and its
  /// stream flows through. The instant the user becomes null, `switchMap`
  /// swaps to an empty stream, which cancels the underlying listener — no
  /// manual `StreamSubscription` bookkeeping anywhere.
  ///
  /// A `permission-denied` that races sign-out (a listener firing just before
  /// teardown) is expected and benign: it is swallowed and logged as a
  /// warning. Any other error propagates so real failures still surface.
  ///
  /// The benign error can land on EITHER side of the race — on the inner
  /// stream, or on the outer one when auth emits null first and `switchMap`
  /// has already cancelled the inner subscription. Both levels are therefore
  /// guarded; dropping either lets a post-sign-out error reach the bloc as a
  /// `failed` state.
  Stream<T> authGated<T>(Stream<T> Function(String uid) build) {
    return authState
        .switchMap((user) {
          if (user == null) {
            return Stream<T>.empty();
          }
          return build(user.uid).handleError(
            _warnAndSwallow,
            test: _isExpectedPermissionDenied,
          );
        })
        .handleError(_warnAndSwallow, test: _isExpectedPermissionDenied);
  }

  void _warnAndSwallow(Object error, StackTrace stackTrace) {
    _loggerService.warning(
      'Suppressed post-signout Firestore permission-denied',
      error: error,
    );
  }

  bool _isExpectedPermissionDenied(dynamic error) =>
      error is FirebaseException && error.code == 'permission-denied';

  /// References

  ColRef get usersCollection => _firebaseFirestore.collection('users');

  DocRef userDocument(String uid) => usersCollection.doc(uid);

  /// One record collection for [uid] — the only path a sync repository uses.
  ColRef records(String uid, ESyncCollection collection) =>
      userDocument(uid).collection(collection.path);

  WriteBatch batch() => _firebaseFirestore.batch();

  /// The user's own profile document at `/users/{uid}`.
  ///
  /// Until now [userDocument] was used ONLY to build subcollection paths via
  /// [records] — the document itself was never read or written, so a signed-in
  /// user left no identity record on the server at all.
  Future<Map<String, dynamic>?> fetchUserDocument(String uid) async {
    final snapshot = await userDocument(uid).get();
    return snapshot.data();
  }

  /// Writes [data] into `/users/{uid}`.
  ///
  /// `merge` defaults to TRUE here — deliberately the opposite of
  /// [SyncFirestoreRepository.pushRecords], which sets records wholesale
  /// because the local row is the whole truth for that document.
  ///
  /// The user document is not like that: it is written by several independent
  /// paths (first-sign-in seeding, a later name edit, an avatar upload), each
  /// of which owns only some of the fields. A full overwrite from any one of
  /// them would erase what the others wrote — most damagingly, an avatar
  /// upload would blank the name Apple handed over once and will never send
  /// again.
  Future<void> setUserDocument(
    String uid,
    Map<String, dynamic> data, {
    bool merge = true,
  }) async {
    await userDocument(uid).set(data, SetOptions(merge: merge));
  }

  /// Deletes the `/users/{uid}` document.
  ///
  /// Firestore does NOT cascade: this removes the document's own fields and
  /// leaves its subcollections untouched, so account deletion must clear the
  /// record collections separately (and does).
  Future<void> deleteUserDocument(String uid) async {
    await userDocument(uid).delete();
  }
}
