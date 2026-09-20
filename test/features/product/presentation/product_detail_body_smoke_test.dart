import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/resources/colors/app_color_scheme.dart';
import 'package:spend_lens/core/resources/localization/gen/app_localizations.dart';
import 'package:spend_lens/core/resources/text/app_text_theme.dart';
import 'package:spend_lens/features/analytics/domain/models/price_observation/price_observation.dart';
import 'package:spend_lens/features/product/domain/models/product/product.dart';
import 'package:spend_lens/features/product/domain/models/product_detail_snapshot/product_detail_snapshot.dart';
import 'package:spend_lens/features/product/presentation/pages/product_detail_page/widgets/product_detail_body.dart';
import 'package:spend_lens/features/store/domain/models/store/store.dart';

/// REGRESSION: this screen embeds a `CustomPaint` chart inside a
/// `SingleChildScrollView`, which is the exact shape that took the Store
/// Detail screen down with "BoxConstraints forces an infinite height" — an
/// unbounded cross axis that `flutter analyze` cannot see.
///
/// It also pins the states a product page must survive: NO prices (a
/// hand-created product starts there and must still offer "+ Add price"),
/// ONE price (nothing to chart yet), and many prices across months.
void main() {
  final now = DateTime(2026, 9, 19);

  Product product({
    String id = 'product-1',
    String? storeId = 'store-1',
    List<String> linked = const [],
  }) => Product(
    id: id,
    normalizedName: 'milk',
    displayName: 'Milk 2.5% 1L',
    storeId: storeId,
    linkedProductIds: linked,
    updatedAt: now,
  );

  PriceObservation observation({
    required String id,
    required DateTime observedAt,
    double price = 14.58,
    String? receiptId,
    String productId = 'product-1',
  }) => PriceObservation(
    id: id,
    productId: productId,
    storeId: 'store-1',
    receiptId: receiptId,
    observedAt: observedAt,
    comparableUnitPrice: price,
    currencyCode: 'MDL',
    updatedAt: now,
  );

  final stores = [
    Store(id: 'store-1', name: 'Fidesco Putnei 28', updatedAt: now),
    Store(id: 'store-2', name: 'Nr.1', updatedAt: now),
  ];

  Future<void> pump(WidgetTester tester, ProductDetailSnapshot snapshot) {
    return tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          extensions: [AppColorScheme.dark(), AppTextTheme.base()],
        ),
        home: Scaffold(
          body: ProductDetailBody(
            snapshot: snapshot,
            onAddPrice: () {},
            onEditPrice: (_) {},
            onOpenReceipt: (_) {},
            onDeletePrice: (_) {},
            onDelete: () {},
            onEdit: () {},
            onOpenFullHistory: () {},
          ),
        ),
      ),
    );
  }

  testWidgets('renders with NO prices — the hand-created case', (
    tester,
  ) async {
    await pump(
      tester,
      ProductDetailSnapshot(
        product: product(),
        allProducts: [product()],
        observations: const [],
        stores: stores,
      ),
    );

    expect(tester.takeException(), isNull);
    // The only way to give a priceless product a price must stay reachable.
    expect(find.text('Add price'), findsOneWidget);
  });

  testWidgets('renders with a single price — nothing to chart yet', (
    tester,
  ) async {
    await pump(
      tester,
      ProductDetailSnapshot(
        product: product(),
        allProducts: [product()],
        observations: [
          observation(id: '1', observedAt: DateTime(2026, 9, 1)),
        ],
        stores: stores,
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('renders a multi-month history with the chart', (tester) async {
    await pump(
      tester,
      ProductDetailSnapshot(
        product: product(),
        allProducts: [product()],
        observations: [
          observation(
            id: '1',
            observedAt: DateTime(2026, 6, 1),
            price: 11.00,
            receiptId: 'receipt-1',
          ),
          observation(id: '2', observedAt: DateTime(2026, 7, 1), price: 12.50),
          observation(id: '3', observedAt: DateTime(2026, 9, 1), price: 14.58),
        ],
        stores: stores,
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('renders a general-purpose product with no store', (
    tester,
  ) async {
    await pump(
      tester,
      ProductDetailSnapshot(
        product: product(storeId: null),
        allProducts: [product(storeId: null)],
        observations: [
          observation(id: '1', observedAt: DateTime(2026, 9, 1)),
        ],
        stores: stores,
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('shows ONLY the owning store prices, never another shop', (
    tester,
  ) async {
    // REGRESSION: the page listed every observation for the product
    // regardless of where it was seen, so a product opened from one store
    // showed another shop's prices — and fed the same mixture to the
    // inflation chart, where a rise could be nothing but a switch of shops.
    await pump(
      tester,
      ProductDetailSnapshot(
        product: product(storeId: 'store-1'),
        allProducts: [product(storeId: 'store-1')],
        observations: [
          observation(id: 'here', observedAt: DateTime(2026, 9, 1), price: 23.45),
          observation(
            id: 'elsewhere',
            observedAt: DateTime(2026, 9, 2),
            price: 8.00,
          ).copyWith(storeId: 'store-2'),
        ],
        stores: stores,
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.textContaining('23.45'), findsOneWidget);
    expect(
      find.textContaining('8.00'),
      findsNothing,
      reason: "store-2's price must not appear on a store-1 product",
    );
  });

  testWidgets('a store-less price still shows on its own product', (
    tester,
  ) async {
    // A price typed on this page without naming a shop belongs to this page
    // — dropping it would mean entering a price and watching it vanish.
    await pump(
      tester,
      ProductDetailSnapshot(
        product: product(storeId: 'store-1'),
        allProducts: [product(storeId: 'store-1')],
        observations: [
          observation(
            id: 'manual',
            observedAt: DateTime(2026, 9, 1),
            price: 5.25,
          ).copyWith(storeId: null),
        ],
        stores: stores,
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.textContaining('5.25'), findsOneWidget);
  });
}
