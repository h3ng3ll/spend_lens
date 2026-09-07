import 'package:hive_ce/hive.dart';

import '../../features/settings/domain/models/app_settings/app_settings.dart';
import '../../features/settings/domain/models/app_settings/e_app_theme_mode.dart';

part 'hive_adapters.g.dart';

/// Central Hive adapter registration for the app.
///
/// M2 registers the first real model — `AppSettings` — one milestone early,
/// per design_spendlens.md's explicit M2 carve-out ("if that forces a small
/// AppSettings-shaped Hive box early, that is acceptable and expected").
/// The remaining 7 freezed entities (`Receipt`, `ReceiptItem`, `Product`,
/// `Store`, `Category`, `Expense`, `PriceObservation`) land in M3 as
/// additional `AdapterSpec<T>()` entries in this same list — M3 extends this
/// file, it does not replace it.
///
/// Per hive_rules.md: every enum used as a `@HiveField` must be imported
/// DIRECTLY in this file (not just in the model file) — the generated
/// `.g.dart` is a `part` file and only inherits this file's imports. Hence
/// the explicit `e_app_theme_mode.dart` import above even though
/// `app_settings.dart` already imports it.
@GenerateAdapters([
  AdapterSpec<AppSettings>(),
])
class HiveAdapters {}
