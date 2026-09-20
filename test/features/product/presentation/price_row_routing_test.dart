import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/resources/colors/app_color_scheme.dart';
import 'package:spend_lens/core/resources/localization/gen/app_localizations.dart';
import 'package:spend_lens/core/resources/text/app_text_theme.dart';
import 'package:spend_lens/features/analytics/domain/models/price_observation/price_observation.dart';
import 'package:spend_lens/features/product/presentation/pages/product_detail_page/widgets/product_price_row.dart';

/// REGRESSION: a receipt-derived price row was INERT — `onTap: isManual ?
/// onEdit : null` — so the only prices most users have could not be opened
/// at all, and there was no route from a wrong price to the thing that
/// defines it.
///
/// A price is only editable where it is DEFINED. A scanned one is rebuilt
/// from its receipt by `RecordPriceObservationsUseCase` on every correction
/// save, so it must open the RECEIPT (durable); a hand-entered one has no
/// receipt and opens the price editor (the only kind that is also
/// deletable).
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
    WidgetTester tester,
    PriceObservation value, {
    required VoidCallback onEdit,
    required VoidCallback onOpenReceipt,
    required VoidCallback onDelete,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          extensions: [AppColorScheme.dark(), AppTextTheme.base()],
        ),
        home: Scaffold(
          body: ProductPriceRow(
            observation: value,
            storeName: 'Fidesco',
            onEdit: onEdit,
            onOpenReceipt: onOpenReceipt,
            onDelete: onDelete,
            showBottomDivider: false,
          ),
        ),
      ),
    );
  }

  testWidgets('a receipt price opens its RECEIPT, not the price editor', (
    tester,
  ) async {
    var edited = false;
    var openedReceipt = false;

    await pump(
      tester,
      observation(receiptId: 'receipt-1'),
      onEdit: () => edited = true,
      onOpenReceipt: () => openedReceipt = true,
      onDelete: () {},
    );

    await tester.tap(find.byType(ProductPriceRow));
    await tester.pump();

    expect(openedReceipt, isTrue);
    expect(
      edited,
      isFalse,
      reason: 'editing it here would be overwritten on the next receipt save',
    );
  });

  testWidgets('a manual price opens the price editor', (tester) async {
    var edited = false;
    var openedReceipt = false;

    await pump(
      tester,
      observation(),
      onEdit: () => edited = true,
      onOpenReceipt: () => openedReceipt = true,
      onDelete: () {},
    );

    await tester.tap(find.byType(ProductPriceRow));
    await tester.pump();

    expect(edited, isTrue);
    expect(openedReceipt, isFalse);
  });

  testWidgets('a receipt price row is never inert', (tester) async {
    var tapped = false;

    await pump(
      tester,
      observation(receiptId: 'receipt-1'),
      onEdit: () {},
      onOpenReceipt: () => tapped = true,
      onDelete: () {},
    );

    await tester.tap(find.byType(ProductPriceRow));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('only a manual price offers delete', (tester) async {
    await pump(
      tester,
      observation(receiptId: 'receipt-1'),
      onEdit: () {},
      onOpenReceipt: () {},
      onDelete: () {},
    );

    expect(tester.takeException(), isNull);
    expect(find.textContaining('From receipt'), findsOneWidget);
  });
}
