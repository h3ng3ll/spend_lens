import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// `no_commented_code_rules.md` (global, READ-ONLY) — never comment out
/// code; if it should not run, delete it. This project is a from-scratch
/// build (not the brick template), so there is no grandfathered scaffolding
/// to exempt here — every `//` line in `lib/` is held to the same bar.
///
/// Heuristic (matching the rule's own stated test: "if removing the `//`
/// would make it live code the author wants to run"): a `//`-prefixed line
/// is flagged when its content, with the leading `//` stripped, LOOKS like
/// a Dart statement — it ends with `;`, `{`, or `}`, or opens a call/
/// assignment (`(`/`=`) — AND is not a doc comment (`///`) or a directive
/// comment (`// ignore:`, `// TODO(name):` describing intent rather than
/// code). This intentionally does not attempt a full parse; it is a
/// same-shape heuristic to the project's other regression gates.
void main() {
  test('no line under lib/ is commented-out Dart code', () {
    final dir = Directory('lib');
    final offenders = <String>[];

    final allowedPrefixes = ['///', '// ignore', '//ignore'];

    for (final file in dir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .where((f) => !f.path.endsWith('.g.dart'))
        .where((f) => !f.path.endsWith('.freezed.dart'))) {
      final lines = file.readAsLinesSync();

      for (var i = 0; i < lines.length; i++) {
        final trimmed = lines[i].trim();
        if (!trimmed.startsWith('//')) continue;
        if (allowedPrefixes.any(trimmed.startsWith)) continue;

        final content = trimmed.replaceFirst(RegExp(r'^//+\s?'), '');
        if (content.isEmpty) continue;

        final looksLikeCode = RegExp(
          r'^(final|var|const|return|await|context\.|Navigator\.|'
          r'BlocProvider|GoRoute|import\s|export\s|if\s*\(|for\s*\(|'
          r'void\s+\w+\(|Widget\s+\w+\(|class\s+\w+)',
        ).hasMatch(content);

        final endsLikeStatement =
            content.endsWith(';') || content.endsWith('{') ||
                content.endsWith('}');

        if (looksLikeCode && endsLikeStatement) {
          offenders.add('${file.path}:${i + 1}: $trimmed');
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason: 'These lines look like commented-out code — delete instead '
          'of commenting (no_commented_code_rules.md): $offenders',
    );
  });
}
