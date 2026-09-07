import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:spend_lens/core/di/injection.dart';
import 'package:spend_lens/core/routes/init_router/init_router.dart';
import 'package:spend_lens/features/analytics/domain/models/price_observation/price_observation.dart';
import 'package:spend_lens/features/analytics/domain/repositories/i_price_observation_local_repository.dart';
import 'package:spend_lens/features/expense/domain/models/expense/e_expense_source.dart';
import 'package:spend_lens/features/expense/domain/models/expense/expense.dart';
import 'package:spend_lens/features/expense/domain/repositories/i_expense_local_repository.dart';
import 'package:spend_lens/features/product/domain/models/product/e_unit.dart';
import 'package:spend_lens/features/product/domain/models/product/product.dart';
import 'package:spend_lens/features/product/domain/repositories/i_product_local_repository.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt/receipt.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt_item/receipt_item.dart';
import 'package:spend_lens/features/receipt/domain/repositories/i_receipt_item_local_repository.dart';
import 'package:spend_lens/features/receipt/domain/repositories/i_receipt_local_repository.dart';
import 'package:spend_lens/features/settings/domain/models/app_settings/e_app_theme_mode.dart';
import 'package:spend_lens/features/settings/domain/repositories/i_settings_local_repository.dart';
import 'package:spend_lens/features/store/domain/models/store/e_store_type.dart';
import 'package:spend_lens/features/store/domain/models/store/store.dart';
import 'package:spend_lens/features/store/domain/repositories/i_store_local_repository.dart';
import 'package:spend_lens/main.dart' as app;

/// Names of captures that failed at runtime. Asserted empty at the end so a
/// silently-failed capture becomes a hard test failure instead of a missing
/// PNG in the archive.
final Set<String> _failedCaptures = <String>{};

// ─────────────────────────── seed identifiers ───────────────────────────
//
// Stable ids so the run is reproducible: the same store / record / product
// detail screens are captured on every run, and the numeric prefixes keep
// pointing at the same content.

const String _kStoreLinella = 'store_linella';
const String _kStoreNr1 = 'store_nr1';
const String _kStoreKaufland = 'store_kaufland';
const String _kStoreFarmacia = 'store_farmacia';
const String _kStoreTucano = 'store_tucano';

const String _kReceiptDetail = 'receipt_linella_0312';
const String _kProductMilk = 'product_milk';

/// The record captured by `06_record_detail`. This MUST be an EXPENSE id, not
/// a receipt id: `RecordDetailBloc` resolves its `recordId` against
/// `IExpenseLocalRepository` only, so a receipt id silently resolves to no
/// record and the screen falls back to Home.
const String _kRecordDetail = 'exp_c01';

/// The 12 built-in category ids seeded by `SeedCategoriesUseCase` — the id IS
/// the i18n key for built-ins, so referencing them here keeps every seeded
/// expense resolvable to a real, localized category name.
const String _catFood = 'catFood';
const String _catTransport = 'catTransport';
const String _catHousehold = 'catHousehold';
const String _catRestaurants = 'catRestaurantsCoffee';
const String _catHealth = 'catHealth';
const String _catShopping = 'catShopping';
const String _catEntertainment = 'catEntertainment';
const String _catUtilities = 'catUtilities';

const String _kCurrency = 'MDL';

/// Anchors every seeded date to the DEVICE's current month.
///
/// This deliberately tracks the wall clock instead of a fixed literal. Home
/// and Analytics both scope to "this month" against `DateTime.now()`, so a
/// hard-coded anchor puts every seeded expense outside the visible window and
/// captures a `0 MDL` hero over a "No expenses yet" chart — which is exactly
/// the empty screenshot this seed exists to prevent. Only the day-of-month and
/// time are pinned, so the layout stays stable run to run.
final DateTime _kNow = () {
  final DateTime now = DateTime.now();
  return DateTime(now.year, now.month, 12, 18, 30);
}();

DateTime _daysAgo(int days) => _kNow.subtract(Duration(days: days));

// ───────────────────────────── pump helpers ─────────────────────────────

/// Default settle. Tolerates `pumpAndSettle`'s timeout, which a screen with a
/// continuous animation will always hit.
Future<void> _settle(WidgetTester tester) async {
  for (int i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 250));
  }
  try {
    await tester.pumpAndSettle(const Duration(seconds: 2));
  } catch (e) {
    debugPrint('_settle pumpAndSettle ignored: $e');
  }
}

