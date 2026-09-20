import '../../../../../core/resources/localization/gen/app_localizations.dart';

/// Resolves a 1-based calendar month to its localized short label
/// (`monthsShort0`..`monthsShort11`, 0-based ARB key numbering).
///
/// Top-level rather than private to `PriceHistoryBody` because the product
/// page renders the same chart and needs the same labels — two copies of a
/// 1-vs-0 based index mapping is exactly the kind of duplicate that drifts
/// by one and mislabels every bar.
String monthShortLabel(AppLocalizations lo, int month) {
  return switch (month) {
    1 => lo.monthsShort0,
    2 => lo.monthsShort1,
    3 => lo.monthsShort2,
    4 => lo.monthsShort3,
    5 => lo.monthsShort4,
    6 => lo.monthsShort5,
    7 => lo.monthsShort6,
    8 => lo.monthsShort7,
    9 => lo.monthsShort8,
    10 => lo.monthsShort9,
    11 => lo.monthsShort10,
    _ => lo.monthsShort11,
  };
}
