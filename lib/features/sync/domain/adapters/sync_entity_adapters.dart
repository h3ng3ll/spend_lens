import '../../../../core/models/e_sync_status.dart';
import '../../../../core/services/firebase/e_sync_collection.dart';
import '../../../analytics/domain/models/price_observation/price_observation.dart';
import '../../../analytics/domain/repositories/i_price_observation_local_repository.dart';
import '../../../category/domain/models/category/category.dart';
import '../../../category/domain/repositories/i_category_local_repository.dart';
import '../../../expense/domain/models/expense/expense.dart';
import '../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../product/domain/models/product/product.dart';
import '../../../product/domain/repositories/i_product_local_repository.dart';
import '../../../receipt/domain/models/receipt/receipt.dart';
import '../../../receipt/domain/models/receipt_item/receipt_item.dart';
import '../../../receipt/domain/repositories/i_receipt_item_local_repository.dart';
import '../../../receipt/domain/repositories/i_receipt_local_repository.dart';
import '../../../store/domain/models/store/store.dart';
import '../../../store/domain/repositories/i_store_local_repository.dart';
import 'sync_entity_adapter.dart';

/// Binds each of the seven syncable entities to the generic sync engine.
///
/// This is the ONLY place that names every entity type, which is what keeps
/// push/pull written once rather than seven times. The seven entities share
/// no supertype (each is an independent freezed class), so the binding is a
/// closure bundle rather than an inheritance hierarchy.
///
/// Adding a synced entity means: a factory here, a value in
/// [ESyncCollection], and an entry in the `firestore.rules` allowlist. The
/// rules reject any collection the enum does not name, so forgetting the
/// third step fails closed rather than silently writing to an ungoverned path.
class SyncEntityAdapters {
  final IReceiptLocalRepository _receipts;
  final IReceiptItemLocalRepository _receiptItems;
  final IProductLocalRepository _products;
  final IStoreLocalRepository _stores;
  final ICategoryLocalRepository _categories;
  final IExpenseLocalRepository _expenses;
  final IPriceObservationLocalRepository _priceObservations;

  const SyncEntityAdapters({
    required IReceiptLocalRepository receiptLocalRepository,
    required IReceiptItemLocalRepository receiptItemLocalRepository,
    required IProductLocalRepository productLocalRepository,
    required IStoreLocalRepository storeLocalRepository,
    required ICategoryLocalRepository categoryLocalRepository,
    required IExpenseLocalRepository expenseLocalRepository,
    required IPriceObservationLocalRepository priceObservationLocalRepository,
  }) : _receipts = receiptLocalRepository,
       _receiptItems = receiptItemLocalRepository,
       _products = productLocalRepository,
       _stores = storeLocalRepository,
       _categories = categoryLocalRepository,
       _expenses = expenseLocalRepository,
       _priceObservations = priceObservationLocalRepository;

  /// Every adapter, in dependency order.
  ///
  /// Order matters on the PULL side: a row that references another entity
  /// should land after the row it points at, so a screen rebuilt mid-pull
  /// never renders an expense whose category is not there yet. Categories
  /// and stores are referenced BY receipts and expenses, so they go first.
  List<SyncEntityAdapter<Object>> all() => [
    _wrap(categories()),
    _wrap(stores()),
    _wrap(products()),
    _wrap(receipts()),
    _wrap(receiptItems()),
    _wrap(expenses()),
    _wrap(priceObservations()),
  ];

  /// Erases the type parameter so heterogeneous adapters can share a list.
  /// Each closure keeps its own concrete type internally, so nothing is
  /// actually dynamic at the point of use.
  SyncEntityAdapter<Object> _wrap<T extends Object>(
    SyncEntityAdapter<T> adapter,
  ) => SyncEntityAdapter<Object>(
    collection: adapter.collection,
    readAllIncludingDeleted: () async =>
        (await adapter.readAllIncludingDeleted()).cast<Object>(),
    readPending: () async => (await adapter.readPending()).cast<Object>(),
    writeAllVerbatim: (items) => adapter.writeAllVerbatim(items.cast<T>()),
    toJson: (entity) => _stripDeviceState(adapter.toJson(entity as T)),
    fromJson: (json) => adapter.fromJson(_forceSynced(json)),
    idOf: (entity) => adapter.idOf(entity as T),
    updatedAtOf: (entity) => adapter.updatedAtOf(entity as T),
    syncStatusOf: (entity) => adapter.syncStatusOf(entity as T),
    markSynced: (entity) => adapter.markSynced(entity as T),
    deletedAtOf: (entity) => adapter.deletedAtOf(entity as T),
    purgeLocal: adapter.purgeLocal,
    watchAll: adapter.watchAll,
  );