/// Bounded live-pump. Advances pumped time by `frames * each` and returns —
/// it cannot hang, which is what makes it safe after a shell→root navigation
/// that tears down all five branches in one frame.
Future<void> _settleLive(
  WidgetTester tester, {
  int frames = 14,
  Duration each = const Duration(milliseconds: 250),
}) async {
  for (int i = 0; i < frames; i++) {
    await tester.pump(each);
  }
}

Future<void> _capture(
  IntegrationTestWidgetsFlutterBinding binding,
  WidgetTester tester,
  String name, {
  bool live = false,
}) async {
  try {
    if (live) {
      await _settleLive(tester);
    } else {
      await _settle(tester);
    }
    await binding.takeScreenshot(name);
    debugPrint('captured: $name');
  } catch (e, st) {
    debugPrint('CAPTURE FAILED: $name -> $e\n$st');
    _failedCaptures.add(name);
  }
}

/// Capture behind a hard outer timeout so one hung surface conversion cannot
/// drag the whole run past the driver's heartbeat.
Future<void> _captureWithTimeout(
  IntegrationTestWidgetsFlutterBinding binding,
  WidgetTester tester,
  String name, {
  bool live = false,
  Duration timeout = const Duration(seconds: 20),
}) async {
  try {
    await _capture(binding, tester, name, live: live).timeout(timeout);
  } on TimeoutException catch (e) {
    debugPrint('CAPTURE TIMED OUT: $name -> $e');
    _failedCaptures.add(name);
  }
}

/// The only navigation primitive in this test. `live: true` selects the
/// bounded pump and is mandatory for every hop that leaves the shell, every
/// root→root hop after that, and any destination mounting a chart animation.
Future<void> _safeGo(
  WidgetTester tester,
  String path, {
  bool live = false,
}) async {
  final ctx = rootNavigatorKey.currentContext;
  if (ctx == null) {
    debugPrint('safeGo: rootNavigatorKey.currentContext is null for $path');
    return;
  }
  try {
    GoRouter.of(ctx).go(path);
  } catch (e) {
    debugPrint('safeGo: GoRouter.go($path) failed: $e');
  }
  if (live) {
    await _settleLive(tester);
  } else {
    await _settle(tester);
  }
}

/// Types realistic content into the Cash-expense form.
///
/// Finds by widget type rather than by hint string: both inputs are plain
/// `TextField`s and the note's hint comes from `lo.optional`, so a
/// hint-string finder would couple this test to a localization value. They
/// are the only two TextFields on the screen and appear in visual order —
/// amount, then note.
Future<void> _fillCashExpenseForm(WidgetTester tester) async {
  try {
    final Finder fields = find.byType(TextField);
    final int count = fields.evaluate().length;
    if (count == 0) {
      debugPrint('_fillCashExpenseForm: no TextField found');
      return;
    }
    await tester.enterText(fields.at(0), '248.60');
    await tester.pump(const Duration(milliseconds: 200));
    if (count > 1) {
      await tester.enterText(fields.at(1), 'Farmers market — vegetables');
      await tester.pump(const Duration(milliseconds: 200));
    }
    // Dismiss the soft keyboard so it does not cover the Save button.
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await _settleLive(tester, frames: 6);
  } catch (e) {
    debugPrint('_fillCashExpenseForm failed: $e');
  }
}

Future<void> _waitForRootContext(WidgetTester tester) async {
  for (int i = 0; i < 40; i++) {
    if (rootNavigatorKey.currentContext != null) return;
    await tester.pump(const Duration(milliseconds: 200));
  }
  debugPrint('_waitForRootContext: rootNavigatorKey never attached');
}

// ─────────────────────────────── seeding ────────────────────────────────

/// Flips the app into its captured presentation state.
///
/// `onboardingCompleted: true` is what routes past `/onboarding` —
/// `resolveRedirect` keys on exactly that field, and `SettingsBloc.watch()`
/// pushes the change through `GoRouterRefreshListenable`, so writing it here
/// (after boot) re-drives the redirect to `/home` without touching lib/.
///
/// `dataCleared` stays FALSE: the category-seed guard is
/// `isEmpty && !dataCleared`, so a true value would leave the app with no
/// categories and every seeded expense unresolvable
/// (~/.claude/rules/delete_all_records_rules.md).
Future<void> _seedSettings() async {
  final settingsRepository = getIt<ISettingsLocalRepository>();
  final current = await settingsRepository.get();
  await settingsRepository.save(
    current.copyWith(
      localeCode: 'en',
      currencyCode: _kCurrency,
      themeMode: EAppThemeMode.dark,
      onboardingCompleted: true,
      dataCleared: false,
    ),
  );
}

