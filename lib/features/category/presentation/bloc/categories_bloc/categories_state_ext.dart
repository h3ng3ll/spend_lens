part of 'categories_bloc.dart';

/// The UI reads these getters, never the enum directly.
extension CategoriesStateX on CategoriesState {
  bool get isInitial => status == ECategoriesStatus.initial;

  bool get isLoading => status == ECategoriesStatus.loading;

  bool get isLoaded => status == ECategoriesStatus.loaded;

  bool get isFailed => status == ECategoriesStatus.failed;

  /// The most recent quickCreate/rename/delete write failed. A one-shot
  /// signal for a `BlocListener` error toast.
  bool get isWriteFailed => lastWriteFailed;
}
