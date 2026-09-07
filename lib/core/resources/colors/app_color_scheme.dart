import 'package:flutter/material.dart';

import 'app_colors.dart';

/// App color scheme (design_spendlens.md §4.2).
///
/// ~26 semantic fields mapped 1:1 to the two verified CSS token strings in
/// `assets/SpendLens design system/SpendLens Prototype.dc.html` — light at
/// line 779, dark at line 780. Both `.light()` and `.dark()` are real,
/// distinct palettes (template bug fixed: the old dark factory was an
/// all-white stub); `of()` throws a plain English message, not Russian
/// (§9 bug 8).
///
/// `trendUp` / `trendDown` are their OWN semantic pair — never reuse `error`.
/// Design rule verified at line 716/717: amber (`--warn`) when spending rose,
/// green (`#6EE7B7`, identical in both themes) when it fell. Never red.
@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  // ── Surfaces ──────────────────────────────────────────────────────────
  /// `--bg` — the app background, behind all scrollable content.
  final Color bg;

  /// `--card` — translucent card fill (glass cards over the background glow).
  final Color card;

  /// `--card-solid` — opaque card fill, used where a card must not show the
  /// background glow through it.
  final Color cardSolid;

  /// `--sheet` — bottom sheet / modal surface.
  final Color sheet;

  // ── Hairlines / dividers ─────────────────────────────────────────────
  /// `--line` — the default hairline/divider.
  final Color line;

  /// `--line2` — a slightly stronger hairline (card borders).
  final Color line2;

  // ── Form fields ──────────────────────────────────────────────────────
  /// `--field` — default input/field fill.
  final Color field;

  /// `--field2` — a stronger field fill (e.g. the active tab/segment).
  final Color field2;

  /// `--field-dim` — the dimmest field fill (rarely-emphasized rows).
  final Color fieldDim;

  // ── Text ─────────────────────────────────────────────────────────────
  /// `--ink` — primary on-surface text.
  final Color ink;

  /// `--sec` — secondary text.
  final Color sec;

  /// `--ter` — tertiary text (meta lines, hints).
  final Color ter;

  /// `--dim` — dimmed/disabled text.
  final Color dim;

  /// `--onaccent` — text/icon painted on top of a SOLID accent fill.
  final Color onAccent;

  // ── Chrome ───────────────────────────────────────────────────────────
  /// `--bar` — the translucent tab-bar / bottom-pill background.
  final Color bar;

  /// `--toastbg` — the toast pill background.
  final Color toastBg;

  /// `--toastink` — the toast pill text/icon color.
  final Color toastInk;

  // ── Accent / brand ───────────────────────────────────────────────────
  /// `--accent` — the primary brand accent (violet family).
  final Color accent;

  /// `--accent2` — the secondary brand accent (teal/cyan family).
  final Color accent2;

  /// `--accent-tint` — `accent` at low alpha, for selected-wash fills.
  final Color accentTint;

  /// `--accent-line` — `accent` at a stronger alpha, for a wash's border.
  final Color accentLine;

  /// `--accent2-tint` — `accent2` at low alpha, for selected-wash fills.
  final Color accent2Tint;

  // ── Warn / trend ─────────────────────────────────────────────────────
  /// `--warn` — destructive actions AND trend-up (spending rose). Amber, not
  /// red — never confuse with `error` semantics.
  final Color warn;

  /// `--warn-tint` — `warn` at low alpha.
  final Color warnTint;

  /// Trend-up text color (spending rose this period). Equal to [warn] but
  /// kept as its own field per design_spendlens.md §4.2 — never reuse
  /// [error] for a spending increase.
  final Color trendUp;

  /// Trend-down text color (spending fell this period). `#6EE7B7`, identical
  /// in both themes (verified at line 716/717).
  final Color trendDown;

  // ── Status ───────────────────────────────────────────────────────────
  /// Semantic error color. Distinct from [warn]: [warn] is the destructive/
  /// trend-up brand token, [error] is reserved for genuine failure states
  /// (form validation, network errors) so the two vocabularies never merge.
  final Color error;

  /// The color of content painted on top of [error].
  final Color onError;

  const AppColorScheme._({
    required this.bg,
    required this.card,
    required this.cardSolid,
    required this.sheet,
    required this.line,
    required this.line2,
    required this.field,
    required this.field2,
    required this.fieldDim,
    required this.ink,
    required this.sec,
    required this.ter,
    required this.dim,
    required this.onAccent,
    required this.bar,
    required this.toastBg,
    required this.toastInk,
    required this.accent,
    required this.accent2,
    required this.accentTint,
    required this.accentLine,
    required this.accent2Tint,
    required this.warn,
    required this.warnTint,
    required this.trendUp,
    required this.trendDown,
    required this.error,
    required this.onError,
  });

  /// Light theme — CSS token string verified at
  /// `SpendLens Prototype.dc.html` line 779.
  factory AppColorScheme.light() {
    const ink = AppColors.inkLight;
    const accent = AppColors.accentLight;
    const accent2 = AppColors.accent2Light;
    const warn = AppColors.warnLight;

    return AppColorScheme._(
      bg: AppColors.bgLight.value,
      card: AppColors.white.value.withValues(alpha: 0.78),
      cardSolid: AppColors.cardSolidLight.value,
      sheet: AppColors.sheetLight.value,
      line: ink.value.withValues(alpha: 0.08),
      line2: ink.value.withValues(alpha: 0.12),
      field: ink.value.withValues(alpha: 0.06),
      field2: ink.value.withValues(alpha: 0.12),
      fieldDim: ink.value.withValues(alpha: 0.03),
      ink: ink.value,
      sec: AppColors.secLight.value,
      ter: AppColors.terLight.value,
      dim: AppColors.dimLight.value,
      onAccent: AppColors.onAccentLight.value,
      bar: AppColors.white.value.withValues(alpha: 0.78),
      toastBg: ink.value.withValues(alpha: 0.92),
      toastInk: AppColors.toastInkLight.value,
      accent: accent.value,
      accent2: accent2.value,
      accentTint: accent.value.withValues(alpha: 0.10),
      accentLine: accent.value.withValues(alpha: 0.3),
      accent2Tint: accent2.value.withValues(alpha: 0.10),
      warn: warn.value,
      warnTint: warn.value.withValues(alpha: 0.10),
      trendUp: warn.value,
      trendDown: AppColors.trendDown.value,
      error: warn.value,
      onError: AppColors.white.value,
    );
  }

  /// Dark theme — CSS token string verified at
  /// `SpendLens Prototype.dc.html` line 780.
  factory AppColorScheme.dark() {
    const ink = AppColors.inkDark;
    const accent = AppColors.accentDark;
    const accent2 = AppColors.accent2Dark;
    const warn = AppColors.warnDark;

    return AppColorScheme._(
      bg: AppColors.bgDark.value,
      card: AppColors.white.value.withValues(alpha: 0.06),
      cardSolid: AppColors.cardSolidDark.value,
      sheet: AppColors.sheetDark.value,
      line: AppColors.white.value.withValues(alpha: 0.11),
      line2: AppColors.white.value.withValues(alpha: 0.12),
      field: AppColors.white.value.withValues(alpha: 0.08),
      field2: AppColors.white.value.withValues(alpha: 0.14),
      fieldDim: AppColors.white.value.withValues(alpha: 0.03),
      ink: ink.value,
      sec: AppColors.secDark.value,
      ter: AppColors.terDark.value,
      dim: AppColors.dimDark.value,
      onAccent: AppColors.onAccentDark.value,
      bar: AppColors.cardSolidDark.value.withValues(alpha: 0.7),
      toastBg: AppColors.cardSolidDark.value.withValues(alpha: 0.92),
      toastInk: AppColors.toastInkDark.value,
      accent: accent.value,
      accent2: accent2.value,
      accentTint: accent.value.withValues(alpha: 0.14),
      accentLine: accent.value.withValues(alpha: 0.3),
      accent2Tint: accent2.value.withValues(alpha: 0.14),
      warn: warn.value,
      warnTint: warn.value.withValues(alpha: 0.14),
      trendUp: warn.value,
      trendDown: AppColors.trendDown.value,
      error: warn.value,
      onError: AppColors.bgDark.value,
    );
  }

  /// Resolves a category's hue by its id.
  ///
  /// A built-in [Category]'s `id`/`name` is the i18n key it was seeded with
  /// (`SeedCategoriesUseCase` sets `id: nameKey`, e.g. `'catFood'`) — NOT the
  /// English display string. This resolver accepts BOTH forms:
  /// - the `catXxx` seed-key form (`'catFood'`, `'catRestaurantsCoffee'`, …),
  ///   which is what every built-in [Category.id] actually is, and
  /// - the English canonical form (`'Food'`, `'Restaurants & Coffee'`,
  ///   `'Restaurants'`), kept for any caller that already resolved a display
  ///   name before reaching here.
  ///
  /// Recorded defect (found during M5): every `catXxx`-keyed lookup used to
  /// fall through to the `default` branch and silently render
  /// [AppColors.categoryOther] for all 12 built-in categories — this method
  /// is the fix, not a new feature. A custom (user-created) category's id is
  /// never one of these keys and correctly falls through to the same
  /// catch-all, matching the design's own fallback.
  static Color categoryColor(String categoryId) {
    switch (categoryId) {
      case 'catFood':
      case 'Food':
        return AppColors.categoryFood.value;
      case 'catTransport':
      case 'Transport':
        return AppColors.categoryTransport.value;
      case 'catHousehold':
      case 'Household':
        return AppColors.categoryHousehold.value;
      case 'catRestaurantsCoffee':
      case 'Restaurants & Coffee':
      case 'Restaurants':
        return AppColors.categoryRestaurantsCoffee.value;
      case 'catHealth':
      case 'Health':
        return AppColors.categoryHealth.value;
      case 'catShopping':
      case 'Shopping':
        return AppColors.categoryShopping.value;
      case 'catEntertainment':
      case 'Entertainment':
        return AppColors.categoryEntertainment.value;
      case 'catUtilities':
      case 'Utilities':
        return AppColors.categoryUtilities.value;
      case 'catTravel':
      case 'Travel':
        return AppColors.categoryTravel.value;
      case 'catEducation':
      case 'Education':
        return AppColors.categoryEducation.value;
      case 'catPersonalCare':
      case 'Personal Care':
        return AppColors.categoryPersonalCare.value;
      case 'catOther':
      case 'Other':
      default:
        return AppColors.categoryOther.value;
    }
  }

  /// The single normalized brand gradient (135°, `#C4B5FD → #8EE3F5`),
  /// exposed here (rather than only in `AppGradients`) so screens reading
  /// `AppColorScheme.of(context)` can theme-vary it if a future design
  /// revision ever wants a light-mode variant.
  LinearGradient get accentGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.accentDark.value, AppColors.accent2Dark.value],
      );

  /// The design's radial background glow layers (verified at line 778/779 —
  /// `--glow`), expressed as stacked [BoxShadow]-free radial gradients a
  /// screen composes behind its content. Kept theme-aware: the dark glow is
  /// stronger (28%/16% alpha) than the light glow (16%/12% alpha).
  List<Color> get glowLayers => [
        AppColors.accentDark.value,
        AppColors.accent2Dark.value,
      ];

  @override
  AppColorScheme copyWith({
    Color? bg,
    Color? card,
    Color? cardSolid,
    Color? sheet,
    Color? line,
    Color? line2,
    Color? field,
    Color? field2,
    Color? fieldDim,
    Color? ink,
    Color? sec,
    Color? ter,
    Color? dim,
    Color? onAccent,
    Color? bar,
    Color? toastBg,
    Color? toastInk,
    Color? accent,
    Color? accent2,
    Color? accentTint,
    Color? accentLine,
    Color? accent2Tint,
    Color? warn,
    Color? warnTint,
    Color? trendUp,
    Color? trendDown,
    Color? error,
    Color? onError,
  }) {
    return AppColorScheme._(
      bg: bg ?? this.bg,
      card: card ?? this.card,
      cardSolid: cardSolid ?? this.cardSolid,
      sheet: sheet ?? this.sheet,
      line: line ?? this.line,
      line2: line2 ?? this.line2,
      field: field ?? this.field,
      field2: field2 ?? this.field2,
      fieldDim: fieldDim ?? this.fieldDim,
      ink: ink ?? this.ink,
      sec: sec ?? this.sec,
      ter: ter ?? this.ter,
      dim: dim ?? this.dim,
      onAccent: onAccent ?? this.onAccent,
      bar: bar ?? this.bar,
      toastBg: toastBg ?? this.toastBg,
      toastInk: toastInk ?? this.toastInk,
      accent: accent ?? this.accent,
      accent2: accent2 ?? this.accent2,
      accentTint: accentTint ?? this.accentTint,
      accentLine: accentLine ?? this.accentLine,
      accent2Tint: accent2Tint ?? this.accent2Tint,
      warn: warn ?? this.warn,
      warnTint: warnTint ?? this.warnTint,
      trendUp: trendUp ?? this.trendUp,
      trendDown: trendDown ?? this.trendDown,
      error: error ?? this.error,
      onError: onError ?? this.onError,
    );
  }

  @override
  AppColorScheme lerp(
    ThemeExtension<AppColorScheme>? other,
    double t,
  ) {
    if (other is! AppColorScheme) return this;

    return copyWith(
      bg: Color.lerp(bg, other.bg, t),
      card: Color.lerp(card, other.card, t),
      cardSolid: Color.lerp(cardSolid, other.cardSolid, t),
      sheet: Color.lerp(sheet, other.sheet, t),
      line: Color.lerp(line, other.line, t),
      line2: Color.lerp(line2, other.line2, t),
      field: Color.lerp(field, other.field, t),
      field2: Color.lerp(field2, other.field2, t),
      fieldDim: Color.lerp(fieldDim, other.fieldDim, t),
      ink: Color.lerp(ink, other.ink, t),
      sec: Color.lerp(sec, other.sec, t),
      ter: Color.lerp(ter, other.ter, t),
      dim: Color.lerp(dim, other.dim, t),
      onAccent: Color.lerp(onAccent, other.onAccent, t),
      bar: Color.lerp(bar, other.bar, t),
      toastBg: Color.lerp(toastBg, other.toastBg, t),
      toastInk: Color.lerp(toastInk, other.toastInk, t),
      accent: Color.lerp(accent, other.accent, t),
      accent2: Color.lerp(accent2, other.accent2, t),
      accentTint: Color.lerp(accentTint, other.accentTint, t),
      accentLine: Color.lerp(accentLine, other.accentLine, t),
      accent2Tint: Color.lerp(accent2Tint, other.accent2Tint, t),
      warn: Color.lerp(warn, other.warn, t),
      warnTint: Color.lerp(warnTint, other.warnTint, t),
      trendUp: Color.lerp(trendUp, other.trendUp, t),
      trendDown: Color.lerp(trendDown, other.trendDown, t),
      error: Color.lerp(error, other.error, t),
      onError: Color.lerp(onError, other.onError, t),
    );
  }

  /// Returns the color scheme for the app from [context].
  static AppColorScheme of(BuildContext context) =>
      Theme.of(context).extension<AppColorScheme>() ??
      (throw Exception('AppColorScheme not found in the current theme'));
}
