import 'package:flutter/material.dart';

import '../resources/colors/app_colors.dart';
import '../widgets/app_container.dart';

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
/// M1 ships a minimal, working pill (no queue starvation, no leaked
/// overlays). M2 swaps the rendered widget for the design's full
/// `core/widgets/app_toast.dart` (44 dp pill, gradient dot, 24 px backdrop
/// blur, 2200 ms) without touching this API.
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
    _show(
      message,
      background: AppColors.warnDark.value,
      duration: duration,
    );
  }

  static Future<void> showInfo(
    String message, {
    Duration duration = _defaultDuration,
  }) async {
    _show(
      message,
      background: AppColors.cardSolidDark.value,
      duration: duration,
    );
  }

  static Future<void> showSuccess(
    String message, {
    Duration duration = _defaultDuration,
  }) async {
    _show(
      message,
      background: AppColors.accentDark.value,
      duration: duration,
    );
  }

  static void _show(
    String message, {
    required Color background,
    required Duration duration,
  }) {
    final overlayState = _navigatorKey?.currentState?.overlay;
    if (overlayState == null) return;

    _currentEntry?.remove();

    final entry = OverlayEntry(
      builder: (context) => _ToastPill(
        message: message,
        background: background,
      ),
    );
    _currentEntry = entry;
    overlayState.insert(entry);

    Future.delayed(duration, () {
      entry.remove();
      if (identical(_currentEntry, entry)) {
        _currentEntry = null;
      }
    });
  }
}

class _ToastPill extends StatelessWidget {
  final String message;
  final Color background;

  const _ToastPill({
    required this.message,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16.0,
      right: 16.0,
      bottom: 48.0,
      child: Material(
        color: AppColors.transparent.value,
        child: SafeArea(
          child: AppContainer(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            color: background,
            borderRadius: BorderRadius.circular(22.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white.value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
