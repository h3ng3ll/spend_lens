part of 'record_detail_bloc.dart';

enum ERecordDetailStatus { initial, loading, ready, notFound, failed }

@freezed
sealed class RecordDetailState with _$RecordDetailState {
  const factory RecordDetailState({
    @Default(ERecordDetailStatus.initial) ERecordDetailStatus status,
    RecordDetailSnapshot? snapshot,
    @Default('') String errorMessage,

    /// Whether the most recent `deleteRecord` write failed. A one-shot
    /// signal for an error-toast listener — never read to derive displayed
    /// state.
    @Default(false) bool lastDeleteFailed,
  }) = _RecordDetailState;
}
