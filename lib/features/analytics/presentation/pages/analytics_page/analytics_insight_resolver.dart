import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../category/domain/models/category/category.dart';
import '../../../../category/domain/models/category/category_display_x.dart';
import '../../../domain/models/analytics_insight/analytics_insight.dart';

/// Resolves the analytics engine's (ARB key, params) pairs
/// ([AnalyticsInsight]) into rendered strings — the ONLY place a
/// [BuildContext]/`AppLocalizations` touches an insight. The generator
/// itself never renders a string (design_spendlens.md §10, spec §53).
///
/// [categories] resolves a `categoryId` param to its localized display name
/// (`ins2`/`insA1`/`insA2` carry a raw category id from the calculator,
/// never a rendered name) — the `Restaurants & Coffee` → `Restaurants`
/// shortening rule (design_spendlens.md §4.4) is applied here via
/// `CategoryDisplayX`, exactly like every other screen.
String resolveAnalyticsInsight(
  AppLocalizations lo,
  List<Category> categories,
  AnalyticsInsight insight,
) {
  switch (insight.key) {
    case EAnalyticsInsightKey.ins1:
      return lo.ins1(insight.params[0] as int);
    case EAnalyticsInsightKey.ins2:
      return lo.ins2(
        _categoryDisplayName(lo, categories, insight.params[0] as String),
        lo.getInsightDirectionWord(insight.params[1] as String),
        insight.params[2] as int,
      );
    case EAnalyticsInsightKey.ins3:
      return lo.ins3(
        insight.params[0] as String,
        insight.params[1] as String,
        insight.params[2] as String,
      );
    case EAnalyticsInsightKey.insA1:
      return lo.insA1(
        _categoryDisplayName(lo, categories, insight.params[0] as String),
        insight.params[1] as int,
      );
    case EAnalyticsInsightKey.insA2:
      return lo.insA2(
        _categoryDisplayName(lo, categories, insight.params[0] as String),
        insight.params[1] as int,
        insight.params[2] as String,
      );
    case EAnalyticsInsightKey.insA3:
      return lo.insA3(
        insight.params[0] as String,
        insight.params[1] as String,
      );
  }
}

String _categoryDisplayName(
  AppLocalizations lo,
  List<Category> categories,
  String categoryId,
) {
  for (final category in categories) {
    if (category.id == categoryId) return category.displayName(lo);
  }
  return categoryId;
}

/// The insight generator emits `'trendIncreased'`/`'trendDecreased'` as a
/// plain lookup key (never a rendered word) for `ins2`'s `{direction}`
/// placeholder — resolved to the matching ARB string here.
extension _DirectionWordX on AppLocalizations {
  String getInsightDirectionWord(String key) {
    return key == 'trendIncreased' ? trendIncreased : trendDecreased;
  }
}
