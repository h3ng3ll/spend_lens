import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/failures/failure.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../domain/failures/auth_failures.dart';
import '../../../domain/models/e_account_deletion_scope.dart';
import '../../../domain/models/user_profile/user_profile.dart';
import '../../../domain/repositories/i_auth_repository.dart';
import '../../../domain/repositories/i_user_profile_local_repository.dart';
import '../../../domain/use_cases/apple_sign_in_use_case.dart';
import '../../../domain/use_cases/delete_account_use_case.dart';
import '../../../domain/use_cases/google_sign_in_use_case.dart';
import '../../../domain/use_cases/seed_profile_from_credentials_use_case.dart';
import '../../../domain/use_cases/sign_out_use_case.dart';
import '../../../domain/use_cases/watch_user_profile_use_case.dart';
import '../../../../sync/domain/use_cases/clear_synced_local_records_use_case.dart';

part 'auth_event.dart';

part 'auth_state.dart';

part 'auth_state_ext.dart';

part 'auth_bloc.freezed.dart';

/// App-lifetime bloc (design_spendlens.md §5: `registerLazySingleton`,
/// dispatched once from `main()` — never re-dispatched from a screen's
/// `initState`, per BLoC rule A3.8).
///
/// The app is fully usable anonymously (spec §8 — there is NO auth gate
/// anywhere in the router); this bloc only reflects sign-in state for the
/// Profile screen and gates the signed-in-only rows there. M9 wires the
/// real Google/Apple sign-in flow, with the reference template's bugs 1–5
/// fixed (design_spendlens.md §9).
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository _authRepository;
  final GoogleSignInUseCase _googleSignInUseCase;
  final AppleSignInUseCase _appleSignInUseCase;
  final SignOutUseCase _signOutUseCase;
  final ClearSyncedLocalRecordsUseCase _clearSyncedLocalRecords;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final SeedProfileFromCredentialsUseCase _seedProfileFromCredentials;
  final WatchUserProfileUseCase _watchUserProfile;
  final IUserProfileLocalRepository _userProfileLocalRepository;

  AuthBloc({
    required this._authRepository,
    required this._googleSignInUseCase,
    required this._appleSignInUseCase,
    required this._signOutUseCase,
    required this._clearSyncedLocalRecords,
    required this._deleteAccountUseCase,
    required this._seedProfileFromCredentials,
    required this._watchUserProfile,
    required this._userProfileLocalRepository,
  }) : super(const AuthState(status: EAuthStatus.signedOut)) {
    // `_Watch` is registered SEPARATELY from the action events, and this is
    // load-bearing.
    //
    // THE BUG THIS FIXES — why the sign-in buttons appeared dead: every event
    // was previously funnelled through ONE `on<AuthEvent>` carrying
    // `transformer: sequential()`. `sequential()` is
    // `events.asyncExpand(mapper)`: it handles one event at a time and waits
    // for each handler's Future to COMPLETE before starting the next.
    // `_onWatch` awaits `emit.forEach(...)` over Firebase's
    // `authStateChanges()` — an infinite stream that never closes — so that
    // Future NEVER completes. Since `AuthEvent.watch()` is dispatched first
    // from `main()`, it permanently occupied the queue and every later
    // `signInGoogle` / `signInApple` / `signOut` event sat behind it, unhandled
    // forever. The tap dispatched an event that was never processed: no
    // sign-in sheet, no error, no state change — indistinguishable from an
    // unwired button, and invisible to `flutter analyze`.
    //
    // A long-lived stream subscription must therefore never share a sequential
    // queue with user-initiated actions. `_Watch` gets `restartable()`, which
    // also cancels a previous subscription if it is ever re-dispatched.
    on<_Watch>((event, emit) => _onWatch(emit), transformer: restartable());

    // The profile stream is registered SEPARATELY from `_Watch` for the same
    // reason `_Watch` is separate from the actions: it is another infinite
    // stream whose handler Future never completes, so sharing a sequential
    // queue with it would starve everything behind it.
    on<_WatchProfile>(
      (event, emit) => _onWatchProfile(emit),
      transformer: restartable(),
    );
    on<_WatchAvatar>(
      (event, emit) => _onWatchAvatar(emit),
      transformer: restartable(),
    );

    // `sequential()`: seeds for different uids must not interleave their
    // read-modify-write on the same stored profile.
    on<_SeedProfile>(_onSeedProfile, transformer: sequential());

    // The sign-in actions are `droppable()`, NOT `sequential()`.
    //
    // The intent was always "a double-tap must not race two sign-in calls
    // against Firebase" — but `sequential()` does not prevent a double tap,
    // it QUEUES it: both taps run, one after the other. The observed result
    // was that the first tap signed in successfully and a queued second tap
    // then opened a redundant Credential Manager sheet, which Android
    // immediately cancelled (`[16] Cancelled by user.`). That cancellation
    // was reported as `EAuthStatus.failed`, so a WORKING session was
    // overwritten with "Google sign-in failed." while the user stayed signed
    // in underneath.
    //
    // `droppable()` discards a tap that arrives while one is in flight,
    // which is what the original comment described.
    on<_SignInGoogle>(
      (event, emit) => _onSignInGoogle(emit),
      transformer: droppable(),
    );
    on<_SignInApple>(
      (event, emit) => _onSignInApple(emit),
      transformer: droppable(),
    );
    // Sign-out stays `sequential()`: it is idempotent and must never be
    // dropped — a discarded sign-out leaves the user signed in while the UI
    // has already moved on.
    on<_SignOut>(
      (event, emit) => _onSignOut(emit),
      transformer: sequential(),
    );
    // `droppable()`, like the sign-in actions: deletion is irreversible and
    // makes several round trips, so a second tap while one is in flight must
    // be discarded rather than queued behind it.
    on<_DeleteAccount>(_onDeleteAccount, transformer: droppable());
  }

  Future<void> _onWatch(Emitter<AuthState> emit) async {
    await emit.forEach<User?>(
      _authRepository.watchUser(),
      onData: (user) {
        if (user == null) {
          // `isGoogleAccount` is reset alongside `email`: it is provider
          // identity, and leaving the previous session's value behind makes
          // the Profile status pill name the WRONG provider on the next
          // sign-in until `providerData` is read again.
          // `uid`, `firstName`, `lastName` and `avatarFilename` are reset
          // alongside `email` for the same reason `isGoogleAccount` is: they
          // are IDENTITY, and leaving them behind would show the previous
          // user's name and face to whoever signs in next on this device.
          return state.copyWith(
            status: EAuthStatus.signedOut,
            email: '',
            isGoogleAccount: false,
            uid: '',
            firstName: '',
            lastName: '',
            avatarFilename: '',
          );
        }
        // A session RESTORED at launch never passes through a sign-in
        // handler, so seeding could not be left there alone.
        //
        // THE BUG THIS FIXES: Edit Profile read its email from the stored
        // `UserProfile`, while Profile read it live from `AuthState`. Anyone
        // already signed in when this feature shipped had no stored profile at
        // all, so Profile showed the address and the edit screen showed an
        // empty field — for the same account, on adjacent screens.
        //
        // Seeding is idempotent (it only fills EMPTY fields), so running it on
        // every restore cannot overwrite a name the user has since edited.
        _ensureProfileSeeded(user);

        return state.copyWith(
          status: EAuthStatus.signedIn,
          isGoogleAccount: user.providerData.any(
            (info) => info.providerId == 'google.com',
          ),
          email: user.email ?? '',
          uid: user.uid,
        );
      },
      // Carries a message, because a `failed` state with an empty
      // `errorMessage` renders as a blank toast — worse than silence, since
      // it looks like the app broke and says nothing.
      onError: (error, _) => state.copyWith(
        status: EAuthStatus.failed,
        errorMessage: const AuthUnavailableFailure().message,
      ),
    );
  }

  /// Requests a seed for [user] unless one is already in flight for them.
  ///
  /// `onData` must return a state synchronously, so the async work is handed to
  /// a dedicated event instead of awaited here. The uid guard keeps a token
  /// refresh — `watchUser()` can emit repeatedly for one session — from
  /// queueing a redundant Firestore read on every tick.
  void _ensureProfileSeeded(User user) {
    if (_seededUid == user.uid) return;
    _seededUid = user.uid;
    add(const AuthEvent.seedProfile());
  }

  /// The uid already seeded this session, so a repeat emission is a no-op.
  /// Cleared on sign-out so the next user is seeded properly.
  String? _seededUid;

  Future<void> _onSeedProfile(
    _SeedProfile event,
    Emitter<AuthState> emit,
  ) async {
    // Re-read rather than taking the user off the event — see the event's doc
    // comment: a `User` payload would be logged verbatim by `AppObserver`.
    final user = _authRepository.currentUser;
    if (user == null) return;

    // No `appleCredentials`: a restored session has none to offer. Apple sends
    // the name only at first authorization, and that path is handled in
    // `_onSignInApple` where the credentials actually exist.
    await _seedProfileFromCredentials(user: user);
  }

  /// Projects the stored profile onto [AuthState].
  ///
  /// The name/photo live in Hive rather than on the Firebase user, so they
  /// need their own subscription — but they are surfaced through the state the
  /// three avatar surfaces ALREADY watch, so none of them opens a second one.
  Future<void> _onWatchProfile(Emitter<AuthState> emit) async {
    await emit.forEach<UserProfile?>(
      _watchUserProfile(),
      onData: (profile) => state.copyWith(
        firstName: profile?.firstName ?? '',
        lastName: profile?.lastName ?? '',
      ),
      // A profile read failure must NOT flip the auth status to failed: the
      // session is fine, only the decoration is missing. Fall back to no name.
      onError: (error, _) => state.copyWith(firstName: '', lastName: ''),
    );
  }

  Future<void> _onWatchAvatar(Emitter<AuthState> emit) async {
    await emit.forEach<String?>(
      _userProfileLocalRepository.watchAvatarFilename(),
      onData: (filename) => state.copyWith(avatarFilename: filename ?? ''),
      onError: (error, _) => state.copyWith(avatarFilename: ''),
    );
  }

  Future<void> _onSignInGoogle(Emitter<AuthState> emit) async {
    if (_isAlreadySignedIn()) return;
    emit(_startingSignIn());

    final result = await _googleSignInUseCase();
    // `Either<Failure, T>`: fold(left = failure, right = success).
    //
    // The success value is no longer DISCARDED. Google resends
    // `displayName`/`photoURL` on every sign-in, so this is not the
    // irreversible case Apple is — but it is the same seeding path, and
    // routing both providers through it keeps one place responsible for
    // deciding what a sign-in contributes to the profile.
    await result.fold(
      (failure) async => _reportFailure(emit, failure),
      (credential) async {
        // watchUser() picks up the new signed-in user reactively — no
        // further emit needed here (the bloc must not emit a status the
        // stream will immediately overwrite).
        final user = credential.user;
        if (user == null) return;
        await _seedProfileFromCredentials(user: user);
      },
    );
  }

  Future<void> _onSignInApple(Emitter<AuthState> emit) async {
    if (_isAlreadySignedIn()) return;
    emit(_startingSignIn());

    final result = await _appleSignInUseCase();
    // `Either<Failure, T>`: fold(left = failure, right = success).
    //
    // **THE BUG THIS FIXES.** The success branch used to be `(_) {}` — the
    // result was discarded entirely. Apple returns `givenName`/`familyName`
    // ONLY on the first authorization for this app; every later sign-in sends
    // nulls, permanently, unless the user revokes the app in iOS Settings.
    // `FirebaseAuthRepository` captured those names correctly into
    // `AppleSignInResult.credentials`, and then this callback threw them away
    // — so the single moment the name was obtainable was lost, and no amount
    // of signing in again could recover it.
    //
    // Seeding is awaited rather than fire-and-forget: `unawaited` is banned in
    // `lib/`, and this is exactly the class of defect that ban exists for — a
    // dropped persistence write that fails silently.
    await result.fold(
      (failure) async => _reportFailure(emit, failure),
      (appleResult) async {
        // watchUser() picks up the new signed-in user reactively.
        final user = appleResult.userCredential.user;
        if (user == null) return;
        await _seedProfileFromCredentials(
          user: user,
          appleCredentials: appleResult.credentials,
        );
      },
    );
  }

  /// The `signingIn` state, with any previous failure CLEARED.
  ///
  /// `copyWith(status: signingIn)` alone carried the old `errorMessage`
  /// forward, so a state that had once failed kept the message through every
  /// later attempt. Profile's listener fires on `errorMessage` changing, so
  /// a stale message re-toasted "Google sign-in failed." on each new
  /// sign-in — including ones that went on to SUCCEED. A new attempt starts
  /// from no error, always.
  AuthState _startingSignIn() =>
      state.copyWith(status: EAuthStatus.signingIn, errorMessage: '');

  /// Whether a session already exists, making a sign-in request redundant.
  ///
  /// `droppable()` only discards taps that arrive while one is IN FLIGHT. A
  /// tap arriving after a successful sign-in is a fresh event, and running it
  /// re-opens the platform credential sheet for an account that is already
  /// signed in. Android cancels that redundant sheet immediately
  /// (`[16] Cancelled by user.`), the cancellation is reported as a failure,
  /// and a WORKING session ends up displaying "Google sign-in failed."
  ///
  /// Checked against the repository rather than `state`, because `state` is
  /// updated asynchronously by `watchUser()` and can still read `signingIn`
  /// at the moment the next tap lands.
  bool _isAlreadySignedIn() => _authRepository.currentUser != null;

  /// The ONE place a sign-in failure becomes visible.
  ///
  /// Two things this guarantees, both of which were previously missing and
  /// together produced the "tapping the buttons does nothing" report:
  ///
  /// 1. **A failure ALWAYS leaves `signingIn`.** Without this the bloc could
  ///    sit in `signingIn` forever, so the UI showed no error and no progress
  ///    — indistinguishable from a dead callback.
  /// 2. **A failure ALWAYS toasts.** In debug the toast carries the platform
  ///    diagnostic (`GoogleSignInException.providerConfigurationError`, i.e. a
  ///    missing Android OAuth client / unregistered SHA-1), so the cause is
  ///    readable on the device without attaching a log. Release builds keep
  ///    the short human message — the diagnostic still goes to the log.
  ///
  /// A user-initiated CANCEL is deliberately not toasted: the user already
  /// knows they dismissed the sheet, and a toast for it is noise. It still
  /// clears `signingIn` and is still logged.
  void _reportFailure(Emitter<AuthState> emit, Failure failure) {
    final isCanceled =
        failure is GoogleSignInCanceledFailure ||
        failure is AppleSignInCanceledFailure;

    emit(
      state.copyWith(
        status: isCanceled ? EAuthStatus.signedOut : EAuthStatus.failed,
        errorMessage: isCanceled ? '' : failure.message,
      ),
    );

    if (isCanceled) return;

    final verbose = failure is AuthFailure ? failure.verboseMessage : null;
    UiMessageService.showError(
      kDebugMode && verbose != null ? verbose : failure.message,
    );
  }

  /// Deletes the account, then lets `watchUser()` settle the signed-out state.
  ///
  /// Emits `deleted` on success as a ONE-SHOT signal for the UI to leave the
  /// Profile screen. It is not a resting state: the auth stream reports the
  /// user as gone moments later and overwrites it with `signedOut`.
  Future<void> _onDeleteAccount(
    _DeleteAccount event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: EAuthStatus.deleting, errorMessage: ''));

    final result = await _deleteAccountUseCase(scope: event.scope);

    result.fold(
      (failure) {
        // A cancelled re-auth sheet is the user's own choice — return to the
        // signed-in state silently rather than reporting a failure. Same
        // treatment a cancelled sign-in gets.
        final isCanceled = failure is AccountDeletionCanceledFailure;
        emit(
          state.copyWith(
            status: isCanceled ? EAuthStatus.signedIn : EAuthStatus.failed,
            errorMessage: isCanceled ? '' : failure.message,
          ),
        );
      },
      (_) {
        // Re-arm seeding: the guard holds the deleted uid, and without this a
        // new sign-in on this device would skip building its profile.
        _seededUid = null;
        emit(state.copyWith(status: EAuthStatus.deleted, errorMessage: ''));
      },
    );
  }

  Future<void> _onSignOut(Emitter<AuthState> emit) async {
    // BEFORE signing out, while the session still exists: drop local copies
    // of records the server already holds. They are fetched back — photos
    // included — on the next sign-in.
    //
    // A LAST-RESORT guard, not the sync's error channel: the cleanup folds
    // its own `Either` internally and a failed sync is already handled there
    // (fewer rows qualify as synced, so more stay on the device). This
    // catches only an unexpected THROW — a Hive I/O error, say — because
    // sign-out must never be blocked by local housekeeping.
    try {
      await _clearSyncedLocalRecords();
    } catch (_) {
      // Intentionally swallowed — see above.
    }

    // The cached profile and avatar are dropped on the way out. Without this
    // the next user to sign in on this device sees the PREVIOUS user's name
    // and face until their own profile loads — a privacy defect, and the same
    // class of leak the `isGoogleAccount` reset above already guards against.
    //
    // Same last-resort shape as the cleanup above: a local housekeeping
    // failure must never block sign-out.
    try {
      await _userProfileLocalRepository.clear();
    } catch (_) {
      // Intentionally swallowed — see above.
    }

    // Re-arm seeding, so signing in as a different user rebuilds the profile
    // rather than being skipped by the previous session's guard.
    _seededUid = null;

    await _signOutUseCase();
    // watchUser() picks up the signed-out state reactively.
  }
}
