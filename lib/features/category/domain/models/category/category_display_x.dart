import '../../../../../core/resources/localization/gen/app_localizations.dart';
import 'category.dart';

/// Resolves a [Category.name] to a user-visible string.
///
/// `name` is an i18n key for the 12 built-in categories (e.g. `'catFood'`)
/// and a plain user-typed string for custom ones (design_spendlens.md §3) —
/// never a rendered string baked in at seed/creation time. This is the one
/// shared resolver so every screen (Analytics, Home, History, Stores…)
/// renders category names identically instead of re-deriving the mapping.
///
/// Also applies the design's category-display shortening rule
/// (design_spendlens.md §4.4): `Restaurants & Coffee` renders as
/// `Restaurants` in charts, legends and badges — resolved here through the
/// already-shortened `catRestaurants` ARB key rather than truncating the
/// full string at the call site.
extension CategoryDisplayX on Category {
  String displayName(AppLocalizations lo) {
    switch (name) {
      case 'catFood':
        return lo.catFood;
      case 'catTransport':
        return lo.catTransport;
      case 'catHousehold':
        return lo.catHousehold;
      case 'catRestaurantsCoffee':
        return lo.catRestaurants;
      case 'catHealth':
        return lo.catHealth;
      case 'catOther':
        return lo.catOther;
      case 'catShopping':
        return lo.catShopping;
      case 'catEntertainment':
        return lo.catEntertainment;
      case 'catUtilities':
        return lo.catUtilities;
      case 'catTravel':
        return lo.catTravel;
      case 'catEducation':
        return lo.catEducation;
      case 'catPersonalCare':
        return lo.catPersonalCare;
      default:
        // A custom, user-typed category name — never an i18n key.
        return name;
    }
  }
}
