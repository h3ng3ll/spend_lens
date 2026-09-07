import 'package:flutter/foundation.dart';

/// The currently-selected reporting period for Home/Analytics — a single
/// (year, 0-based month) pair. Immutable value type, not a bloc state field
/// (it is UI-local selection state owned by each screen, per BLoC rule
/// A3.1 — this is not a `filteredX` derived state, it is the SELECTION
/// itself, which both Home and Analytics read to decide which month's
/// expenses to show).
@immutable
class SelectedPeriod {
  final int year;

  /// 0-based (0 = January … 11 = December), matching the ARB `months0..11`
  /// / `monthsShort0..11` key numbering.
  final int month;

  const SelectedPeriod({required this.year, required this.month});

  factory SelectedPeriod.now() {
    final now = DateTime.now();
    return SelectedPeriod(year: now.year, month: now.month - 1);
  }

  bool contains(DateTime date) => date.year == year && date.month - 1 == month;

  @override
  bool operator ==(Object other) =>
      other is SelectedPeriod && other.year == year && other.month == month;

  @override
  int get hashCode => Object.hash(year, month);
}
