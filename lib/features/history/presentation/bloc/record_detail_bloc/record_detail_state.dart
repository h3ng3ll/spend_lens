part of 'record_detail_bloc.dart';

enum ERecordDetailStatus { initial, loading, ready, notFound, failed }

@freezed
sealed class RecordDetailState with _$RecordDetailState {
  const factory RecordDetailState({
    @Default(ERecordDetailStatus.initial) ERecordDetailStatus status,
    RecordDetailSnapshot? snapshot,
    @Default('') String errorMessage,
  }) = _RecordDetailState;
}
