import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/hive/enum_adapters.dart';
import 'package:spend_lens/core/hive/hive_adapters.dart';

/// design_spendlens.md §3 / §11 — Hive typeIds are pinned as literals so a
/// `build_runner` regeneration can never silently renumber a stored
/// adapter. The FULL, authoritative assertion set already lives in
/// `test/core/hive/hive_type_ids_test.dart` (kept as-is, per the M10
/// instruction not to move it) — this file is a thin re-assertion of the
/// same invariant so the pipeline's `flutter test test/regression/
/// test/screenshots/` gate actually exercises it (that gate does not scan
/// `test/core/`).
void main() {
  group('Hive typeIds are pinned (regression-gate mirror)', () {
    test('generated model adapters occupy 0-7', () {
      expect(AppSettingsAdapter().typeId, 0);
      expect(ReceiptAdapter().typeId, 1);
      expect(ReceiptItemAdapter().typeId, 2);
      expect(ProductAdapter().typeId, 3);
      expect(StoreAdapter().typeId, 4);
      expect(CategoryAdapter().typeId, 5);
      expect(ExpenseAdapter().typeId, 6);
      expect(PriceObservationAdapter().typeId, 7);
    });

    test('manual enum adapters occupy >= 100 and never collide', () {
      final enumTypeIds = <int>[
        EAppThemeModeAdapter().typeId,
        ESyncStatusAdapter().typeId,
        EUnitAdapter().typeId,
        EStoreTypeAdapter().typeId,
        EExpenseSourceAdapter().typeId,
        EFlashModeAdapter().typeId,
      ];

      for (final id in enumTypeIds) {
        expect(id, greaterThanOrEqualTo(100));
      }
      expect(enumTypeIds.toSet().length, enumTypeIds.length);
    });
  });
}
