import 'package:flutter_test/flutter_test.dart';

import 'support/source_scanner.dart';

/// `Positioned` is a `ParentDataWidget`: it hands `StackParentData` to the
/// render object DIRECTLY above it. Any widget between it and its `Stack`
/// breaks that relationship and the frame throws
/// "Incorrect use of ParentDataWidget" — every tick, for as long as the
/// subtree is mounted.
///
/// Recorded regression (`ScannerScanLine`): the sweep line built
/// `IgnorePointer > LayoutBuilder > AnimatedBuilder > Positioned` while
/// sitting directly in `CameraPreviewLayer`'s `Stack`. `LayoutBuilder`'s
/// render box accepts only `BoxParentData`, so the scanner spewed the
/// assertion on every animation frame. `flutter analyze` cannot see this —
/// it is a runtime parent-data contract, not a type error — which is why it
/// needs a source gate.
///
/// The check is deliberately narrow: it flags a `Positioned` that is
/// LEXICALLY ENCLOSED by one of the wrapper widgets below with no
/// intervening `Stack`. A `Positioned` inside a builder that opens its own
/// `Stack` first is correct and must not be flagged (e.g.
/// `price_history_chart.dart`, where a `LayoutBuilder` returns a `Stack`
/// whose children are `Positioned`).
void main() {
  test('no Positioned separated from its Stack by a wrapper widget', () {
    // Widgets that introduce their own render object or builder callback,
    // and so cannot pass StackParentData through to a Stack above them.
    const breakers = [
      'LayoutBuilder',
      'AnimatedBuilder',
      'IgnorePointer',
      'ValueListenableBuilder',
      'SafeArea',
      'Padding',
      'Center',
      'Align',
      'Opacity',
      'Transform',
    ];

    final offenders = <String>[];

    for (final file in SourceScanner.libDartFiles()) {
      final src = SourceScanner.readStripped(file);

      for (final match in RegExp(r'\bPositioned(?:\.fill)?\s*\(').allMatches(src)) {
        final head = src.substring(0, match.start);

        for (final breaker in breakers) {
          final open = head.lastIndexOf('$breaker(');
          if (open == -1) continue;

          final between = head.substring(open);
          // Still lexically inside that breaker's argument list?
          final depth = _countChar(between, '(') - _countChar(between, ')');
          if (depth <= 0) continue;

          // A Stack opened after the breaker re-establishes the contract.
          final stack = head.lastIndexOf('Stack(');
          if (stack > open) {
            final afterStack = head.substring(stack);
            final stackDepth =
                _countChar(afterStack, '(') - _countChar(afterStack, ')');
            if (stackDepth > 0) continue;
          }

          final line = _countChar(head, '\n') + 1;
          offenders.add(
            '${file.path}:$line — Positioned nested inside $breaker '
            'with no intervening Stack',
          );
          break;
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'Positioned must be a DIRECT child of its Stack. Move the wrapper '
          'inside the Positioned, or give the subtree its own Stack:\n'
          '${offenders.join('\n')}',
    );
  });
}

int _countChar(String source, String char) =>
    source.split(char).length - 1;
