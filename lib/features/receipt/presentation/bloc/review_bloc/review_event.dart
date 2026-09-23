part of 'review_bloc.dart';

@freezed
sealed class ReviewEvent with _$ReviewEvent {
  /// Loads the current scan draft from [PendingReceiptDraftStore] — the
  /// bloc's ONE decision path off `initial`, dispatched from
  /// `ReviewPage.initState` (screen-scoped bloc, never `main()` — BLoC rule
  /// A3.8).
  const factory ReviewEvent.load() = _Load;

  /// Starts inline editing of one item row (design_spendlens.md's Review
  /// artboard — tapping a row opens its editable name/qty/total fields).
  const factory ReviewEvent.startEditItem(String itemId) = _StartEditItem;

  /// Commits the currently-edited item's name field. No-payload toggle
  /// events are for booleans (A3.11) — this is a text commit, so it DOES
  /// carry the new value, read from the UI's own `TextEditingController`
  /// text at commit time, never a stale build-time prop
  /// (`textfield-ontapoutside-submits-stale-prop`).
  const factory ReviewEvent.commitEditedName(String name) = _CommitEditedName;

  const factory ReviewEvent.stopEditItem() = _StopEditItem;

  const factory ReviewEvent.setCategory(String categoryId) = _SetCategory;

  /// The user corrected when the receipt was issued — a receipt is often
  /// scanned days after the purchase, and OCR may misread or miss the date.
  const factory ReviewEvent.setPurchasedAt(DateTime purchasedAt) =
      _SetPurchasedAt;

  /// Save and return to Home (the "Save Receipt" primary action).
  const factory ReviewEvent.save() = _Save;

  /// Save, then route to Edit-receipt for further correction (the
  /// "Correct" secondary action) — a DISTINCT terminal status from `save`,
  /// see [EReviewStatus.correcting].
  const factory ReviewEvent.saveAndCorrect() = _SaveAndCorrect;
}
