import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/models/receipt_storage_info/receipt_storage_info.dart';
import '../../../domain/repositories/i_receipt_repository.dart';

part 'receipt_storage_event.dart';

part 'receipt_storage_state.dart';

part 'receipt_storage_state_ext.dart';

part 'receipt_storage_bloc.freezed.dart';

/// Screen-scoped bloc (`registerFactory` semantics: built in
/// `ReceiptStoragePage.initState`, closed in `dispose` — never `main()`,
/// per BLoC rule A3.8).
///
/// A ONE-SHOT read, and deliberately so: this screen reports what one
/// receipt currently costs, which only changes when the receipt itself is
/// edited — and editing it means leaving this page. hive_rules.md §6's
/// `watchAll()` requirement targets screens that DISPLAY data another
/// surface can mutate underneath them; a size readout is not that.
///
/// It talks only to [IReceiptRepository], which is the point of that
/// interface existing: resolving the photo file, the item rows and the
/// document estimate is data-source work, so it lives in the repository
/// rather than here.
class ReceiptStorageBloc
    extends Bloc<ReceiptStorageEvent, ReceiptStorageState> {
  final IReceiptRepository _receiptRepository;
  final String receiptId;

  ReceiptStorageBloc({
    required this.receiptId,
    required this._receiptRepository,
  }) : super(const ReceiptStorageState()) {
    on<_Load>(_onLoad);
  }

  Future<void> _onLoad(_Load event, Emitter<ReceiptStorageState> emit) async {
    emit(state.copyWith(status: EReceiptStorageStatus.loading));

    try {
      final info = await _receiptRepository.storageInfo(receiptId);

      // A missing receipt is `notFound`, never `failed` — it was deleted
      // from another surface while this page was open, which is not an
      // error (recorded bug `absent-data-mapped-to-failed-status`).
      emit(
        info == null
            ? state.copyWith(status: EReceiptStorageStatus.notFound)
            : state.copyWith(
                status: EReceiptStorageStatus.ready,
                info: info,
              ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: EReceiptStorageStatus.failed,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
