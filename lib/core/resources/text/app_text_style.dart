import 'package:flutter/material.dart';

/// M1 minimal type scale, sized by number (matching sinergy_hub's own naming),
/// with the template bug fixed: `medium12` now carries `fontSize: 12`, not the
/// wrong `10` (design_spendlens.md §9 bug 7).
///
/// M2 replaces this with the design-role-named scale from §4.3
/// (`hero44`, `screenTitle28`, `amountInput32`, ...), `fontFamily: null` (SF
/// Pro / Roboto), and `fontFeatures: [FontFeature.tabularFigures()]` on every
/// amount style.
enum AppTextStyle {
  regular12(
    TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  ),
  regular14(
    TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  ),
  medium12(
    TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
  ),
  medium14(
    TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),
  bold20(
    TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
  );

  final TextStyle value;

  const AppTextStyle(this.value);
}
