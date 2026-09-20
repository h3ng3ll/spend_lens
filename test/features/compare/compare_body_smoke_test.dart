import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/resources/colors/app_color_scheme.dart';
import 'package:spend_lens/core/resources/localization/gen/app_localizations.dart';
import 'package:spend_lens/core/resources/text/app_text_theme.dart';
import 'package:spend_lens/features/analytics/domain/models/price_observation/price_observation.dart';
import 'package:spend_lens/features/compare/domain/models/compare_snapshot/compare_snapshot.dart';
import 'package:spend_lens/features/compare/presentation/pages/compare_page/widgets/compare_body.dart';
import 'package:spend_lens/features/compare/presentation/utils/compare_lists.dart';
import 'package:spend_lens/features/product/domain/models/product/product.dart';
import 'package:spend_lens/features/store/domain/models/store/store.dart';

/// REGRESSION: the Compare screen puts two independent product columns in a
/// `Row` inside a `SingleChildScrollView` — the same unbounded-cross-axis
/// shape that once took the Store Detail screen down with "BoxConstraints
/// forces an infinite height", which `flutter analyze` cannot see.
///
/// It also pins the states the screen must survive: no stores, one store,
/// and a store with no products — none of which is an error.
void main() {
  final now = DateTime(2026, 9, 19);

  Product product({
    required String id,
    required String? storeId,
    String displayName = 'CASUTA MEA',
  }) => Product(
    id: id,
    normalizedName: 'casuta mea',
    displayName: displayName,
    storeId: storeId,
    updatedAt: now,
  );

  PriceObservation observation({
    required String id,
    required String productId,
    required String? storeId,
    double price = 12.0,
  }) => PriceObservation(
    id: id,
    productId: productId,
    storeId: storeId,
    receiptId: 'receipt-$id',
    observedAt: now,
    comparableUnitPrice: price,
    currencyCode: 'MDL',
    updatedAt: now,
  );

  final stores = [
    Store(id: 'store-1', name: 'Fidesco', updatedAt: now),
    Store(id: 'store-2', name: 'Kaufland', updatedAt: now),
  ];

  Future<void> pump(WidgetTester tester, CompareSnapshot snapshot) {
    return tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          extensions: [AppColorScheme.dark(), AppTextTheme.base()],
        ),
        home: Scaffold(
          body: CompareBody(
            snapshot: snapshot,
            leftStoreId: snapshot.stores.isEmpty ? null : 'store-1',
            rightStoreId: snapshot.stores.length < 2 ? null : 'store-2',
            onPickLeft: () {},
            onPickRight: () {},
            onOpenProduct: (_) {},
          ),
        ),
      ),
    );
  }

  testWidgets('renders two columns of products side by side', (tester) async {
    await pump(
      tester,
      CompareSnapshot(
        stores: stores,
        products: [
          product(id: 'p1', storeId: 'store-1'),
          product(id: 'p2', storeId: 'store-2', displayName: 'PAN HACARON'),
        ],
        observations: [
          observation(id: 'o1', productId: 'p1', storeId: 'store-1', price: 23.45),
          observation(id: 'o2', productId: 'p2', storeId: 'store-2', price: 8.00),
        ],
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Fidesco'), findsOneWidget);
    expect(find.text('Kaufland'), findsOneWidget);
    expect(find.text('CASUTA MEA'), findsOneWidget);
    expect(find.text('PAN HACARON'), findsOneWidget);
  });

  testWidgets('asks for a second store rather than erroring', (tester) async {
    await pump(
      tester,
      CompareSnapshot(
        stores: [stores.first],
        products: const [],
        observations: const [],
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Add a second store'), findsOneWidget);
  });

  testWidgets('an empty store reports it without erroring', (tester) async {
    await pump(
      tester,
      CompareSnapshot(
        stores: stores,
        products: [product(id: 'p1', storeId: 'store-1')],
        observations: const [],
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('No products at this store yet.'), findsOneWidget);
  });

  testWidgets('a product with no price says so', (tester) async {
    await pump(
      tester,
      CompareSnapshot(
        stores: stores,
        products: [product(id: 'p1', storeId: 'store-1')],
        observations: const [],
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('No price yet'), findsOneWidget);
  });

  group('compare_lists', () {
    test('productsForStore lists by OWNERSHIP, not by observation', () {
      final products = [
        product(id: 'p1', storeId: 'store-1'),
        product(id: 'p2', storeId: 'store-2'),
        product(id: 'general', storeId: null),
      ];

      expect(
        productsForStore(products, 'store-1').map((p) => p.id),
        ['p1'],
      );
    });

    test('productsForStore returns nothing for a null store', () {
      expect(productsForStore([product(id: 'p1', storeId: null)], null), isEmpty);
    });

    test('latestPriceFor ignores another store price', () {
      final result = latestPriceFor(
        [observation(id: 'o1', productId: 'p1', storeId: 'store-2')],
        'p1',
        storeId: 'store-1',
      );

      expect(result, isNull);
    });

    test('latestPriceFor returns this store own price', () {
      final result = latestPriceFor(
        [
          observation(id: 'o1', productId: 'p1', storeId: 'store-1', price: 9.5),
        ],
        'p1',
        storeId: 'store-1',
      );

      expect(result?.comparableUnitPrice, 9.5);
    });
  });
}
