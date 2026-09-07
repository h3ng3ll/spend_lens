import 'dart:io';

/// Shared source-scanning helpers for `test/regression/`.
///
/// Every regression gate here reads real source files and pattern-matches
/// them — there is no golden/widget rendering involved, so these tests run
/// with no codegen and no device. Comments are ALWAYS stripped before
/// matching (see [stripCommentsAndStrings]): a forbidden pattern quoted in a
/// doc comment to document why it's forbidden must never trip the same scan
/// that looks for the real thing (`no_commented_code_rules.md` — this is the
/// documented, intentional reason comments are invisible to these gates, not
/// an oversight to "fix").
class SourceScanner {
  const SourceScanner._();

  /// All `.dart` files under `lib/`, excluding generated output
  /// (`*.g.dart`, `*.freezed.dart`) and the localization codegen under
  /// `resources/localization/gen/`.
  static List<File> libDartFiles({String root = 'lib'}) {
    final dir = Directory(root);
    if (!dir.existsSync()) return const [];

    return dir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .where((f) => !f.path.endsWith('.g.dart'))
        .where((f) => !f.path.endsWith('.freezed.dart'))
        .where((f) => !f.path.contains('resources/localization/gen/'))
        .toList();
  }

  /// Strips `//` line comments, `/* */` block comments, and string-literal
  /// contents from [source], so a pattern-scan never matches text that is
  /// documentation or a quoted example rather than live code.
  ///
  /// This is deliberately simple (not a full Dart lexer) — good enough for
  /// grep-shaped checks, matching the same tradeoff the project's other
  /// regression suites make.
  static String stripCommentsAndStrings(String source) {
    final buffer = StringBuffer();
    var i = 0;
    final len = source.length;
    while (i < len) {
      final c = source[i];
      final next = i + 1 < len ? source[i + 1] : '';

      // Line comment.
      if (c == '/' && next == '/') {
        while (i < len && source[i] != '\n') {
          i++;
        }
        continue;
      }

      // Block comment (non-nesting; sufficient for this codebase).
      if (c == '/' && next == '*') {
        i += 2;
        while (i < len && !(source[i] == '*' &&
            i + 1 < len &&
            source[i + 1] == '/')) {
          i++;
        }
        i += 2;
        continue;
      }

      // Triple-quoted strings (raw or not) — consume and skip content.
      if (source.startsWith("'''", i) || source.startsWith('"""', i)) {
        final quote = source.substring(i, i + 3);
        i += 3;
        while (i < len && !source.startsWith(quote, i)) {
          i++;
        }
        i += 3;
        buffer.write(' ');
        continue;
      }

      // Single-line string literal.
      if (c == "'" || c == '"') {
        final quote = c;
        i++;
        while (i < len && source[i] != quote) {
          if (source[i] == r'\' && i + 1 < len) {
            i += 2;
          } else {
            i++;
          }
        }
        i++;
        buffer.write(' ');
        continue;
      }

      buffer.write(c);
      i++;
    }
    return buffer.toString();
  }

  /// Reads [file] and returns its comment/string-stripped source.
  static String readStripped(File file) =>
      stripCommentsAndStrings(file.readAsStringSync());
}