Future<void> _seedStores() async {
  final storeRepository = getIt<IStoreLocalRepository>();
  final stores = <Store>[
    Store(
      id: _kStoreLinella,
      name: 'Linella',
      receiptAliases: const <String>['LINELLA SRL'],
      type: EStoreType.supermarket,
      updatedAt: _daysAgo(1),
    ),
    Store(
      id: _kStoreNr1,
      name: 'Nr.1 Green Hills',
      receiptAliases: const <String>['NR1 SRL'],
      type: EStoreType.supermarket,
      updatedAt: _daysAgo(3),
    ),
    Store(
      id: _kStoreKaufland,
      name: 'Kaufland Ciocana',
      type: EStoreType.supermarket,
      updatedAt: _daysAgo(6),
    ),
    Store(
      id: _kStoreFarmacia,
      name: 'Farmacia Familiei',
      type: EStoreType.pharmacy,
      updatedAt: _daysAgo(9),
    ),
    Store(
      id: _kStoreTucano,
      name: 'Tucano Coffee',
      type: EStoreType.cafe,
      updatedAt: _daysAgo(2),
    ),
  ];
  for (final store in stores) {
    await storeRepository.save(store);
  }
}

Future<void> _seedProducts() async {
  final productRepository = getIt<IProductLocalRepository>();
  final products = <Product>[
    Product(
      id: _kProductMilk,
      normalizedName: 'milk 2.5% 1l',
      displayName: 'Milk 2.5% 1 L',
      aliases: const <String>['LAPTE 2.5%'],
      defaultCategoryId: _catFood,
      defaultUnit: EUnit.liter,
      updatedAt: _daysAgo(1),
    ),
    Product(
      id: 'product_bread',
      normalizedName: 'bread rye 500g',
      displayName: 'Rye Bread 500 g',
      defaultCategoryId: _catFood,
      updatedAt: _daysAgo(1),
    ),
    Product(
      id: 'product_eggs',
      normalizedName: 'eggs 10pc',
      displayName: 'Eggs, 10 pcs',
      defaultCategoryId: _catFood,
      updatedAt: _daysAgo(3),
    ),
    Product(
      id: 'product_chicken',
      normalizedName: 'chicken breast',
      displayName: 'Chicken Breast',
      defaultCategoryId: _catFood,
      defaultUnit: EUnit.kilogram,
      updatedAt: _daysAgo(3),
    ),
    Product(
      id: 'product_coffee',
      normalizedName: 'coffee beans 250g',
      displayName: 'Coffee Beans 250 g',
      defaultCategoryId: _catFood,
      updatedAt: _daysAgo(6),
    ),
  ];
  for (final product in products) {
    await productRepository.save(product);
  }
}

/// One fully-populated receipt with six line items, so Record detail renders
/// a real itemised body rather than an empty list.
Future<void> _seedReceipt() async {
  final receiptRepository = getIt<IReceiptLocalRepository>();
  final itemRepository = getIt<IReceiptItemLocalRepository>();

  final items = <ReceiptItem>[
    ReceiptItem(
      id: 'item_milk',
      rawName: 'LAPTE 2.5% 1L',
      normalizedName: 'Milk 2.5% 1 L',
      productId: _kProductMilk,
      quantity: 2,
      unit: EUnit.liter,
      unitPrice: 18.50,
      lineTotal: 37.00,
      confidence: 0.97,
      lineIndex: 0,
      updatedAt: _daysAgo(1),
    ),
    ReceiptItem(
      id: 'item_bread',
      rawName: 'PAINE SECARA 500G',
      normalizedName: 'Rye Bread 500 g',
      productId: 'product_bread',
      quantity: 1,
      unitPrice: 14.20,
      lineTotal: 14.20,
      confidence: 0.94,
      lineIndex: 1,
      updatedAt: _daysAgo(1),
    ),
    ReceiptItem(
      id: 'item_eggs',
      rawName: 'OUA 10 BUC',
      normalizedName: 'Eggs, 10 pcs',
      productId: 'product_eggs',
      quantity: 1,
      unitPrice: 32.90,
      lineTotal: 32.90,
      confidence: 0.96,
      lineIndex: 2,
      updatedAt: _daysAgo(1),
    ),
    ReceiptItem(
      id: 'item_chicken',
      rawName: 'PIEPT PUI KG',
      normalizedName: 'Chicken Breast',
      productId: 'product_chicken',
      quantity: 0.86,
      unit: EUnit.kilogram,
      unitPrice: 94.50,
      lineTotal: 81.27,
      confidence: 0.91,
      lineIndex: 3,
      updatedAt: _daysAgo(1),
    ),
    ReceiptItem(
      id: 'item_coffee',
      rawName: 'CAFEA BOABE 250G',
      normalizedName: 'Coffee Beans 250 g',
      productId: 'product_coffee',
      quantity: 1,
      unitPrice: 129.00,
      lineTotal: 129.00,
      confidence: 0.89,
      lineIndex: 4,
      updatedAt: _daysAgo(1),
    ),
    ReceiptItem(
      id: 'item_apples',
      rawName: 'MERE GOLDEN KG',
      normalizedName: 'Golden Apples',
      quantity: 1.24,
      unit: EUnit.kilogram,
      unitPrice: 24.90,
      lineTotal: 30.88,
      confidence: 0.88,
      lineIndex: 5,
      updatedAt: _daysAgo(1),
    ),
  ];

  for (final item in items) {
    await itemRepository.save(item);
  }

  final itemsTotal = items.fold<double>(
    0,
    (double sum, ReceiptItem item) => sum + item.lineTotal,
  );

  await receiptRepository.save(
    Receipt(
      id: _kReceiptDetail,
      storeId: _kStoreLinella,
      purchasedAt: _daysAgo(1),
      printedTotal: itemsTotal,
      itemsTotal: itemsTotal,
      currencyCode: _kCurrency,
      categoryId: _catFood,
      itemIds: items.map((ReceiptItem item) => item.id).toList(),
      isReconciled: true,
      updatedAt: _daysAgo(1),
    ),
  );
}