  SyncEntityAdapter<Expense> expenses() => SyncEntityAdapter<Expense>(
    collection: ESyncCollection.expenses,
    readAllIncludingDeleted: _expenses.getAllIncludingDeleted,
    readPending: _expenses.getPending,
    writeAllVerbatim: (items) => _expenses.saveAll(items, markPending: false),
    toJson: (e) => e.toJson(),
    fromJson: Expense.fromJson,
    idOf: (e) => e.id,
    updatedAtOf: (e) => e.updatedAt,
    syncStatusOf: (e) => e.syncStatus,
    markSynced: (e) => e.copyWith(syncStatus: ESyncStatus.synced),
    deletedAtOf: (e) => e.deletedAt,
    purgeLocal: _expenses.deleteLocalOnly,
    watchAll: _expenses.watchAll,
  );

  SyncEntityAdapter<Receipt> receipts() => SyncEntityAdapter<Receipt>(
    collection: ESyncCollection.receipts,
    readAllIncludingDeleted: _receipts.getAllIncludingDeleted,
    readPending: _receipts.getPending,
    writeAllVerbatim: (items) => _receipts.saveAll(items, markPending: false),
    toJson: (e) => e.toJson(),
    fromJson: Receipt.fromJson,
    idOf: (e) => e.id,
    updatedAtOf: (e) => e.updatedAt,
    syncStatusOf: (e) => e.syncStatus,
    markSynced: (e) => e.copyWith(syncStatus: ESyncStatus.synced),
    deletedAtOf: (e) => e.deletedAt,
    purgeLocal: _receipts.deleteLocalOnly,
    watchAll: _receipts.watchAll,
  );

  SyncEntityAdapter<ReceiptItem> receiptItems() =>
      SyncEntityAdapter<ReceiptItem>(
        collection: ESyncCollection.receiptItems,
        readAllIncludingDeleted: _receiptItems.getAllIncludingDeleted,
        readPending: _receiptItems.getPending,
        writeAllVerbatim: (items) =>
            _receiptItems.saveAll(items, markPending: false),
        toJson: (e) => e.toJson(),
        fromJson: ReceiptItem.fromJson,
        idOf: (e) => e.id,
        updatedAtOf: (e) => e.updatedAt,
        syncStatusOf: (e) => e.syncStatus,
        markSynced: (e) => e.copyWith(syncStatus: ESyncStatus.synced),
        deletedAtOf: (e) => e.deletedAt,
        purgeLocal: _receiptItems.deleteLocalOnly,
        watchAll: _receiptItems.watchAll,
      );

  SyncEntityAdapter<Store> stores() => SyncEntityAdapter<Store>(
    collection: ESyncCollection.stores,
    readAllIncludingDeleted: _stores.getAllIncludingDeleted,
    readPending: _stores.getPending,
    writeAllVerbatim: (items) => _stores.saveAll(items, markPending: false),
    toJson: (e) => e.toJson(),
    fromJson: Store.fromJson,
    idOf: (e) => e.id,
    updatedAtOf: (e) => e.updatedAt,
    syncStatusOf: (e) => e.syncStatus,
    markSynced: (e) => e.copyWith(syncStatus: ESyncStatus.synced),
    deletedAtOf: (e) => e.deletedAt,
    purgeLocal: _stores.deleteLocalOnly,
    watchAll: _stores.watchAll,
  );

  SyncEntityAdapter<Category> categories() => SyncEntityAdapter<Category>(
    collection: ESyncCollection.categories,
    readAllIncludingDeleted: _categories.getAllIncludingDeleted,
    readPending: _categories.getPending,
    writeAllVerbatim: (items) => _categories.saveAll(items, markPending: false),
    toJson: (e) => e.toJson(),
    fromJson: Category.fromJson,
    idOf: (e) => e.id,
    updatedAtOf: (e) => e.updatedAt,
    syncStatusOf: (e) => e.syncStatus,
    markSynced: (e) => e.copyWith(syncStatus: ESyncStatus.synced),
    deletedAtOf: (e) => e.deletedAt,
    // Built-in categories are app INFRASTRUCTURE, not user records: every
    // expense's `categoryId` must resolve to one, so purging them locally
    // leaves the breakdown, donut, drill-down and insights silently empty
    // with every expense falling back to "Other". `DeleteAllRecordsUseCase`
    // already skips them (`if (category.isBuiltIn) continue;`); this path
    // did not, so a tombstoned built-in could still be hard-deleted here.
    purgeLocal: _purgeCategoryUnlessBuiltIn,
    watchAll: _categories.watchAll,
  );

