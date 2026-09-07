part of 'record_detail_bloc.dart';

/// The UI reads these getters, never the enum directly.
extension RecordDetailStateX on RecordDetailState {
  bool get isInitial => status == ERecordDetailStatus.initial;

  bool get isLoading => status == ERecordDetailStatus.loading;

  bool get isReady => status == ERecordDetailStatus.ready;

  /// The record was deleted (e.g. by this same screen's own delete action,
  /// or from elsewhere) while this screen was still mounted, or the id it
  /// was opened with never resolved. Treated distinctly from [isFailed] —
  /// no error occurred, the record is simply gone.
  bool get isNotFound => status == ERecordDetailStatus.notFound;

  bool get isFailed => status == ERecordDetailStatus.failed;
}
