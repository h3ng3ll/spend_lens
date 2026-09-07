import 'package:flutter/material.dart';

import '../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../category/domain/models/category/category.dart';

/// Resolves a [Category]'s display name.
///
/// `Category.name` is an i18n KEY for the 12 built-in categories (e.g.
/// `'catFood'`) and a plain user-typed string for custom ones
/// (`category.freezed.dart` doc comment) — so this can never be a simple
/// getter and must explicitly resolve through [AppLocalizations].
///
/// This is also where design_spendlens.md §4.4's category-display-shortening
/// rule lives: `'Restaurants & Coffee'` renders as `'Restaurants'` in charts,
/// legends and badges — the ARB already ships the shortened form under the
/// dedicated `catRestaurants` key, so no runtime string-slicing is needed.
String resolveCategoryName(AppLocalizations lo, Category category) {
  switch (category.name) {
    case 'catFood':
      return lo.catFood;
    case 'catTransport':
      return lo.catTransport;
    case 'catHousehold':
      return lo.catHousehold;
    case 'catRestaurantsCoffee':
      // Shortened form (design_spendlens.md §4.4) — never the long form.
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
      // A custom, user-created category: `name` is already the display
      // string the user typed — never an i18n key to look up.
      return category.name;
  }
}

/// Resolves a [Category]'s color hue via [AppColorScheme.categoryColor].
///
/// [AppColorScheme.categoryColor] switches on the ENGLISH canonical name
/// (`'Food'`, `'Transport'`, …) rather than the `catXxx` i18n key stored in
/// `Category.id`/`Category.name` — passing the raw id straight through would
/// silently fall through to its `default` (grey `categoryOther`) branch for
/// every single built-in category. This bridges that mismatch without
/// touching the shared color-scheme file.
Color resolveCategoryColor(Category category) {
  switch (category.name) {
    case 'catFood':
      return AppColorScheme.categoryColor('Food');
    case 'catTransport':
      return AppColorScheme.categoryColor('Transport');
    case 'catHousehold':
      return AppColorScheme.categoryColor('Household');
    case 'catRestaurantsCoffee':
      return AppColorScheme.categoryColor('Restaurants & Coffee');
    case 'catHealth':
      return AppColorScheme.categoryColor('Health');
    case 'catOther':
      return AppColorScheme.categoryColor('Other');
    case 'catShopping':
      return AppColorScheme.categoryColor('Shopping');
    case 'catEntertainment':
      return AppColorScheme.categoryColor('Entertainment');
    case 'catUtilities':
      return AppColorScheme.categoryColor('Utilities');
    case 'catTravel':
      return AppColorScheme.categoryColor('Travel');
    case 'catEducation':
      return AppColorScheme.categoryColor('Education');
    case 'catPersonalCare':
      return AppColorScheme.categoryColor('Personal Care');
    default:
      // A custom category has no seeded hue — fall through to the same
      // catch-all the design uses for an unrecognized id.
      return AppColorScheme.categoryColor('Other');
  }
}

/// The catch-all color for an expense whose `categoryId` no longer resolves
/// to any known [Category] (e.g. the category was deleted after the expense
/// was recorded) — the same hue [resolveCategoryColor]'s `default` branch
/// uses, exposed standalone so a caller with no [Category] instance at all
/// doesn't need to fabricate one just to reach that branch.
Color resolveCategoryColorForOther() => AppColorScheme.categoryColor('Other');
