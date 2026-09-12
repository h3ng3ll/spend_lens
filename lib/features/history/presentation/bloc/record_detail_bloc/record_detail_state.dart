part of 'record_detail_bloc.dart';

enum ERecordDetailStatus { initial, loading, ready, notFound, failed }

@freezed
sealed class RecordDetailState with _$RecordDetailState {
  const factory RecordDetailState({
    /// The record this screen was opened for.
    ///
    /// Lives in STATE, not as a bloc field: a value the UI and the handlers
    /// both need is state by definition, and a public field on the bloc is
    /// invisible to `BlocBuilder`/`BlocSelector` and unreachable from
    /// `bloc_test`'s state assertions. Seeded by the constructor, then never
    /// reassigned — the screen is built per record (`registerFactory`
    /// semantics) and a bloc instance never switches to a different one.
    @Default('') String recordId,

    @Default(ERecordDetailStatus.initial) ERecordDetailStatus status,
    RecordDetailSnapshot? snapshot,
    @Default('') String errorMessage,

    /// Whether the most recent `deleteRecord` write failed. A one-shot
    /// signal for an error-toast listener — never read to derive displayed
    /// state.
    @Default(false) bool lastDeleteFailed,
  }) = _RecordDetailState;
}
