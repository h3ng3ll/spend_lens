/// The record collections that sync to Firestore, and their remote names.
///
/// Single source of truth for the seven syncable entities: the Firestore
/// security rules allowlist these exact names, and `SyncBloc` iterates this
/// enum rather than repeating a string list per use case. Adding an entity
/// means adding it HERE and to `firestore.rules` — the rules reject any
/// subcollection this enum does not name.
///
/// `AppSettings` is deliberately absent. It has no `id`, no `updatedAt` and no
/// `syncStatus`, and it holds device-scoped preferences (locale, theme, flash
/// mode) that should not follow a user between devices.
enum ESyncCollection {
  receipts,
  receiptItems,
  products,
  stores,
  categories,
  expenses,
  priceObservations;

  /// The Firestore subcollection name under `/users/{uid}/`.
  ///
  /// lowerCamelCase, matching the enum value — NOT the snake_case Hive box
  /// name. The two namespaces are independent and neither should be derived
  /// from the other by string munging.
  String get path => switch (this) {
    ESyncCollection.receipts => 'receipts',
    ESyncCollection.receiptItems => 'receiptItems',
    ESyncCollection.products => 'products',
    ESyncCollection.stores => 'stores',
    ESyncCollection.categories => 'categories',
    ESyncCollection.expenses => 'expenses',
    ESyncCollection.priceObservations => 'priceObservations',
  };
}
