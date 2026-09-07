import 'package:flutter/material.dart';

/// Raw named palette values (design_spendlens.md §4.1).
///
/// Only OPAQUE, non-theme-varying hues live here — neutrals, the two accent
/// pairs, gradient stops, the warn pair, the trend pair, and the 12 category
/// hues. Translucent tokens (`--card`, `--line`, `--field`, `--bar`,
/// `*-tint`) are intentionally NOT enum entries: one base colour appears at
/// several different alphas, so those are built as `withValues(alpha:)`
/// expressions directly in `AppColorScheme.light()` / `.dark()`.
///
/// Values are ported 1:1 from the two verified CSS token strings in
/// `assets/SpendLens design system/SpendLens Prototype.dc.html` — light at
/// line 779, dark at line 780 — plus the category hues verified at line 708.
enum AppColors {
  black(Color(0xFF000000)),
  white(Color(0xFFFFFFFF)),
  transparent(Color(0x00000000)),

  // Background base (opaque) — light `--bg` / dark `--bg`.
  bgLight(Color(0xFFF3F4FA)),
  bgDark(Color(0xFF0A0E1F)),

  // Solid card surface — light `--card-solid` / dark `--card-solid`.
  cardSolidLight(Color(0xFFFFFFFF)),
  cardSolidDark(Color(0xFF161B36)),

  // Sheet surface — light `--sheet` / dark `--sheet`.
  sheetLight(Color(0xFFFFFFFF)),
  sheetDark(Color(0xFF12172E)),

  // Ink (primary on-surface text) — light `--ink` / dark `--ink`.
  inkLight(Color(0xFF14183A)),
  inkDark(Color(0xFFF5F5F7)),

  // Secondary text — light `--sec` / dark `--sec`.
  secLight(Color(0xFF5B6180)),
  secDark(Color(0xFFA7ACC4)),

  // Tertiary text — light `--ter` / dark `--ter`.
  terLight(Color(0xFF6B7190)),
  terDark(Color(0xFF7C819C)),

  // Dimmed / disabled text — light `--dim` / dark `--dim`.
  dimLight(Color(0xFFC9CDDD)),
  dimDark(Color(0xFF3A3F5C)),

  // On-accent (text/icon painted on top of a solid accent fill) —
  // light `--onaccent` / dark `--onaccent`.
  onAccentLight(Color(0xFF14183A)),
  onAccentDark(Color(0xFF0A0E1F)),

  // Toast ink — light `--toastink` / dark `--toastink`.
  toastInkLight(Color(0xFFFFFFFF)),
  toastInkDark(Color(0xFFF5F5F7)),

  // Accent pair (primary brand hue) — light `--accent` / dark `--accent`.
  accentLight(Color(0xFF5B3FC4)),
  accentDark(Color(0xFFC4B5FD)),

  // Accent2 pair (secondary/teal-cyan brand hue) — light `--accent2` /
  // dark `--accent2`.
  accent2Light(Color(0xFF0E7C8C)),
  accent2Dark(Color(0xFF8EE3F5)),

  // Warn pair (destructive / delete-all / trend-up token) — light `--warn` /
  // dark `--warn`.
  warnLight(Color(0xFF9A5B0B)),
  warnDark(Color(0xFFF5B36B)),

  // Trend-down (spending fell) — verified at line 716/717: the same hue in
  // both themes, `#6EE7B7`. Never reuse `error`/`warn` for this pair.
  trendDown(Color(0xFF6EE7B7)),

  // 12 category hues (design_spendlens.md §18 / binding decision 3).
  // First 6 verified verbatim at line 708 of the prototype.
  categoryFood(Color(0xFFA78BFA)),
  categoryTransport(Color(0xFF67E8F9)),
  categoryHousehold(Color(0xFFF5B36B)),
  categoryRestaurantsCoffee(Color(0xFFF9A8D4)),
  categoryHealth(Color(0xFF6EE7B7)),
  categoryOther(Color(0xFF8E8E93)),

  // Remaining 6 derived by the design's own rule — same lightness (~72.6%)
  // and chroma (~86% saturation) as the 5 saturated hues above, hue rotated
  // to fill the gaps between them. See handoff for the full derivation.
  categoryShopping(Color(0xFFF0F57D)),
  categoryEntertainment(Color(0xFFB2F57D)),
  categoryUtilities(Color(0xFF7DF587)),
  categoryTravel(Color(0xFF7DA3F5)),
  categoryEducation(Color(0xFFE47DF5)),
  categoryPersonalCare(Color(0xFFF57D7E));

  final Color value;

  const AppColors(this.value);
}
