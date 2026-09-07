/// Sync-readiness marker carried by every stored entity (design_spendlens.md
/// §3 / spec §62 — fields only, **no sync logic** in M3). A future milestone
/// may add a real sync engine that reads/writes this field; M3 only reserves
/// it so every entity's on-disk shape never needs a breaking migration later.
enum ESyncStatus {
  synced,
  pendingCreate,
  pendingUpdate,
  pendingDelete,
}
