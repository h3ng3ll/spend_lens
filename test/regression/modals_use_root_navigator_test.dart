import 'package:flutter_test/flutter_test.dart';

import 'support/source_scanner.dart';

/// Every modal presenter must pass `useRootNavigator: true`.
///
/// `showModalBottomSheet` / `showDialog` default to the NEAREST navigator.
/// Inside the 5-tab shell (`AppShellRoute` → `RootPage`) that is the current
/// `StatefulShellBranch`'s navigator, which sits BELOW `RootPage`'s bottom
/// bar — so the bar paints over the modal's scrim and stays tappable, and
/// the user can switch tabs behind an open sheet or a destructive confirm
/// dialog.
///
/// `useRootNavigator: true` routes the modal through `rootNavigatorKey`,
/// the same navigator every bottom-bar-hiding `GoRoute` already declares as
/// its `parentNavigatorKey`.
///
/// Dismissal is unaffected: each modal pops with `Navigator.of(context)`
/// from inside its own subtree, which resolves to whichever navigator hosts
/// the modal route.
void main() {
  test('every showModalBottomSheet/showDialog passes useRootNavigator: true',
      () {
    final offenders = <String>[];

    for (final file in SourceScanner.libDartFiles()) {
      final stripped = SourceScanner.readStripped(file);

      for (final presenter in const [
        'showModalBottomSheet',
        'showDialog',
      ]) {
        var index = stripped.indexOf(presenter);
        while (index != -1) {
          // The argument list ends at the presenter's matching close paren;
          // scanning to it (rather than a fixed line window) keeps the check
          // robust against however the arguments happen to be wrapped.
          final args = _argumentList(stripped, index);
          if (args != null && !args.contains('useRootNavigator')) {
            offenders.add('${file.path} → $presenter');
          }
          index = stripped.indexOf(presenter, index + presenter.length);
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason: 'These modals mount on the nearest (shell-branch) navigator, '
          'so the bottom bar renders above their scrim and stays tappable. '
          'Pass useRootNavigator: true: $offenders',
    );
  });
}

/// The text between [start]'s first `(` and its matching `)`, or null when
/// the call is not an invocation (e.g. a name inside a doc reference that
/// survived comment stripping).
String? _argumentList(String source, int start) {
  final open = source.indexOf('(', start);
  if (open == -1) return null;

  // Anything other than the generic type argument between the name and the
  // paren means this is not the call itself.
  final between = source.substring(start, open);
  if (between.contains(';') || between.contains('\n\n')) return null;

  var depth = 0;
  for (var i = open; i < source.length; i++) {
    final char = source[i];
    if (char == '(') depth++;
    if (char == ')') {
      depth--;
      if (depth == 0) return source.substring(open, i);
    }
  }
  return null;
}
