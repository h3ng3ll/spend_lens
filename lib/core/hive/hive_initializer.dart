import 'package:hive_ce_flutter/hive_flutter.dart';

import 'enum_adapters.dart';
import 'hive_registrar.g.dart';

/// Initializes Hive.
///
/// Must run before [initDependencies] so that feature repositories can
/// resolve their boxes.
///
/// M2 registered the first real adapters: the generated `AppSettings` model
/// adapter (via `Hive.registerAdapters()`, the extension `hive_ce_generator`
/// emits once `hive_adapters.dart` lists an `AdapterSpec`) and the manual
/// `EAppThemeModeAdapter` (typeId 100, per hive_rules.md — auto-generated
/// adapters occupy 0–99). M3 completes the 8-entity data layer: 7 more
/// generated model adapters (typeIds 1–7, via `Hive.registerAdapters()`
/// already) and 5 more manual enum adapters (typeIds 101–105).
///
/// Per hive_rules.md: `HiveDatabase.getBox<E>` (see `hive_database.dart`)
/// calls `Hive.openBox<E>` directly — no box caching, ever. M2's
/// `SettingsLocalRepository` and every M3 repository follow that same rule.
Future<void> initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapters();
  Hive.registerAdapter(EAppThemeModeAdapter());
  Hive.registerAdapter(ESyncStatusAdapter());
  Hive.registerAdapter(EUnitAdapter());
  Hive.registerAdapter(EStoreTypeAdapter());
  Hive.registerAdapter(EExpenseSourceAdapter());
  Hive.registerAdapter(EFlashModeAdapter());
}
