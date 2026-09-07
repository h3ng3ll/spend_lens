import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/services/ui_message_service.dart';
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
    on<AuthEvent>(
      (event, emit) => switch (event) {
        _Watch() => _onWatch(emit),
        _SignInGoogle() => _onSignInGoogle(emit),
        _SignInApple() => _onSignInApple(emit),
        _SignOut() => _onSignOut(emit),
      },
      // Sign-in/out are user-initiated, one-at-a-time actions — `sequential`
      // avoids two concurrent sign-in attempts from a double-tap racing the
      // same Firebase call twice (BLoC rule: no `add()` inside a handler is
      // separately upheld below; this only controls in-flight overlap).
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
    result.fold(
      (_) {
        // watchUser() picks up the new signed-in user reactively — no
        // further emit needed here (the bloc must not emit a status the
        // stream will immediately overwrite).
      },
      (failure) {
        emit(
          state.copyWith(
            status: EAuthStatus.failed,
            errorMessage: failure.message,
          ),
        );
        UiMessageService.showError(failure.message);
      },
    );
  }

  Future<void> _onSignInApple(Emitter<AuthState> emit) async {
    emit(state.copyWith(status: EAuthStatus.signingIn));

    final result = await _appleSignInUseCase();
    result.fold(
      (_) {
        // watchUser() picks up the new signed-in user reactively.
      },
      (failure) {
        emit(
          state.copyWith(
            status: EAuthStatus.failed,
            errorMessage: failure.message,
          ),
        );
        UiMessageService.showError(failure.message);
      },
    );
  }

  Future<void> _onSignOut(Emitter<AuthState> emit) async {
    await _signOutUseCase();
    // watchUser() picks up the signed-out state reactively.
  }
}
