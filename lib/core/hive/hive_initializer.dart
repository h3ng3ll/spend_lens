import 'package:hive_ce_flutter/hive_flutter.dart';

/// Initializes Hive.
///
/// Must run before [initDependencies] so that feature repositories can
/// resolve their boxes. `Hive.registerAdapters()` (the generated extension
/// from `hive_registrar.g.dart`) is wired in starting M3, once
/// `hive_adapters.dart` lists at least one `AdapterSpec<T>()` for the
/// generator to act on — see the note there.
///
/// Per hive_rules.md: `HiveDatabase.getBox<E>` (added in M3 alongside the
/// first real model) must call `Hive.openBox<E>` directly — no box caching,
/// ever.
Future<void> initHive() async {
  await Hive.initFlutter();
}
