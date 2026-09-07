part of 'categories_bloc.dart';

@freezed
sealed class CategoriesEvent with _$CategoriesEvent {
  /// Subscribes to the live category list. Idempotent — safe even though it
  /// is dispatched exactly once, from `main()` (BLoC rule A3.8).
  const factory CategoriesEvent.watch() = _Watch;

  /// Creates a new custom category from typed free text — the Categories
  /// artboard's quick-create row, and `NewCategoryPage`'s Create button.
  /// The bloc resolves the next custom color and id; the UI never builds a
  /// [Category] itself.
  const factory CategoriesEvent.quickCreate(String name) = _QuickCreate;

  /// Renames an existing category (the Categories artboard's pencil
  /// action).
  const factory CategoriesEvent.rename(Category category, String newName) =
      _Rename;

  /// Deletes a custom category by id (the Categories artboard's delete
  /// action). The confirm dialog has already run by the time this is
  /// dispatched.
  const factory CategoriesEvent.delete(String categoryId) = _Delete;
}
