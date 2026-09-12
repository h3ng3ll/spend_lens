import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../category/domain/models/category/category.dart';
import '../../../expense/domain/models/expense/expense.dart';
import '../../../store/domain/models/store/store.dart';

part 'home_snapshot.freezed.dart';

/// Named snapshot class combining the streams [HomeBloc] reacts to
/// (hive_rules.md §7/§10 — never a Dart record type for a combined-stream
/// value).
///
/// M5 extends the M4 expenses+categories pair with [stores], needed to
/// resolve a store name for the Recent list's meta line
/// (design_spendlens.md §10). Still ONE combined stream via
/// `combineLatest3` and a single `emit.forEach` — never parallel streams.
///
/// `@freezed` for the generated `toString()`. As a plain class this printed
/// as `Instance of 'HomeSnapshot'` in every `[Transition]` line, so a
/// `HomeState` log said nothing about what the screen was actually showing —
/// during the sync investigation the Home transitions were unreadable noise.
/// It is NOT persisted and NOT a Hive model, so it needs no `@HiveField`, no
/// entry in `@GenerateAdapters`, and no `fromJson`.
@freezed
sealed class HomeSnapshot with _$HomeSnapshot {
  const factory HomeSnapshot({
    required List<Expense> expenses,
    required List<Category> categories,
    required List<Store> stores,
  }) = _HomeSnapshot;
}
