part of 'categories_bloc.dart';

@freezed
sealed class CategoriesEvent with _$CategoriesEvent {
  /// Subscribes to the live category list. Idempotent — safe even though it
  /// is dispatched exactly once, from `main()` (BLoC rule A3.8).
  const factory CategoriesEvent.watch() = _Watch;
}
