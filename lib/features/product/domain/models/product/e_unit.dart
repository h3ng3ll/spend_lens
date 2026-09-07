/// Unit of measure for a [ReceiptItem]/[Product] line (design_spendlens.md
/// §3 and §11 — the normalizer's comparable-unit-price math,
/// `1.2 kg @ 104 → 86.67/kg`, depends on knowing which of these three a line
/// is in).
enum EUnit {
  piece,
  kilogram,
  liter,
}
