/// The persisted Settings → Appearance choice.
///
/// design_spendlens.md binding decision 2: both dark and light themes are
/// first-class, with a persisted toggle — this overrides the global
/// "dark-only" developer guidance for this project specifically.
///
/// Registered as a manual Hive enum adapter with a typeId ≥ 100 once M3's
/// `hive_adapters.dart` exists (per hive_rules.md); M2's minimal
/// `AppSettings` box (below) already stores it, so the adapter is registered
/// now rather than left for M3 to discover.
enum EAppThemeMode { system, light, dark }
