import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/models/e_sync_status.dart';
import 'package:spend_lens/core/resources/colors/app_color_scheme.dart';
import 'package:spend_lens/core/resources/localization/gen/app_localizations_en.dart';
import 'package:spend_lens/core/services/sync_status_presenter/sync_status_presenter.dart';

void main() {
  const presenter = SyncStatusPresenter();
  final lo = AppLocalizationsEn();
  final scheme = AppColorScheme.dark();

  test('every status maps to a label and a colour', () {
    // Exhaustive on purpose: a new ESyncStatus value must not be able to
    // reach the UI as a blank badge.
    for (final status in ESyncStatus.values) {
      expect(presenter.label(status, lo), isNotEmpty, reason: '$status');
      expect(presenter.color(status, scheme), isNotNull, reason: '$status');
    }
  });

  test('pendingCreate and pendingUpdate read the same to the user', () {
    expect(
      presenter.label(ESyncStatus.pendingUpdate, lo),
      presenter.label(ESyncStatus.pendingCreate, lo),
    );
  });

  test('settled and in-flight are visually distinct', () {
    expect(
      presenter.color(ESyncStatus.synced, scheme),
      isNot(presenter.color(ESyncStatus.pendingCreate, scheme)),
    );
  });

  test('synced does not borrow the analytics trend colour', () {
    // `trendDown` means "spending fell" — reusing it here would give one
    // token two unrelated meanings.
    expect(
      presenter.color(ESyncStatus.synced, scheme),
      isNot(scheme.trendDown),
    );
  });
}
