import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/resources/colors/app_color_scheme.dart';
import 'package:spend_lens/core/resources/localization/gen/app_localizations.dart';
import 'package:spend_lens/core/resources/text/app_text_theme.dart';
import 'package:spend_lens/features/analytics/domain/models/price_observation/price_observation.dart';
import 'package:spend_lens/features/product/presentation/pages/product_detail_page/widgets/product_price_row.dart';

/// The price row leads with the STORE, not the date.
///
/// It used to put the date on the primary line and push the store into the
/// grey subtitle, sharing that line with `· from receipt`. A real store name
/// is long — `KAUFLAND ...` — so the subtitle had to wrap or ellipsize while
/// the date above it, always ten characters, sat on a half-empty row.
///
/// Every row in this list prices the SAME product, so the store is what
/// distinguishes one row from the next. It belongs on the line that is read
/// first and given the most room.
void main() {
  final now = DateTime(2026, 9, 19);

  PriceObservation observation({String? receiptId}) => PriceObservation(
    id: 'o1',
    productId: 'p1',
    storeId: 'store-1',
    receiptId: receiptId,
    observedAt: now,
    comparableUnitPrice: 23.45,
    currencyCode: 'MDL',
    updatedAt: now,
  );

  Future<void> pump(
    WidgetTester tester, {
    required String storeName,
    String? receiptId,
  }) {
    // A narrow phone: the width at which the old layout actually broke.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    return tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          extensions: [AppColorScheme.dark(), AppTextTheme.base()],
        ),
        home: Scaffold(
          body: ProductPriceRow(
            observation: observation(receiptId: receiptId),
            storeName: storeName,
            onEdit: () {},
            onOpenReceipt: () {},
            onDelete: () {},
            showBottomDivider: false,
          ),
        ),
      ),
    );
  }

  testWidgets('the store name is the FIRST line', (tester) async {
    await pump(tester, storeName: 'Fidesco');
    await tester.pumpAndSettle();

    final store = tester.getTopLeft(find.text('Fidesco'));
    final date = tester.getTopLeft(find.textContaining('19.09.2026'));

    expect(
      store.dy,
      lessThan(date.dy),
      reason: 'THE BUG: the date led and the store was the grey subtitle',
    );
    // Both start at the same left edge — the date sits UNDER the name.
    expect(store.dx, date.dx);
  });

  testWidgets('a long store name stays on one line', (tester) async {
    const long = 'KAUFLAND SRL MAGAZINUL NR 12 CHISINAU';

    await pump(tester, storeName: long);
    await tester.pumpAndSettle();

    final widget = tester.widget<Text>(find.text(long));
    expect(
      widget.maxLines,
      1,
      reason: 'a wrapping store name is what made these rows ragged',
    );
    expect(widget.overflow, TextOverflow.ellipsis);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the price stays on the right, unabbreviated', (tester) async {
    await pump(tester, storeName: 'Fidesco');
    await tester.pumpAndSettle();

    final price = find.text('23.45 MDL');
    expect(price, findsOneWidget);

    // Right of the store name: the value the row exists to report is never
    // the thing that gets squeezed.
    expect(
      tester.getTopLeft(price).dx,
      greaterThan(tester.getTopLeft(find.text('Fidesco')).dx),
    );
  });

  testWidgets('a receipt price marks its origin on the date line', (
    tester,
  ) async {
    await pump(tester, storeName: 'Fidesco', receiptId: 'r1');
    await tester.pumpAndSettle();

    // `· from receipt` moved to the date line with the date; the store name
    // must be left alone so it is not competing for that width again.
    expect(find.text('Fidesco'), findsOneWidget);
    expect(find.textContaining('19.09.2026'), findsOneWidget);
  });

  testWidgets('a manual price shows the date with no origin note', (
    tester,
  ) async {
    await pump(tester, storeName: 'Fidesco');
    await tester.pumpAndSettle();

    expect(find.text('19.09.2026'), findsOneWidget);
  });
}
