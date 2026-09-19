import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/resources/colors/app_colors.dart';
import 'models/pdf_report_data.dart';

/// Renders the Analytics month report to PDF bytes.
///
/// **Pure and isolate-safe** — no Flutter binding, no `BuildContext`, no
/// plugin channel and no file IO, so it is safe to invoke inside
/// `Isolate.run` (which is exactly how `ExportPdfReportUseCase` calls it) and
/// is directly unit-testable without a `TestWidgetsFlutterBinding`.
///
/// Colours are taken from the project's `AppColors` tokens rather than raw
/// literals, per the `no_raw_colors_test` contract. The report is a PRINTED
/// document, so it deliberately uses the LIGHT tokens (dark ink on white)
/// even when the app itself is running its dark theme — a dark-filled A4 page
/// is not what a user wants out of a printer or a share sheet.
Future<Uint8List> buildReportPdf(PdfReportData data) async {
  final regular = pw.Font.ttf(data.regularFontBytes.buffer.asByteData());
  final semiBold = pw.Font.ttf(data.semiBoldFontBytes.buffer.asByteData());

  final ink = _pdfColor(AppColors.inkLight);
  final sec = _pdfColor(AppColors.secLight);
  final ter = _pdfColor(AppColors.terLight);
  final line = _pdfColor(AppColors.dimLight);
  final accent = _pdfColor(AppColors.accentLight);

  final document = pw.Document(
    theme: pw.ThemeData.withFont(base: regular, bold: semiBold),
  );

  document.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(36.0, 40.0, 36.0, 40.0),
      footer: (context) => pw.Container(
        alignment: pw.Alignment.centerRight,
        margin: const pw.EdgeInsets.only(top: 12.0),
        child: pw.Text(
          '${context.pageNumber} / ${context.pagesCount}',
          style: pw.TextStyle(font: regular, fontSize: 9.0, color: ter),
        ),
      ),
      build: (context) => [
        _header(data, semiBold: semiBold, regular: regular, ink: ink, ter: ter),
        pw.SizedBox(height: 18.0),
        _total(data, semiBold: semiBold, regular: regular, ink: ink, sec: sec),
        pw.SizedBox(height: 18.0),
        _stats(
          data,
          semiBold: semiBold,
          regular: regular,
          ink: ink,
          ter: ter,
          line: line,
        ),
        if (data.categoryRows.isNotEmpty) ...[
          pw.SizedBox(height: 24.0),
          _sectionLabel(data.categoriesLabel, font: semiBold, color: ter),
          pw.SizedBox(height: 8.0),
          _categoryTable(
            data,
            regular: regular,
            ink: ink,
            sec: sec,
            line: line,
          ),
        ],
        pw.SizedBox(height: 24.0),
        _sectionLabel(data.cashVsReceiptsLabel, font: semiBold, color: ter),
        pw.SizedBox(height: 8.0),
        _cashSplit(
          data,
          regular: regular,
          semiBold: semiBold,
          ink: ink,
          sec: sec,
          accent: accent,
          line: line,
        ),
        if (data.insights.isNotEmpty) ...[
          pw.SizedBox(height: 24.0),
          _sectionLabel(data.insightsLabel, font: semiBold, color: ter),
          pw.SizedBox(height: 8.0),
          ..._insights(data, regular: regular, ink: ink, line: line),
        ],
      ],
    ),
  );

  return document.save();
}

PdfColor _pdfColor(AppColors token) => PdfColor.fromInt(token.value.toARGB32());

pw.Widget _header(
  PdfReportData data, {
  required pw.Font semiBold,
  required pw.Font regular,
  required PdfColor ink,
  required PdfColor ter,
}) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            data.titleText,
            style: pw.TextStyle(font: semiBold, fontSize: 22.0, color: ink),
          ),
          pw.SizedBox(height: 2.0),
          pw.Text(
            data.monthLabel,
            style: pw.TextStyle(font: regular, fontSize: 12.0, color: ter),
          ),
        ],
      ),
      pw.Text(
        data.generatedAtText,
        style: pw.TextStyle(font: regular, fontSize: 9.0, color: ter),
      ),
    ],
  );
}

pw.Widget _total(
  PdfReportData data, {
  required pw.Font semiBold,
  required pw.Font regular,
  required PdfColor ink,
  required PdfColor sec,
}) {
  final delta = data.deltaText;
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.RichText(
        text: pw.TextSpan(
          children: [
            pw.TextSpan(
              text: data.totalText,
              style: pw.TextStyle(font: semiBold, fontSize: 34.0, color: ink),
            ),
            pw.TextSpan(text: '  '),
            pw.TextSpan(
              text: data.currencyCode,
              style: pw.TextStyle(font: regular, fontSize: 16.0, color: sec),
            ),
          ],
        ),
      ),
      if (delta != null) ...[
        pw.SizedBox(height: 6.0),
        pw.Text(
          '$delta ${data.deltaLabel ?? ''}'.trim(),
          style: pw.TextStyle(font: regular, fontSize: 11.0, color: sec),
        ),
      ],
    ],
  );
}

