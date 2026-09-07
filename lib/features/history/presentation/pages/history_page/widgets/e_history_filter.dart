/// The History screen's record-type segmented filter (design_spendlens.md
/// §10, History artboard's `filters` segment: All / Receipts / Cash).
///
/// Local `State`, never bloc state — this is a pure UI-side view selector
/// over the raw `HistoryState.snapshot.expenses` list (BLoC rule A3.1: no
/// `filteredX` field on any bloc state).
enum EHistoryFilter { all, receipts, cash }