  /// Drops a category locally unless it is one of the 12 built-ins — those
  /// are restored by `SeedCategoriesUseCase` on the next cold start anyway,
  /// so purging them only creates a window where the app has no taxonomy.
  Future<void> _purgeCategoryUnlessBuiltIn(String id) async {
    final all = await _categories.getAllIncludingDeleted();
    final isBuiltIn = all.any(
      (category) => category.id == id && category.isBuiltIn,
    );
    if (isBuiltIn) {
      return;
    }
    await _categories.deleteLocalOnly(id);
  }

  SyncEntityAdapter<Product> products() => SyncEntityAdapter<Product>(
    collection: ESyncCollection.products,
    readAllIncludingDeleted: _products.getAllIncludingDeleted,
    readPending: _products.getPending,
    writeAllVerbatim: (items) => _products.saveAll(items, markPending: false),
    toJson: (e) => e.toJson(),
    fromJson: Product.fromJson,
    idOf: (e) => e.id,
    updatedAtOf: (e) => e.updatedAt,
    syncStatusOf: (e) => e.syncStatus,
    markSynced: (e) => e.copyWith(syncStatus: ESyncStatus.synced),
    deletedAtOf: (e) => e.deletedAt,
    purgeLocal: _products.deleteLocalOnly,
    watchAll: _products.watchAll,
  );

  SyncEntityAdapter<PriceObservation> priceObservations() =>
      SyncEntityAdapter<PriceObservation>(
        collection: ESyncCollection.priceObservations,
        readAllIncludingDeleted: _priceObservations.getAllIncludingDeleted,
        readPending: _priceObservations.getPending,
        writeAllVerbatim: (items) =>
            _priceObservations.saveAll(items, markPending: false),
        toJson: (e) => e.toJson(),
        fromJson: PriceObservation.fromJson,
        idOf: (e) => e.id,
        updatedAtOf: (e) => e.updatedAt,
        syncStatusOf: (e) => e.syncStatus,
        markSynced: (e) => e.copyWith(syncStatus: ESyncStatus.synced),
        deletedAtOf: (e) => e.deletedAt,
        purgeLocal: _priceObservations.deleteLocalOnly,
        watchAll: _priceObservations.watchAll,
      );
}

/// The one field that must never cross the wire.
///
/// `syncStatus` is PER-DEVICE bookkeeping: it records what THIS device still
/// owes the server. It is not shared domain data, and a server that stores it
/// is storing one device's private state as though it were everyone's.
const String _kSyncStatusKey = 'syncStatus';

/// `ESyncStatus.synced`'s wire value, as `json_serializable` emits it.
/// Written as a literal because [_forceSynced] rewrites the raw JSON map
/// before any model decodes it, so the enum itself is not in scope yet.
const String _kSyncedJsonValue = 'synced';

/// Removes [_kSyncStatusKey] from an outgoing document.
///
/// Without this the server permanently stores a STALE value, because
/// `PushPendingChangesUseCase` serializes rows BEFORE marking them synced —
/// so every uploaded document reads `pendingCreate`/`pendingUpdate` forever,
/// even though the local row is `synced` a line later.
///
/// Do NOT "simplify" this back to a bare `adapter.toJson(...)`. Together with
/// [_forceSynced] it is what keeps the sync loop closed; see that function
/// for what the loop actually looked like.
Map<String, dynamic> _stripDeviceState(Map<String, dynamic> json) {
  final copy = Map<String, dynamic>.of(json);
  copy.remove(_kSyncStatusKey);
  return copy;
}

/// Forces an incoming document to `synced` regardless of what it carries.
///
/// A row that arrives from the server IS, by definition, what the server
/// holds — this device owes it nothing. Trusting the document's own
/// `syncStatus` instead is what produced this chain:
///
/// 1. `writeAllVerbatim` lands the row with `markPending: false`, and
///    `_stamped` returns it UNTOUCHED — so a document stamped
///    `pendingUpdate` upstream lands falsely pending here;
/// 2. `_countPending()` counts it, `needsSync` never clears, and the root
///    `BlocListener` re-dispatches `syncNow` forever;
/// 3. `getPending()` re-selects it and pushes it straight back — ping-pong
///    between devices;
/// 4. `PullRemoteChangesUseCase` treats it as having unpublished local edits
///    and SILENTLY refuses every future remote update to that record.
///
/// This runs on decode rather than only on encode because documents already
/// written by earlier builds still carry the field. Forcing it here makes a
/// client immune to that existing data with no migration.
Map<String, dynamic> _forceSynced(Map<String, dynamic> json) {
  final copy = Map<String, dynamic>.of(json);
  copy[_kSyncStatusKey] = _kSyncedJsonValue;
  return copy;
}
