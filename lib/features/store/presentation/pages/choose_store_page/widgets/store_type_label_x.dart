import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../domain/models/store/e_store_type.dart';

/// Resolves an [EStoreType] to its display label
/// (design_spendlens.md's ARB keys `storeType{Supermarket,Market,Pharmacy,
/// Cafe,Store,Other}`). Shared by the Choose-store picker row and New-store's
/// type-chip row so both render the identical label set.
extension EStoreTypeLabelX on EStoreType {
  String label(AppLocalizations lo) {
    switch (this) {
      case EStoreType.supermarket:
        return lo.storeTypeSupermarket;
      case EStoreType.market:
        return lo.storeTypeMarket;
      case EStoreType.pharmacy:
        return lo.storeTypePharmacy;
      case EStoreType.cafe:
        return lo.storeTypeCafe;
      case EStoreType.store:
        return lo.storeTypeStore;
      case EStoreType.other:
        return lo.storeTypeOther;
    }
  }
}
