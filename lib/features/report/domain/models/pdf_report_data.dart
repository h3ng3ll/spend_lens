import 'dart:typed_data';

/// One category row of the exported report's breakdown table.
///
/// Amounts and percentages arrive **pre-formatted**: the isolate that renders
/// the PDF has no `BuildContext`, no `AppLocalizations` and no access to the
/// user's locale, so every number is turned into its final display string on
/// the main isolate before it crosses the boundary.
class PdfReportCategoryRow {
  final String name;
  final String amountText;
  final String sharePercentText;

  /// `0xAARRGGBB`, already resolved from the category's stored hex on the
  /// main isolate — the isolate never touches `AppColorScheme`.
  final int colorArgb;

  const PdfReportCategoryRow({
    required this.name,
    required this.amountText,
    required this.sharePercentText,
    required this.colorArgb,
  });
}

/// Everything [buildReportPdf] needs, in **sendable form only**.
///
/// `Isolate.run` copies its closure's captured state to a fresh isolate, so
/// this payload may contain nothing that is context-, plugin- or
/// binding-bound: no `BuildContext`, no `AppLocalizations`, no `rootBundle`
/// handle, no `Directory`. Fonts arrive as raw bytes and every label arrives
/// as a finished string, which is what keeps the PDF layout itself a pure
/// CPU workload that can leave the UI thread.
class PdfReportData {
  final Uint8List regularFontBytes;
  final Uint8List semiBoldFontBytes;

  /// e.g. "September 2026" — also used for the success toast.
  final String monthLabel;
  final String currencyCode;

  final String totalText;
  final String averageText;
  final String purchaseCountText;
  final String cashSharePercentText;
  final String receiptSharePercentText;

  /// Signed change vs the previous month (e.g. "+12%"), or null when there
  /// is no prior month to compare against — never fabricated as "0%".
  final String? deltaText;
  final String? deltaLabel;

  final List<PdfReportCategoryRow> categoryRows;
  final List<String> insights;

  // Localized headings, resolved before the isolate hop.
  final String titleText;
  final String averageLabel;
  final String purchasesLabel;
  final String cashLabel;
  final String categoriesLabel;
  final String insightsLabel;
  final String cashVsReceiptsLabel;
  final String receiptsLowerLabel;
  final String cashLowerLabel;
  final String generatedAtText;

  const PdfReportData({
    required this.regularFontBytes,
    required this.semiBoldFontBytes,
    required this.monthLabel,
    required this.currencyCode,
    required this.totalText,
    required this.averageText,
    required this.purchaseCountText,
    required this.cashSharePercentText,
    required this.receiptSharePercentText,
    required this.deltaText,
    required this.deltaLabel,
    required this.categoryRows,
    required this.insights,
    required this.titleText,
    required this.averageLabel,
    required this.purchasesLabel,
    required this.cashLabel,
    required this.categoriesLabel,
    required this.insightsLabel,
    required this.cashVsReceiptsLabel,
    required this.receiptsLowerLabel,
    required this.cashLowerLabel,
    required this.generatedAtText,
  });
}
