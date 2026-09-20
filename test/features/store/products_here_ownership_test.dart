import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/resources/colors/app_color_scheme.dart';
import 'package:spend_lens/core/resources/localization/gen/app_localizations.dart';
import 'package:spend_lens/core/resources/text/app_text_theme.dart';
import 'package:spend_lens/features/analytics/domain/models/price_observation/price_observation.dart';
import 'package:spend_lens/features/product/domain/models/product/product.dart';
import 'package:spend_lens/features/store/domain/models/store/store.dart';
import 'package:spend_lens/features/store/presentation/pages/store_detail_page/widgets/products_here_card.dart';

/// REGRESSION: "Products bought here" listed products by where their PRICES
/// were observed rather than by which store OWNS them. One store-less
/// product bought at two shops therefore appeared under BOTH of them, which
/// contradicted the per-store model the identity card was simultaneously
/// claiming ("General purpose") and made the same goods look duplicated.
///
/// `Product.storeId` is now the single source of truth for membership.
void main() {
  final now = DateTime(2026, 9, 19);

  Product product({
    required String id,
    String? storeId,
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
    required String storeId,
  }) => PriceObservation(
    id: id,
    productId: productId,
    storeId: storeId,
    receiptId: 'receipt-$id',
    observedAt: now,
    comparableUnitPrice: 12.0,
    currencyCode: 'MDL',
    updatedAt: now,
  );

  final stores = [
    Store(id: 'store-1', name: 'Fidesco', updatedAt: now),
    Store(id: 'store-2', name: 'Kaufland', updatedAt: now),
  ];

  Future<void> pump(
    WidgetTester tester, {
    required String storeId,
    required List<Product> products,
    required List<PriceObservation> observations,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          extensions: [AppColorScheme.dark(), AppTextTheme.base()],
        ),
        home: Scaffold(
          body: SingleChildScrollView(
            child: ProductsHereCard(
              storeId: storeId,
              products: products,
              priceObservations: observations,
              stores: stores,
              onOpenProduct: (_) {},
              onAddProduct: () {},
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('lists a product under the store that OWNS it', (tester) async {
    await pump(
      tester,
      storeId: 'store-1',
      products: [product(id: 'p1', storeId: 'store-1')],
      observations: [
        observation(id: 'o1', productId: 'p1', storeId: 'store-1'),
      ],
    );

    expect(tester.takeException(), isNull);
    expect(find.text('CASUTA MEA'), findsOneWidget);
  });

  testWidgets('does NOT list it under a store it merely has a price at', (
    tester,
  ) async {
    await pump(
      tester,
      storeId: 'store-2',
      products: [product(id: 'p1', storeId: 'store-1')],
      // The price was seen at store-2, but the product belongs to store-1.
      observations: [
        observation(id: 'o1', productId: 'p1', storeId: 'store-2'),
      ],
    );

    expect(tester.takeException(), isNull);
    expect(
      find.text('CASUTA MEA'),
      findsNothing,
      reason: 'ownership decides membership, not where a price was seen',
    );
  });

  testWidgets('a general-purpose product belongs to no store list', (
    tester,
  ) async {
    await pump(
      tester,
      storeId: 'store-1',
      products: [product(id: 'p1')],
      observations: [
        observation(id: 'o1', productId: 'p1', storeId: 'store-1'),
      ],
    );

    expect(tester.takeException(), isNull);
    expect(find.text('CASUTA MEA'), findsNothing);
  });

  testWidgets('the create path stays reachable when the store is empty', (
    tester,
  ) async {
    await pump(
      tester,
      storeId: 'store-1',
      products: const [],
      observations: const [],
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Add product'), findsOneWidget);
  });

  testWidgets('two stores each show their own split product', (tester) async {
    final split = [
      product(id: 'p1', storeId: 'store-1'),
      product(id: 'p1_split_store-2', storeId: 'store-2'),
    ];

    await pump(
      tester,
      storeId: 'store-2',
      products: split,
      observations: [
        observation(id: 'o1', productId: 'p1', storeId: 'store-1'),
        observation(
          id: 'o2',
          productId: 'p1_split_store-2',
          storeId: 'store-2',
        ),
      ],
    );

    expect(tester.takeException(), isNull);
    expect(find.text('CASUTA MEA'), findsOneWidget);
  });
}
