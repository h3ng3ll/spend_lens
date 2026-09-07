import '../../../core/di/injection.dart';
import '../domain/i_receipt_parse_pipeline.dart';
import '../domain/receipt_parse_pipeline.dart';

/// Registers the scanner slice's own domain dependency.
///
/// `ScannerBloc` itself is NOT registered here — it is screen-scoped
/// (`registerFactory` semantics applied by hand: built in
/// `ScannerPage.initState`, closed in `dispose`, never resolved from
/// `getIt`), per design_spendlens.md §5 / BLoC rule A3.8.
void initScannerFeature() {
  getIt.registerLazySingleton<IReceiptParsePipeline>(
    () => const ReceiptParsePipeline(),
  );
}