pw.Widget _stats(
  PdfReportData data, {
  required pw.Font semiBold,
  required pw.Font regular,
  required PdfColor ink,
  required PdfColor ter,
  required PdfColor line,
}) {
  pw.Widget tile(String label, String value, String caption) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(12.0),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: line, width: 0.5),
          borderRadius: pw.BorderRadius.circular(8.0),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label,
              style: pw.TextStyle(font: regular, fontSize: 9.0, color: ter),
            ),
            pw.SizedBox(height: 4.0),
            pw.Text(
              value,
              style: pw.TextStyle(font: semiBold, fontSize: 16.0, color: ink),
            ),
            pw.SizedBox(height: 2.0),
            pw.Text(
              caption,
              style: pw.TextStyle(font: regular, fontSize: 9.0, color: ter),
            ),
          ],
        ),
      ),
    );
  }

  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      tile(data.averageLabel, data.averageText, data.currencyCode),
      pw.SizedBox(width: 10.0),
      tile(data.purchasesLabel, data.purchaseCountText, data.monthLabel),
      pw.SizedBox(width: 10.0),
      tile(data.cashLabel, data.cashSharePercentText, data.cashLowerLabel),
    ],
  );
}

pw.Widget _sectionLabel(
  String text, {
  required pw.Font font,
  required PdfColor color,
}) {
  return pw.Text(
    text.toUpperCase(),
    style: pw.TextStyle(
      font: font,
      fontSize: 9.0,
      color: color,
      letterSpacing: 0.8,
    ),
  );
}

pw.Widget _categoryTable(
  PdfReportData data, {
  required pw.Font regular,
  required PdfColor ink,
  required PdfColor sec,
  required PdfColor line,
}) {
  return pw.Column(
    children: [
      for (final row in data.categoryRows)
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 7.0),
          decoration: pw.BoxDecoration(
            border: pw.Border(bottom: pw.BorderSide(color: line, width: 0.5)),
          ),
          child: pw.Row(
            children: [
              pw.Container(
                width: 8.0,
                height: 8.0,
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromInt(row.colorArgb),
                  shape: pw.BoxShape.circle,
                ),
              ),
              pw.SizedBox(width: 8.0),
              pw.Expanded(
                child: pw.Text(
                  row.name,
                  style: pw.TextStyle(
                    font: regular,
                    fontSize: 11.0,
                    color: ink,
                  ),
                ),
              ),
              pw.Text(
                row.amountText,
                style: pw.TextStyle(font: regular, fontSize: 11.0, color: ink),
              ),
              pw.SizedBox(width: 14.0),
              pw.SizedBox(
                width: 38.0,
                child: pw.Text(
                  row.sharePercentText,
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                    font: regular,
                    fontSize: 11.0,
                    color: sec,
                  ),
                ),
              ),
            ],
          ),
        ),
    ],
  );
}

pw.Widget _cashSplit(
  PdfReportData data, {
  required pw.Font regular,
  required pw.Font semiBold,
  required PdfColor ink,
  required PdfColor sec,
  required PdfColor accent,
  required PdfColor line,
}) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Row(
        children: [
          pw.Text(
            data.receiptSharePercentText,
            style: pw.TextStyle(font: semiBold, fontSize: 11.0, color: ink),
          ),
          pw.SizedBox(width: 4.0),
          pw.Text(
            data.receiptsLowerLabel,
            style: pw.TextStyle(font: regular, fontSize: 11.0, color: sec),
          ),
          pw.Spacer(),
          pw.Text(
            data.cashSharePercentText,
            style: pw.TextStyle(font: semiBold, fontSize: 11.0, color: ink),
          ),
          pw.SizedBox(width: 4.0),
          pw.Text(
            data.cashLowerLabel,
            style: pw.TextStyle(font: regular, fontSize: 11.0, color: sec),
          ),
        ],
      ),
    ],
  );
}

List<pw.Widget> _insights(
  PdfReportData data, {
  required pw.Font regular,
  required PdfColor ink,
  required PdfColor line,
}) {
  return [
    for (final insight in data.insights)
      pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 7.0),
        decoration: pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: line, width: 0.5)),
        ),
        child: pw.Text(
          insight,
          style: pw.TextStyle(font: regular, fontSize: 11.0, color: ink),
        ),
      ),
  ];
}
