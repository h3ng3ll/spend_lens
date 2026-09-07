import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.dart';

part 'auth_state.dart';

part 'auth_state_ext.dart';

part 'auth_bloc.freezed.dart';

/// App-lifetime bloc (design_spendlens.md §5: `registerLazySingleton`,
/// dispatched once from `main()` — never re-dispatched from a screen's
/// `initState`, per BLoC rule A3.8).
///
/// M4 skeleton only: the app is fully usable anonymously (spec §8 — there is
/// NO auth gate anywhere in the router), so the initial/only state at this
/// milestone is "not signed in". Google/Apple sign-in wiring — with the
/// template bugs 1–5 fixed (design_spendlens.md §9) — lands at M9.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState(status: EAuthStatus.signedOut));
}
