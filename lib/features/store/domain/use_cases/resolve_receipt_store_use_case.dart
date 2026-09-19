import '../matcher/receipt_store_matcher.dart';
import '../models/store/store.dart';
import '../repositories/i_store_local_repository.dart';

/// Resolves a receipt's printed store name to an EXISTING [Store], or `null`.
///
/// The repository half of the matching stage `ReceiptStoreResolver`'s doc
/// comment defers to ("a repository-layer concern the use case above the
/// parser performs"). Keeping it here rather than in a bloc means the matching
/// POLICY lives in one place: the blocs only ask "which store is this?" and
/// never carry thresholds or string arithmetic of their own.
///
/// Returning `null` is a normal, expected outcome — it means "leave the store
/// unselected", never "create one".
class ResolveReceiptStoreUseCase {
  final IStoreLocalRepository _repository;
  final ReceiptStoreMatcher _matcher;

  const ResolveReceiptStoreUseCase({
    required IStoreLocalRepository repository,
    ReceiptStoreMatcher matcher = const ReceiptStoreMatcher(),
  }) : this._(repository, matcher);

  const ResolveReceiptStoreUseCase._(this._repository, this._matcher);

  Future<Store?> call(String? printedName) async {
    if (printedName == null || printedName.trim().isEmpty) return null;

    return _matcher.match(
      printedName: printedName,
      // `getAll()` hides tombstoned rows, so a deleted store can never be
      // resolved back onto a new receipt.
      stores: await _repository.getAll(),
    );
  }
}
