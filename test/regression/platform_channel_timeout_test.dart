import 'package:flutter_test/flutter_test.dart';

import 'support/source_scanner.dart';

/// This is the run's THIRD independent occurrence of one defect class:
/// `Apphud.start()` awaited unbounded before `runApp()` froze the app on
/// the native splash forever, then a second, unrelated `availableCameras()`
/// call in `scan_capability_service.dart` did the same to Home's "Scan
/// Receipt" CTA. Both were fixed with a named `.timeout(...)`. This gate
/// exists so a THIRD (or fourth, or fifth) unbounded platform-channel await
/// is caught mechanically instead of being found again, one call site at a
/// time, on a real device with a clean logcat.
///
/// Every `invokeMethod(`/`availableCameras(` call anywhere under `lib/`
/// must have `.timeout(` appear before its statement-terminating `;` — i.e.
/// the awaited expression is bounded, not merely that the word "timeout"
/// exists somewhere later in the file.
///
/// Scoped to `invokeMethod(`/`availableCameras(` specifically (rather than
/// every `await` in the app) because those are the call shapes that proved
/// capable of never settling: a native platform-channel round trip this
/// Dart code cannot otherwise cap. Ordinary Dart-side awaits (Hive reads,
/// bloc-to-bloc calls) are not plugin boundaries and are out of scope here.
/// The call shapes this gate requires a `.timeout(...)` on.
///
/// `invokeMethod`/`availableCameras` are the raw platform-channel shapes.
/// The rest are THIRD-PARTY SDK entry points that tunnel to a native channel
/// internally — so they never contain the literal `invokeMethod` in our
/// source, yet they hang in exactly the same way. Both launch blockers this
/// run were of that second kind: `Apphud.start` (401 → future never settles,
/// froze the native splash) and `GoogleSignIn.initialize` (same shape, found
/// awaited before `runApp()`).
///
/// Scoping the gate to the raw shapes alone left it green while a real
/// `.timeout(...)` was deleted from either of those files — verified by
/// surgically removing one bound per file and re-running. Adding a plugin
/// here is cheaper than rediscovering the hang on a device.
const List<String> _kBoundedCallPatterns = [
  'invokeMethod',
  'availableCameras',
  r'Apphud\.start',
  r'Apphud\.hasPremiumAccess',
  r'\.initialize',
];

void main() {
  test(
    'every platform-channel and native-SDK await in lib/ is .timeout()-bounded',
    () {
      final offenders = <String>[];

      for (final file in SourceScanner.libDartFiles()) {
        final stripped = SourceScanner.readStripped(file);

        for (final pattern in _kBoundedCallPatterns) {
          // NOTE the generic matcher is `[^(]*` and NOT `[^>]*`: the real
          // calls use NESTED generics —
          // `invokeMethod<Map<Object?, Object?>>(` — and `[^>]*` stops at
          // the FIRST `>`, so the pattern matched nothing at all and the
          // gate scanned zero call sites while reporting green. Verified by
          // deleting a real `.timeout(...)` and watching this stay passing.
          for (final match in RegExp('$pattern\\s*(?:<[^(]*>)?\\s*\\(')
              .allMatches(stripped)) {
            final callStart = match.start;
            final statementEnd = _findStatementEnd(stripped, callStart);
            final statement = stripped.substring(callStart, statementEnd);

            if (!statement.contains('.timeout(')) {
              final line =
                  stripped.substring(0, callStart).split('\n').length;
              offenders.add('${file.path}:$line — $pattern(...) has no '
                  '.timeout(...) on its statement');
            }
          }
        }
      }

      expect(
        offenders,
        isEmpty,
        reason:
            'Every platform-channel call (invokeMethod/availableCameras) '
            'must be .timeout()-bounded — an unbounded native await can '
            'hang with a clean logcat and no exception '
            '(sig:unbounded-third-party-sdk-await-before-runapp-hangs-'
            'first-frame). Offenders:\n${offenders.join('\n')}',
      );
    },
  );
}

/// Returns the index just after the first top-level (paren-depth-0,
/// bracket-depth-0) `;` found starting from [from] — i.e. the end of the
/// statement that the call at [from] participates in. Good enough for the
/// already comment/string-stripped source these gates scan.
/// Scans forward from the START of the matched call (not its end) to the
/// `;` that terminates the statement it lives in.
///
/// ⚠️ Starting at `match.end` is WRONG and silently defeats this gate: the
/// call's own opening `(` is then never counted, so `parenDepth` goes
/// NEGATIVE at the call's closing `)` and the very next `;` — often on an
/// earlier line than a cascaded `.timeout(...)` — looks like the statement
/// end. A multi-line
///
///     await _channel
///         .invokeMethod<T>('x', {...})
///         .timeout(_kSomeTimeout);
///
/// then reads as unbounded-but-passing. Verified: removing that
/// `.timeout(...)` left this gate GREEN until the scan was anchored here.
int _findStatementEnd(String source, int from) {
  var parenDepth = 0;
  var bracketDepth = 0;
  var braceDepth = 0;
  for (var i = from; i < source.length; i++) {
    final c = source[i];
    if (c == '(') parenDepth++;
    if (c == ')') parenDepth--;
    if (c == '[') bracketDepth++;
    if (c == ']') bracketDepth--;
    if (c == '{') braceDepth++;
    if (c == '}') braceDepth--;
    if (c == ';' &&
        parenDepth <= 0 &&
        bracketDepth <= 0 &&
        braceDepth <= 0) {
      return i + 1;
    }
  }
  return source.length;
}
