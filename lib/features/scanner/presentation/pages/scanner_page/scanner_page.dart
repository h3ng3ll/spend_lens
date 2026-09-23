import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_colors.dart';
import '../../../../../core/services/image_region_cropper.dart';
import '../../../../../core/services/ocr/i_receipt_detector.dart';
import '../../../../../core/services/ocr/ocr_service.dart';
import '../../../../receipt/domain/repositories/i_receipt_local_repository.dart';
import '../../../domain/i_receipt_parse_pipeline.dart';
import '../../../domain/pending_receipt_draft_store.dart';
import '../../bloc/scanner_bloc/scanner_bloc.dart';
import 'widgets/scanner_body.dart';

/// `ScannerPageRoute` (design_spendlens.md §5) — a top-level push above the
/// shell. The scanner's sub-states (searching/detected/capturing/
/// processing/failed/ready) are ONE route, driven by [ScannerBloc].
///
/// Full-bleed camera preview — NO `CustomAppBar` (the design's Scanner
/// artboard has no title bar; its close/flash controls float over the
/// preview as translucent pills). Because this screen owns its own insets
/// entirely (top-level push, not a shell branch —
/// `missing-safearea-top-inset-header-behind-statusbar` /
/// `control-rendered-inside-the-system-cutout-inset-is-untappable`), every
/// overlay control positions itself with `MediaQuery.paddingOf(context)`
/// rather than assuming a shared `SafeArea`.
///
/// [ScannerBloc] is screen-scoped (`registerFactory` semantics): built here
/// in `initState`, closed in `dispose` — never registered in `main()`
/// (BLoC rule A3.8). It owns the whole scanning pipeline, so its real
/// service dependencies are resolved from `getIt` here and injected via its
/// constructor — the widget tree never calls `getIt` itself.
class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final ScannerBloc _scannerBloc = ScannerBloc(
    receiptDetector: getIt<IReceiptDetector>(),
    ocrService: getIt<OcrService>(),
    parsePipeline: getIt<IReceiptParsePipeline>(),
    draftStore: getIt<PendingReceiptDraftStore>(),
    imageRegionCropper: getIt<ImageRegionCropper>(),
  );

  @override
  void dispose() {
    _scannerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black.value,
      body: BlocProvider<ScannerBloc>.value(
        value: _scannerBloc,
        child: ScannerBody(
          receiptLocalRepository: getIt<IReceiptLocalRepository>(),
        ),
      ),
    );
  }
}
