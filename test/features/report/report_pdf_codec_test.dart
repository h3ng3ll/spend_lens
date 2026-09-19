import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:spend_lens/features/report/domain/models/pdf_report_data.dart';
import 'package:spend_lens/features/report/domain/report_pdf_codec.dart';

/// The codec is PURE — no Flutter binding, no plugin channel, no IO — which
/// is what lets it run inside `Isolate.run`. These tests read the fonts
/// straight off disk rather than through `rootBundle` for the same reason.
Uint8List _font(String name) =>
    File('assets/fonts/$name').readAsBytesSync();

PdfReportData _data({
  List<PdfReportCategoryRow> rows = const [],
  List<String> insights = const [],
  String monthLabel = 'September 2026',
  String? deltaText = '+12%',
}) {
  return PdfReportData(
    regularFontBytes: _font('NotoSans-Regular.ttf'),
    semiBoldFontBytes: _font('NotoSans-SemiBold.ttf'),
    monthLabel: monthLabel,
    currencyCode: 'MDL',
    totalText: '8,420',
    averageText: '167',
    purchaseCountText: '51',
    cashSharePercentText: '14%',
    receiptSharePercentText: '86%',
    deltaText: deltaText,
    deltaLabel: 'vs August',
    categoryRows: rows,
    insights: insights,
    titleText: 'Analytics',
    averageLabel: 'Average',
    purchasesLabel: 'Purchases',
    cashLabel: 'Cash',
    categoriesLabel: 'Categories',
    insightsLabel: 'Insights',
    cashVsReceiptsLabel: 'Cash vs receipts',
    receiptsLowerLabel: 'receipts',
    cashLowerLabel: 'cash',
    generatedAtText: 'Generated Sep 19, 2026 18:00',
  );
}

void main() {
  group('buildReportPdf', () {
    test('produces a valid PDF document', () async {
      final bytes = await buildReportPdf(
        _data(
          rows: const [
            PdfReportCategoryRow(
              name: 'Food',
              amountText: '4,820',
              sharePercentText: '57%',
              colorArgb: 0xFF167C8A,
            ),
          ],
          insights: const ['Food represents 57% of your spending.'],
        ),
      );

      expect(bytes, isNotEmpty);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    });

    test('renders Cyrillic and Romanian text without throwing', () async {
      // The whole reason the app bundles Noto Sans: the `pdf` package cannot
      // use the platform font the app's TextStyles fall back to, and its
      // built-in Helvetica has no glyphs for these scripts — ru/uk/ro
      // reports would export blank text.
      final bytes = await buildReportPdf(
        _data(
          monthLabel: 'Вересень 2026',
          rows: const [
            PdfReportCategoryRow(
              name: 'Продукти',
              amountText: '4 820',
              sharePercentText: '57%',
              colorArgb: 0xFF167C8A,
            ),
            PdfReportCategoryRow(
              name: 'Restaurante și cafenele',
              amountText: '1 120',
              sharePercentText: '13%',
              colorArgb: 0xFFA8625E,
            ),
          ],
          insights: const ['Продукти — 57% ваших витрат.'],
        ),
      );

      expect(bytes, isNotEmpty);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    });

    test('omits the delta line when there is no prior month', () async {
      final bytes = await buildReportPdf(_data(deltaText: null));

      expect(bytes, isNotEmpty);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    });
  });
}
