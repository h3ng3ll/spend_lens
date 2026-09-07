part of 'record_detail_bloc.dart';

@freezed
sealed class RecordDetailEvent with _$RecordDetailEvent {
  /// Subscribes to the combined expense+category+store snapshot for
  /// `recordId`. Dispatched once from `RecordDetailPage.initState` (BLoC
  /// rule A3.8 — never `main()`, since this bloc is screen-scoped, not
  /// app-lifetime).
  const factory RecordDetailEvent.watch() = _Watch;

  /// Deletes this record (`RecordDetailDeleteButton`'s delete action). The
  /// confirm dialog has already run by the time this is dispatched.
  const factory RecordDetailEvent.deleteRecord(String recordId) = _DeleteRecord;
}
