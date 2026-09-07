import '../../../../../core/resources/colors/app_colors.dart';

/// Assigns the next custom category's hue by cycling through the same
/// 12-hue palette the built-in categories use (design_spendlens.md §18) —
/// shared by `CategoryPage`'s quick-create row and `NewCategoryPage`'s
/// Create action so both custom-category creation paths derive a color the
/// identical way.
String nextCustomCategoryColorHex(int existingCustomCount) {
  const palette = [
    AppColors.categoryFood,
    AppColors.categoryTransport,
    AppColors.categoryHousehold,
    AppColors.categoryRestaurantsCoffee,
    AppColors.categoryHealth,
    AppColors.categoryShopping,
    AppColors.categoryEntertainment,
    AppColors.categoryUtilities,
    AppColors.categoryTravel,
    AppColors.categoryEducation,
    AppColors.categoryPersonalCare,
    AppColors.categoryOther,
  ];
  final color = palette[existingCustomCount % palette.length].value;
  final argb32 = color.toARGB32();
  return '#${(argb32 & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}
