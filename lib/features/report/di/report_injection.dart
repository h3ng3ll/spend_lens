import '../../../core/di/injection.dart';
import '../domain/use_cases/export_pdf_report_use_case.dart';

/// Registers the report slice (the Analytics PDF export).
///
/// The use case is dependency-free — it reads fonts from the asset bundle and
/// receives its content from the caller — so registration order relative to
/// the other `init*Feature()` calls does not matter.
void initReportFeature() {
  getIt.registerLazySingleton(() => const ExportPdfReportUseCase());
}
