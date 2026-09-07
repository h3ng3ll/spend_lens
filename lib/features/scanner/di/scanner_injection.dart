import '../../../core/di/injection.dart';
import '../../receipt/domain/parser/receipt_parser.dart';
import '../domain/i_receipt_parse_pipeline.dart';
import '../domain/pending_receipt_draft_store.dart';
import '../domain/receipt_parse_pipeline.dart';

/// Registers the scanner slice's own domain dependencies.
///
/// `ScannerBloc` itself is NOT registered here — it is screen-scoped
/// (`registerFactory` semantics applied by hand: built in
/// `ScannerPage.initState`, closed in `dispose`, never resolved from
/// `getIt`), per design_spendlens.md §5 / BLoC rule A3.8.
///
/// [PendingReceiptDraftStore] IS an app-lifetime singleton — it is the
/// in-memory handoff slot between the Scanner and Review/Edit screens (see
/// its own doc comment for why this isn't a router `extra` payload).
void initScannerFeature() {
  getIt.registerLazySingleton(() => PendingReceiptDraftStore());
  getIt.registerLazySingleton(() => const ReceiptParser());
  getIt.registerLazySingleton<IReceiptParsePipeline>(
    () => ReceiptParsePipeline(
      getIt<ReceiptParser>(),
      getIt<PendingReceiptDraftStore>(),
    ),
  );
}
