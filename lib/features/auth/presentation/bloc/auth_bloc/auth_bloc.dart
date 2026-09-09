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

  AuthBloc({
    required this._authRepository,
    required this._googleSignInUseCase,
    required this._appleSignInUseCase,
    required this._signOutUseCase,
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

    // The finite, user-initiated actions keep `sequential()` AMONG THEMSELVES —
    // which is what that transformer was actually for: a double-tap must not
    // race two sign-in calls against Firebase. Each concrete type is registered
    // on its own; a single `on<AuthEvent>` here would also match `_Watch`
    // (bloc filters with `event is E`) and handle it a second time.
    on<_SignInGoogle>(
      (event, emit) => _onSignInGoogle(emit),
      transformer: sequential(),
    );
    on<_SignInApple>(
      (event, emit) => _onSignInApple(emit),
      transformer: sequential(),
    );
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
          return state.copyWith(status: EAuthStatus.signedOut, email: '');
        }
        return state.copyWith(
          status: EAuthStatus.signedIn,
          isGoogleAccount: user.providerData.any(
            (info) => info.providerId == 'google.com',
          ),
          email: user.email ?? '',
        );
      },
      onError: (_, _) => state.copyWith(status: EAuthStatus.failed),
    );
  }

  Future<void> _onSignInGoogle(Emitter<AuthState> emit) async {
    emit(state.copyWith(status: EAuthStatus.signingIn));

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
    emit(state.copyWith(status: EAuthStatus.signingIn));

    final result = await _appleSignInUseCase();
    // `Either<Failure, T>`: fold(left = failure, right = success).
    result.fold(
      (failure) => _reportFailure(emit, failure),
      (_) {
        // watchUser() picks up the new signed-in user reactively.
      },
    );
  }

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
    await _signOutUseCase();
    // watchUser() picks up the signed-out state reactively.
  }
}
