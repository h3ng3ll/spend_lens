import 'package:hive_ce_flutter/hive_flutter.dart';

import 'enum_adapters.dart';
import 'hive_registrar.g.dart';

/// Initializes Hive.
///
/// Must run before [initDependencies] so that feature repositories can
/// resolve their boxes.
///
/// M2 registers the first real adapters: the generated `AppSettings` model
/// adapter (via `Hive.registerAdapters()`, the extension `hive_ce_generator`
/// emits once `hive_adapters.dart` lists an `AdapterSpec`) and the manual
/// `EAppThemeModeAdapter` (typeId 100, per hive_rules.md — auto-generated
/// adapters occupy 0–99). M3 adds the remaining 7 entities' adapters here
/// the same way.
///
/// Per hive_rules.md: `HiveDatabase.getBox<E>` (added in M3 alongside the
/// first real model) must call `Hive.openBox<E>` directly — no box caching,
/// ever. M2's `SettingsLocalRepository` follows that same rule already.
Future<void> initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapters();
  Hive.registerAdapter(EAppThemeModeAdapter());
}
