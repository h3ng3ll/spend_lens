import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// design_spendlens.md §9 bug 9 / §11 — every bloc's `*_state.dart` must
/// have a sibling `*_state_ext.dart` with boolean status getters covering
/// ALL status enum values, minimum `isLoading`/`isFailed`/
/// `isReady`/`isSuccess`.
///
/// Scoped to REAL bloc state files — identified structurally as files whose
/// first non-blank line is `part of '..._bloc.dart';` — because several
/// files under `lib/` are coincidentally named `*_state.dart` while being
/// plain widgets (`app_empty_state.dart`, `history_empty_state.dart`,
/// `history_filter_miss_state.dart`), not bloc state parts.
void main() {
  test('every bloc *_state.dart has a sibling *_state_ext.dart', () {
    final dir = Directory('lib');
    if (!dir.existsSync()) return;

    final stateFiles = dir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('_state.dart'))
        .where((f) => !f.path.endsWith('.g.dart'))
        .toList();

    final missing = <String>[];
    for (final file in stateFiles) {
      final firstMeaningfulLine = file
          .readAsLinesSync()
          .map((l) => l.trim())
          .firstWhere((l) => l.isNotEmpty, orElse: () => '');

      final isBlocStatePart =
          RegExp(r"^part of '.*_bloc\.dart';$").hasMatch(firstMeaningfulLine);
      if (!isBlocStatePart) continue;

      final extPath = file.path.replaceFirst(
        RegExp(r'_state\.dart$'),
        '_state_ext.dart',
      );
      if (!File(extPath).existsSync()) {
        missing.add(file.path);
      }
    }

    expect(
      missing,
      isEmpty,
      reason: 'These bloc state files have no sibling _state_ext.dart: '
          '$missing',
    );
  });

  test('every *_state_ext.dart declares isLoading and isFailed getters', () {
    final dir = Directory('lib');
    if (!dir.existsSync()) return;

    final extFiles = dir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('_state_ext.dart'))
        .toList();

    final offenders = <String>[];
    for (final file in extFiles) {
      final source = file.readAsStringSync();
      final hasLoading = source.contains('isLoading');
      final hasFailed = source.contains('isFailed');
      final hasReadyOrSuccess =
          source.contains('isReady') || source.contains('isSuccess');

      if (!hasLoading || !hasFailed || !hasReadyOrSuccess) {
        offenders.add(file.path);
      }
    }

    expect(
      offenders,
      isEmpty,
      reason: 'These _state_ext.dart files are missing one of '
          'isLoading/isFailed/isReady|isSuccess: $offenders',
    );
  });
}
