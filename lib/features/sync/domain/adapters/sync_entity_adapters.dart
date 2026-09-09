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
    toJson: (entity) => adapter.toJson(entity as T),
    fromJson: adapter.fromJson,
    idOf: (entity) => adapter.idOf(entity as T),
    updatedAtOf: (entity) => adapter.updatedAtOf(entity as T),
    syncStatusOf: (entity) => adapter.syncStatusOf(entity as T),
    markSynced: (entity) => adapter.markSynced(entity as T),
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
    watchAll: _categories.watchAll,
  );

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
        watchAll: _priceObservations.watchAll,
      );
}
