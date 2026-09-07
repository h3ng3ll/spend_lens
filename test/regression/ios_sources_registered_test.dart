import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Every `.swift` file under `ios/Runner/` must be registered in the Xcode
/// project's Sources build phase.
///
/// This gate exists because of an observed defect, not a hypothetical one:
/// `ios/Runner/Ocr/OcrChannel.swift` sat on disk with **zero references** in
/// `project.pbxproj`, so Xcode never compiled it. The iOS OCR platform
/// channel was dead code, and every existing check was blind to it — Dart
/// analyzes clean, the Kotlin side was registered correctly, and the whole
/// Dart suite passes, because **not one test compiles the iOS target**.
///
/// A file is "registered" when it appears both as a `PBXFileReference` and in
/// the target's `Sources` phase. Checking for the filename alone would pass on
/// a file that is referenced but never built, which is the same silent
/// failure in a different costume — so both entries are required.
void main() {
  test('every ios/Runner/**.swift file is compiled by the Xcode target', () {
    final runnerDir = Directory('ios/Runner');
    if (!runnerDir.existsSync()) {
      markTestSkipped('ios/Runner does not exist');
      return;
    }

    final pbxproj = File('ios/Runner.xcodeproj/project.pbxproj');
    expect(
      pbxproj.existsSync(),
      isTrue,
      reason: 'ios/Runner.xcodeproj/project.pbxproj must exist',
    );
    final project = pbxproj.readAsStringSync();

    final swiftFiles = runnerDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.swift'))
        .toList();

    expect(
      swiftFiles,
      isNotEmpty,
      reason: 'expected at least AppDelegate.swift under ios/Runner/',
    );

    final unregistered = <String>[];
    for (final file in swiftFiles) {
      final name = file.uri.pathSegments.last;

      final hasFileRef = RegExp(
        RegExp.escape(name) + r'\s*\*/\s*=\s*\{isa = PBXFileReference',
      ).hasMatch(project);

      // `<name> in Sources */` appears TWICE: once declaring the
      // PBXBuildFile, and once listing it inside the Sources phase. Matching
      // either one is not enough — deleting only the phase membership (the
      // dangerous case: the file looks wired but is never compiled) left this
      // gate GREEN until the two were distinguished. The phase entry is the
      // bare `<uuid> /* <name> in Sources */,` list line, with no `= {isa`.
      final buildFileId = RegExp(
        r'([0-9A-F]{24}) /\* ' + RegExp.escape(name) +
            r' in Sources \*/ = \{isa = PBXBuildFile',
      ).firstMatch(project)?.group(1);

      final inSourcesPhase = buildFileId != null &&
          RegExp(
            r'^\s*' + buildFileId + r' /\* ' + RegExp.escape(name) +
                r' in Sources \*/,\s*$',
            multiLine: true,
          ).hasMatch(project);

      if (!hasFileRef || !inSourcesPhase) {
        unregistered.add(
          '${file.path} — '
          '${hasFileRef ? '' : 'no PBXFileReference; '}'
          '${inSourcesPhase ? '' : 'not in the Sources build phase'}',
        );
      }
    }

    expect(
      unregistered,
      isEmpty,
      reason:
          'These Swift files exist on disk but Xcode will not compile them, '
          'so any platform channel they register is silently dead at runtime '
          'while every Dart-side check stays green:\n${unregistered.join('\n')}',
    );
  });
}
