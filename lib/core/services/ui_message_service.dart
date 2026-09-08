import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import '../widgets/app_toast.dart';

/// App-wide toast messaging.
///
/// design_spendlens.md §4.5 / §9 bug: this is a FULL rewrite of the
/// template's `UiMessageService`, which wrapped `fluttertoast` (a package
/// this project deliberately never depends on — `SnackBar` /
/// `ScaffoldMessenger` are equally forbidden) and carried dead
/// commented-out code. The rewrite is a navigator-key-backed `OverlayEntry`
/// with a single-entry queue, keeping the exact static API
/// (`showError`/`showInfo`/`showSuccess`) so call sites never change.
///
/// M5 renders the designed `core/widgets/app_toast.dart` (44 dp pill,
/// gradient dot, 24 px backdrop blur, 2200 ms) — the message content is the
/// only thing that varies between `showError`/`showInfo`/`showSuccess`; the
/// design carries no separate error/success color variant for the pill
/// itself (verified: `SpendLens Prototype.dc.html`'s "TOAST" block has a
/// single fixed `--toastbg`/`--toastink` pair, never a per-severity color).
final class UiMessageService {
  UiMessageService._();

  static const Duration _defaultDuration = Duration(milliseconds: 2200);

  static GlobalKey<NavigatorState>? _navigatorKey;
  static OverlayEntry? _currentEntry;

  /// Must be called once, with the app's root navigator key, before any
  /// `show*` call (typically wired to `MaterialApp.router`'s
  /// `navigatorKey`).
  static void attach(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  static Future<void> showError(
    String message, {
    Duration duration = _defaultDuration,
  }) async {
    _show(message, duration: duration);
  }

  static Future<void> showInfo(
    String message, {
    Duration duration = _defaultDuration,
  }) async {
    _show(message, duration: duration);
  }

  static Future<void> showSuccess(
    String message, {
    Duration duration = _defaultDuration,
  }) async {
    _show(message, duration: duration);
  }

  static void _show(String message, {required Duration duration}) {
    final overlayState = _navigatorKey?.currentState?.overlay;
    if (overlayState == null) {
      // R2-7 hardening: a dropped toast must never be silent. This was
      // previously a bare `return` — indistinguishable, from the outside,
      // from a toast that fired and was simply not observed. Logged, never
      // thrown: a missing overlay must not crash the caller that only
      // wanted to notify the user.
      developer.log(
        'UiMessageService: dropped "$message" — no attached overlay '
        '(attach() not yet called, or the navigator has no overlay).',
        level: 900,
        name: 'App',
      );
      return;
    }

    _currentEntry?.remove();

    final entry = OverlayEntry(
      builder: (context) => AppToast(message: message),
    );
    _currentEntry = entry;
    overlayState.insert(entry);

    Future.delayed(duration, () {
      // Guarded on `identical`, NOT unconditional: a second toast within
      // `duration` already removed this entry at the `_currentEntry?.remove()`
      // above, and `OverlayEntry.remove()` asserts the entry is still
      // installed — so removing it again crashed in debug. Two toasts in
      // quick succession is ordinary (a tap that both fails a check and
      // reports why), not an edge case.
      if (!identical(_currentEntry, entry)) return;
      entry.remove();
      _currentEntry = null;
    });
  }
}
