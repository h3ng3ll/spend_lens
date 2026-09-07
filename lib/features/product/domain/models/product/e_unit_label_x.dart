import 'e_unit.dart';

/// The short, non-localized unit abbreviation printed inline next to a
/// quantity (`1.2 kg`, `500 g`) — these are the SAME abbreviations used on
/// printed Moldovan/Romanian receipts, not user-facing prose, so they are
/// deliberately not routed through `AppLocalizations`.
extension EUnitLabelX on EUnit {
  String get shortLabel {
    switch (this) {
      case EUnit.piece:
        return 'pc';
      case EUnit.kilogram:
        return 'kg';
      case EUnit.liter:
        return 'L';
    }
  }
}
