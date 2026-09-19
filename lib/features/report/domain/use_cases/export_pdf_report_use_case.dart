import 'dart:io';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../models/pdf_report_data.dart';
import '../report_pdf_codec.dart';

/// Result of a completed PDF export — the file the share sheet hands off,
/// plus the month label the `pdfToast` ARB placeholder needs (mirrors
/// `ExportCsvResult`).
class ExportPdfReportResult {
  final File file;
  final String filename;
  final String monthLabel;

  const ExportPdfReportResult({
    required this.file,
    required this.filename,
    required this.monthLabel,
  });
}

/// Fonts are read once per process and reused: `rootBundle` is only reachable
/// from the main isolate, and re-decoding ~1.2 MB of TTF on every export
/// would undo the point of moving the work off the UI thread.
Uint8List? _regularFontCache;
Uint8List? _semiBoldFontCache;

const String _regularFontAsset = 'assets/fonts/NotoSans-Regular.ttf';
const String _semiBoldFontAsset = 'assets/fonts/NotoSans-SemiBold.ttf';

/// Builds the Analytics month report PDF **off the UI thread** and writes it
/// to a temp file for the share sheet.
///
/// PDF layout is CPU-bound — glyph metrics, text shaping and page assembly —
/// and running it inline janks the Analytics screen while the user is still
/// looking at it. So the rendering happens inside `Isolate.run`.
///
/// The isolate boundary dictates the shape of this class: `rootBundle`,
/// `path_provider` and `AppLocalizations` are all main-isolate-only, so the
/// caller resolves every string, the fonts are loaded here, and the temp file
/// is written here. Only [PdfReportData] — plain, sendable values — crosses
/// into the isolate, and only bytes come back.
class ExportPdfReportUseCase {
  const ExportPdfReportUseCase();

  /// [buildData] receives the loaded font bytes and returns the finished,
  /// fully-localized payload. It is a callback rather than a plain argument
  /// because the fonts are this class's concern, not the caller's — the page
  /// supplies only the report's content.
  Future<ExportPdfReportResult> call(
    PdfReportData Function(Uint8List regular, Uint8List semiBold) buildData,
  ) async {
    final regular = _regularFontCache ??= (await rootBundle.load(
      _regularFontAsset,
    )).buffer.asUint8List();
    final semiBold = _semiBoldFontCache ??= (await rootBundle.load(
      _semiBoldFontAsset,
    )).buffer.asUint8List();

    final data = buildData(regular, semiBold);

    // The whole reason this class exists: `buildReportPdf` is pure, so it can
    // run on a background isolate and leave the UI thread free to keep the
    // Analytics screen scrolling while the report renders.
    final bytes = await Isolate.run(() => buildReportPdf(data));

    final directory = await getTemporaryDirectory();
    final filename =
        'spendlens_report_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${directory.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);

    return ExportPdfReportResult(
      file: file,
      filename: filename,
      monthLabel: data.monthLabel,
    );
  }
}
