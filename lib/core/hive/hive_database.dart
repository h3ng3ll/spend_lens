import 'package:hive_ce/hive.dart';

/// Central box-access helper (hive_rules.md §7 / recorded global bug
/// `hive-getbox-cache-breaks-watch`).
///
/// `getBox<E>` calls `Hive.openBox<E>` **directly** — no `_openedBoxes` map,
/// no `disposeBox`, no `closeAll`. Hive already de-duplicates opens
/// internally, so an app-level cache is both unnecessary and actively
/// breaks `box.watch()` reactivity. Every M3 repository goes through this
/// one helper instead of calling `Hive.openBox` ad hoc, so the "never cache
/// a box" rule has exactly one place to audit.
class HiveDatabase {
  const HiveDatabase();

  Future<Box<E>> getBox<E>(String name) => Hive.openBox<E>(name);
}