/// Expenses across the current and previous month.
///
/// The current month deliberately totals MORE than the previous one, so the
/// Home hero renders the RISING trend in amber (`scheme.trendUp`) — the app's
/// contract is amber when spending rose, green when it fell, never red.
Future<void> _seedExpenses() async {
  final expenseRepository = getIt<IExpenseLocalRepository>();

  final expenses = <Expense>[
    // ── current month (March) ──
    _expense(
      'exp_c01',
      325.25,
      _catFood,
      _kStoreLinella,
      'Weekly grocery run — milk, bread, eggs, chicken and coffee',
      1,
    ),
    _expense('exp_c02', 89.00, _catRestaurants, _kStoreTucano, 'Flat white x2', 2),
    _expense('exp_c03', 412.60, _catFood, _kStoreNr1, 'Groceries', 3),
    _expense('exp_c04', 150.00, _catTransport, null, 'Fuel', 4),
    _expense('exp_c05', 268.40, _catHousehold, _kStoreKaufland, 'Cleaning supplies', 6),
    _expense('exp_c06', 195.00, _catHealth, _kStoreFarmacia, 'Vitamins', 9),
    _expense('exp_c07', 640.00, _catUtilities, null, 'Electricity', 10),
    _expense('exp_c08', 249.99, _catShopping, null, 'Running shoes', 11),
    _expense('exp_c09', 120.00, _catEntertainment, null, 'Cinema tickets', 5),
    _expense('exp_c10', 76.50, _catRestaurants, _kStoreTucano, 'Lunch', 7),
    // ── previous month (February) — a lower total, so the trend rises ──
    _expense('exp_p01', 298.00, _catFood, _kStoreLinella, 'Groceries', 34),
    _expense('exp_p02', 132.00, _catTransport, null, 'Bus pass', 37),
    _expense('exp_p03', 210.00, _catHousehold, _kStoreKaufland, 'Detergent', 40),
    _expense('exp_p04', 480.00, _catUtilities, null, 'Heating', 42),
    _expense('exp_p05', 64.00, _catRestaurants, _kStoreTucano, 'Cappuccino', 45),
  ];

  for (final expense in expenses) {
    await expenseRepository.save(expense);
  }
}

Expense _expense(
  String id,
  double amount,
  String categoryId,
  String? storeId,
  String note,
  int daysAgo,
) {
  final DateTime occurredAt = _daysAgo(daysAgo);
  return Expense(
    id: id,
    amount: amount,
    currencyCode: _kCurrency,
    categoryId: categoryId,
    storeId: storeId,
    note: note,
    occurredAt: occurredAt,
    source: EExpenseSource.cash,
    updatedAt: occurredAt,
  );
}

