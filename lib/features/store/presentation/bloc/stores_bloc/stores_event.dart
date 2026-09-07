part of 'stores_bloc.dart';

@freezed
sealed class StoresEvent with _$StoresEvent {
  /// Subscribes to the live store list. Idempotent — safe even though it is
  /// dispatched exactly once, from `main()` (BLoC rule A3.8).
  const factory StoresEvent.watch() = _Watch;
}
