import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/hive/enum_adapters.dart';
import 'package:spend_lens/core/hive/hive_adapters.dart';

/// Pins every Hive typeId as a LITERAL (hive_rules.md rule 3 /
/// design_spendlens.md §3 / §10).
///
/// A regeneration that silently renumbers any of these corrupts already
/// stored data — `hive_ce_generator` assigns model typeIds by DECLARATION
/// ORDER in `@GenerateAdapters([...])`, so reordering that list (even
/// without adding/removing an entry) would renumber every adapter after the
/// moved one. This test is the tripwire: it fails the moment any typeId
/// drifts from the values below, both in the runtime `TypeAdapter.typeId`
/// getters AND in the committed `hive_adapters.g.yaml` mapping.
void main() {
  group('model adapter typeIds (auto-generated, 0-7)', () {
    test('AppSettingsAdapter is typeId 0', () {
      expect(AppSettingsAdapter().typeId, 0);
    });

    test('ReceiptAdapter is typeId 1', () {
      expect(ReceiptAdapter().typeId, 1);
    });

    test('ReceiptItemAdapter is typeId 2', () {
      expect(ReceiptItemAdapter().typeId, 2);
    });

    test('ProductAdapter is typeId 3', () {
      expect(ProductAdapter().typeId, 3);
    });

    test('StoreAdapter is typeId 4', () {
      expect(StoreAdapter().typeId, 4);
    });

    test('CategoryAdapter is typeId 5', () {
      expect(CategoryAdapter().typeId, 5);
    });

    test('ExpenseAdapter is typeId 6', () {
      expect(ExpenseAdapter().typeId, 6);
    });

    test('PriceObservationAdapter is typeId 7', () {
      expect(PriceObservationAdapter().typeId, 7);
    });
  });

  group('enum adapter typeIds (manual, >= 100)', () {
    test('EAppThemeModeAdapter is typeId 100', () {
      expect(EAppThemeModeAdapter().typeId, 100);
    });

    test('ESyncStatusAdapter is typeId 101', () {
      expect(ESyncStatusAdapter().typeId, 101);
    });

    test('EUnitAdapter is typeId 102', () {
      expect(EUnitAdapter().typeId, 102);
    });

    test('EStoreTypeAdapter is typeId 103', () {
      expect(EStoreTypeAdapter().typeId, 103);
    });

    test('EExpenseSourceAdapter is typeId 104', () {
      expect(EExpenseSourceAdapter().typeId, 104);
    });

    test('EFlashModeAdapter is typeId 105', () {
      expect(EFlashModeAdapter().typeId, 105);
    });

    test('no enum adapter typeId collides with the 0-99 model range', () {
      final enumTypeIds = <int>[
        EAppThemeModeAdapter().typeId,
        ESyncStatusAdapter().typeId,
        EUnitAdapter().typeId,
        EStoreTypeAdapter().typeId,
        EExpenseSourceAdapter().typeId,
        EFlashModeAdapter().typeId,
      ];
      for (final id in enumTypeIds) {
        expect(
          id,
          greaterThanOrEqualTo(100),
          reason:
              'Manual enum adapter typeId $id collides with the '
              '0-99 range reserved for @GenerateAdapters model adapters.',
        );
      }
      expect(enumTypeIds.toSet().length, enumTypeIds.length,
          reason: 'Two enum adapters share the same typeId.');
    });
  });

  group('hive_adapters.g.yaml — committed mapping matches runtime', () {
    late Map<dynamic, dynamic> yaml;

    setUpAll(() {
      final file = File('lib/core/hive/hive_adapters.g.yaml');
      expect(
        file.existsSync(),
        isTrue,
        reason:
            'hive_adapters.g.yaml must be committed — hive_rules.md rule 3.',
      );
      yaml = _parseSimpleYamlTypeIds(file.readAsStringSync());
    });

    test('every model in the yaml maps to the expected typeId', () {
      const expected = <String, int>{
        'AppSettings': 0,
        'Receipt': 1,
        'ReceiptItem': 2,
        'Product': 3,
        'Store': 4,
        'Category': 5,
        'Expense': 6,
        'PriceObservation': 7,
      };

      for (final entry in expected.entries) {
        expect(
          yaml[entry.key],
          entry.value,
          reason:
              '${entry.key} typeId drifted in hive_adapters.g.yaml — this '
              'renumbers already-stored data on the next regeneration.',
        );
      }
    });

    test('nextTypeId in the yaml is 8 (no gap, no silent renumber)', () {
      final file = File('lib/core/hive/hive_adapters.g.yaml');
      final content = file.readAsStringSync();
      final match = RegExp(r'nextTypeId:\s*(\d+)').firstMatch(content);
      expect(match, isNotNull);
      expect(int.parse(match!.group(1)!), 8);
    });
  });
}

/// Minimal, dependency-free reader for the two fields this test needs from
/// `hive_adapters.g.yaml` (`<Model>: \n  typeId: N`) — avoids pulling in a
/// full YAML parser dev-dependency for an eight-line lookup.
Map<String, int> _parseSimpleYamlTypeIds(String content) {
  final result = <String, int>{};
  final modelHeaderRe = RegExp(r'^  (\w+):\s*$');
  final typeIdRe = RegExp(r'^\s+typeId:\s*(\d+)\s*$');

  String? currentModel;
  for (final line in const LineSplitter().convert(content)) {
    final headerMatch = modelHeaderRe.firstMatch(line);
    if (headerMatch != null) {
      currentModel = headerMatch.group(1);
      continue;
    }
    final idMatch = typeIdRe.firstMatch(line);
    if (idMatch != null && currentModel != null && !result.containsKey(currentModel)) {
      result[currentModel] = int.parse(idMatch.group(1)!);
    }
  }
  return result;
}
