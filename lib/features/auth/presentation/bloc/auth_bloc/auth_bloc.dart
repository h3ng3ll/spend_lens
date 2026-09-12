import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/failures/failure.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../domain/failures/auth_failures.dart';
import '../../../domain/repositories/i_auth_repository.dart';
import '../../../domain/use_cases/apple_sign_in_use_case.dart';
import '../../../domain/use_cases/google_sign_in_use_case.dart';
import '../../../domain/use_cases/sign_out_use_case.dart';
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

  AuthBloc({
    required this._authRepository,
    required this._googleSignInUseCase,
    required this._appleSignInUseCase,
    required this._signOutUseCase,
    required this._clearSyncedLocalRecords,
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
          return state.copyWith(
            status: EAuthStatus.signedOut,
            email: '',
            isGoogleAccount: false,
          );
        }
        return state.copyWith(
          status: EAuthStatus.signedIn,
          isGoogleAccount: user.providerData.any(
            (info) => info.providerId == 'google.com',
          ),
          email: user.email ?? '',
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

  Future<void> _onSignInGoogle(Emitter<AuthState> emit) async {
    if (_isAlreadySignedIn()) return;
    emit(_startingSignIn());

    final result = await _googleSignInUseCase();
    // `Either<Failure, T>`: fold(left = failure, right = success).
    result.fold(
      (failure) => _reportFailure(emit, failure),
      (_) {
        // watchUser() picks up the new signed-in user reactively — no
        // further emit needed here (the bloc must not emit a status the
        // stream will immediately overwrite).
      },
    );
  }

  Future<void> _onSignInApple(Emitter<AuthState> emit) async {
    if (_isAlreadySignedIn()) return;
    emit(_startingSignIn());

    final result = await _appleSignInUseCase();
    // `Either<Failure, T>`: fold(left = failure, right = success).
    result.fold(
      (failure) => _reportFailure(emit, failure),
      (_) {
        // watchUser() picks up the new signed-in user reactively.
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

    await _signOutUseCase();
    // watchUser() picks up the signed-out state reactively.
  }
}
