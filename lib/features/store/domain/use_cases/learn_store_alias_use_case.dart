import '../../../product/domain/normalizer/product_name_cleaner.dart';
import '../models/store/store.dart';
import '../repositories/i_store_local_repository.dart';

/// Teaches the app that [printedName] means [store], so the next receipt
/// printed that way resolves automatically.
///
/// **Only ever called for a store the user picked EXPLICITLY**, at the moment
/// they save. That restriction is the whole design: an auto-match must not
/// record its own guess as a confirmed fact, or one wrong match would teach
/// itself and every later receipt with that header would inherit the error with
/// no way for the user to see why.
///
/// Records only the FINAL saved choice. A user who tries two stores before
/// saving teaches the app exactly one thing — the one they kept — so
/// `kauflend` / `kaumpflend` / `kaulend` all end up pointing at the single
/// `Kaufland` the user actually confirmed.
///
/// This is the first WRITER of `Store.receiptAliases` outside the manual "New
/// store" form, and the first APPEND: `StoresBloc._onCreate` only ever sets a
/// single alias at creation and never adds to it.
class LearnStoreAliasUseCase {
  final IStoreLocalRepository _repository;
  final ProductNameCleaner _cleaner;

  const LearnStoreAliasUseCase({
    required IStoreLocalRepository repository,
    ProductNameCleaner cleaner = const ProductNameCleaner(),
  }) : this._(repository, cleaner);

  const LearnStoreAliasUseCase._(this._repository, this._cleaner);

  Future<void> call({required Store store, required String? printedName}) async {
    if (printedName == null) return;

    final trimmed = printedName.trim();
    if (trimmed.isEmpty) return;

    final cleaned = _cleaner.clean(trimmed);
    if (cleaned.isEmpty) return;

    // Nothing to learn when the matcher would already resolve it: the printed
    // name IS the store name, or an alias for it is on file. Compared CLEANED,
    // so a difference of case or punctuation never adds a duplicate row that
    // would grow without bound across scans.
    if (_cleaner.clean(store.name) == cleaned) return;
    for (final alias in store.receiptAliases) {
      if (_cleaner.clean(alias) == cleaned) return;
    }

    // The RAW printed spelling is stored, not the cleaned one: cleaning is a
    // comparison device, and keeping the original leaves the record honest
    // about what was actually on the receipt.
    await _repository.save(
      store.copyWith(
        receiptAliases: [...store.receiptAliases, trimmed],
        updatedAt: DateTime.now(),
      ),
    );
  }
}
