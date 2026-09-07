// Central Hive adapter registration for the app.
//
// M1 registers no models yet — the 8 freezed entities (`Receipt`,
// `ReceiptItem`, `Product`, `Store`, `Category`, `Expense`,
// `PriceObservation`, `AppSettings`) land in M3, per design_spendlens.md §3.
//
// `hive_ce_generator` only emits `hive_adapters.g.dart` /
// `hive_registrar.g.dart` when `@GenerateAdapters([...])` lists at least one
// `AdapterSpec<T>()` — an empty list is a structural no-op with nothing to
// generate, so the `part`/`@GenerateAdapters` annotation is deliberately
// deferred to M3, when the first real model exists to register. Adding it
// now would leave `part 'hive_adapters.g.dart';` pointing at a file the
// generator refuses to write.
//
// Per hive_rules.md, once models exist: every enum used as a `@HiveField`
// must be imported DIRECTLY in this file (not just in the model file) — the
// generated `.g.dart` is a `part` file and only inherits this file's
// imports.