/// Eight observations of one product's unit price across four months and
/// three stores — enough that the Price history chart draws SOLID bars for
/// real periods rather than the border-only empty stubs.
Future<void> _seedPriceObservations() async {
  final observationRepository = getIt<IPriceObservationLocalRepository>();

  const List<double> prices = <double>[
    16.40,
    16.90,
    17.20,
    17.20,
    17.80,
    18.10,
    18.30,
    18.50,
  ];
  const List<String> stores = <String>[
    _kStoreLinella,
    _kStoreNr1,
    _kStoreKaufland,
    _kStoreLinella,
    _kStoreNr1,
    _kStoreLinella,
    _kStoreKaufland,
    _kStoreLinella,
  ];

  for (int i = 0; i < prices.length; i++) {
    final DateTime observedAt = _daysAgo(110 - (i * 15));
    await observationRepository.save(
      PriceObservation(
        id: 'obs_milk_$i',
        productId: _kProductMilk,
        storeId: stores[i],
        receiptId: _kReceiptDetail,
        observedAt: observedAt,
        comparableUnitPrice: prices[i],
        unit: EUnit.liter,
        currencyCode: _kCurrency,
        updatedAt: observedAt,
      ),
    );
  }
}

Future<void> _seedAll() async {
  await _seedSettings();
  await _seedStores();
  await _seedProducts();
  await _seedReceipt();
  await _seedExpenses();
  await _seedPriceObservations();
}

void main() {
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // onlyPumps: the app does not animate on its own, so tester.pump is the sole
  // clock. This is what keeps _settleLive bounded and lets pumpAndSettle reach
  // a steady state on the screens that can.
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.onlyPumps;

  testWidgets('spend_lens screenshots', (WidgetTester tester) async {
    // app.main() owns the single initHive() call — it registers every model
    // and enum adapter, and the registry throws on a duplicate typeId, so the
    // test must never initialize Hive itself.
    app.main();
    await tester.pump(const Duration(seconds: 2));
    await _settle(tester);

    // Seeded AFTER boot: every repository reads through box.watch(), and each
    // page-scoped bloc is constructed fresh on navigation, so the data lands
    // before any screen that displays it is mounted.
    await _seedAll();
    await _settleLive(tester, frames: 12);

    await _waitForRootContext(tester);
    await _settleLive(tester, frames: 16);

    // ONE-SHOT, and it must happen exactly once for the whole run: on both
    // iOS and Android `convertFlutterSurfaceToImage` asserts
    // `!_isSurfaceRendered`, so calling it per-capture throws
    // "Surface already converted to an image" on every screenshot after the
    // first. Hoisted here — after the tree is mounted, before any capture.
    await binding.convertFlutterSurfaceToImage();
    await _settleLive(tester, frames: 4);

    // ── shell branches: all five visited before the first shell→root hop ──
    await _safeGo(tester, '/home');
    await _captureWithTimeout(binding, tester, '01_home');

    await _safeGo(tester, '/analytics');
    await _captureWithTimeout(binding, tester, '02_analytics');

    await _safeGo(tester, '/stores');
    await _captureWithTimeout(binding, tester, '03_stores');

    await _safeGo(tester, '/history');
    await _captureWithTimeout(binding, tester, '04_history');

    // Settings is a shell branch, so it is VISITED to keep the "every branch
    // before the first shell→root hop" ordering — but never captured
    // (excluded: repeatable toggles, no product information).
    await _safeGo(tester, '/settings');

    // ── every hop below leaves the shell: live: true is mandatory ──
    await _safeGo(tester, '/store/$_kStoreLinella', live: true);
    await _settleLive(tester, frames: 14);
    await _captureWithTimeout(binding, tester, '05_store_detail', live: true);

    await _safeGo(tester, '/record/$_kRecordDetail', live: true);
    await _settleLive(tester, frames: 14);
    await _captureWithTimeout(binding, tester, '06_record_detail', live: true);

    await _safeGo(tester, '/price-history/$_kProductMilk', live: true);
    await _settleLive(tester, frames: 16);
    await _captureWithTimeout(binding, tester, '07_price_history', live: true);

    await _safeGo(tester, '/categories', live: true);
    await _settleLive(tester, frames: 12);
    await _captureWithTimeout(binding, tester, '08_categories', live: true);

    await _safeGo(tester, '/cash-expense', live: true);
    await _settleLive(tester, frames: 12);
    // An empty Amount / Note reads as a broken UI in a store screenshot, so
    // the form is filled before the capture. The two fields are the only
    // TextFields on this screen, in visual order: amount first, note second.
    await _fillCashExpenseForm(tester);
    await _captureWithTimeout(binding, tester, '09_cash_expense', live: true);

    // Navigate back to a static shell branch so the last screen's bloc is
    // disposed before teardown.
    await _safeGo(tester, '/home', live: true);
    await _settleLive(tester, frames: 8);

    expect(
      _failedCaptures,
      isEmpty,
      reason: 'These screenshots failed: $_failedCaptures',
    );
  });
}
