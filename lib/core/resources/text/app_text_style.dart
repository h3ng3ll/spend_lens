import 'package:flutter/material.dart';

/// Type scale named by design ROLE, not by size (design_spendlens.md §4.3).
///
/// `fontFamily: null` — Flutter falls back to the platform default (SF Pro
/// on iOS, Roboto on Android), matching the design's own use of the system
/// font stack.
///
/// Every amount-displaying style carries
/// `fontFeatures: [FontFeature.tabularFigures()]` — the design mandates
/// tabular (monospaced-digit) numerals on every amount so totals/columns of
/// figures align.
enum AppTextStyle {
  /// Splash tagline / hero numeral on the most prominent surfaces.
  hero44(
    TextStyle(
      fontSize: 44.0,
      fontWeight: FontWeight.w700,
      height: 1.05,
    ),
  ),

  /// The large currency figure on hero/stat cards (Home's monthly total).
  heroCurrency22(
    TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.w700,
      fontFeatures: [FontFeature.tabularFigures()],
    ),
  ),

  /// Screen-level title (e.g. "Analytics", "Settings").
  screenTitle28(
    TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
      height: 1.15,
    ),
  ),

  /// The large amount on a record-detail screen.
  detailAmount40(
    TextStyle(
      fontSize: 40.0,
      fontWeight: FontWeight.w700,
      fontFeatures: [FontFeature.tabularFigures()],
    ),
  ),

  /// A stat card's headline value (e.g. Average, Purchases count).
  statValue20(
    TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      fontFeatures: [FontFeature.tabularFigures()],
    ),
  ),

  /// Default list-row / section headline text.
  headline17(
    TextStyle(
      fontSize: 17.0,
      fontWeight: FontWeight.w400,
    ),
  ),

  /// Emphasized variant of [headline17] (row titles, primary labels).
  headline17Semi(
    TextStyle(
      fontSize: 17.0,
      fontWeight: FontWeight.w600,
    ),
  ),

  /// Default body copy.
  body17(
    TextStyle(
      fontSize: 17.0,
      fontWeight: FontWeight.w400,
      height: 1.35,
    ),
  ),

  /// Secondary/subhead copy (meta lines, helper text).
  subhead15(
    TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.w500,
    ),
  ),

  /// Footnote / caption text (timestamps, fine print).
  footnote13(
    TextStyle(
      fontSize: 13.0,
      fontWeight: FontWeight.w400,
    ),
  ),

  /// All-caps section labels (e.g. "STORAGE", "CATEGORIES").
  sectionLabel12(
    TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.4,
    ),
  ),

  /// Bottom tab-bar labels.
  tabLabel10(
    TextStyle(
      fontSize: 10.0,
      fontWeight: FontWeight.w600,
    ),
  ),

  /// The large numeric entry field on Cash Expense / amount editors.
  amountInput32(
    TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.w700,
      fontFeatures: [FontFeature.tabularFigures()],
    ),
  );

  final TextStyle value;

  const AppTextStyle(this.value);
}
