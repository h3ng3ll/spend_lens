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
  /// Deletes the record this bloc was opened for.
  ///
  /// NO PAYLOAD: the bloc already holds the id in
  /// [RecordDetailState.recordId], so passing it back in would let the UI
  /// name a different record than the one the screen is showing. Project
  /// BLoC rule — the UI dispatches intent, not data the bloc already owns.
  const factory RecordDetailEvent.deleteRecord() = _DeleteRecord;
}
