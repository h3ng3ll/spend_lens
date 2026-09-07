import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/product/domain/models/product/e_unit.dart';
import 'package:spend_lens/features/receipt/domain/parser/stages/receipt_quantity_extractor.dart';

void main() {
  const extractor = ReceiptQuantityExtractor();

  group('weighed lines (design_spendlens.md §11)', () {
    test('1.2 kg @ 104 -> quantity 1.2, unit kilogram, unitPrice 104', () {
      final result = extractor.extract('ROSII 1.2 kg @ 104');
      expect(result.quantity, 1.2);
      expect(result.unit, EUnit.kilogram);
      expect(result.unitPrice, 104.0);
    });

    test('500 g @ 40 normalizes quantity to kilograms (0.5)', () {
      final result = extractor.extract('CASTRAVETI 500 g @ 40');
      expect(result.quantity, 0.5);
      expect(result.unit, EUnit.kilogram);
      expect(result.unitPrice, 40.0);
    });

    test('accepts x as well as @ for the weighed marker', () {
      final result = extractor.extract('ROSII 1.2 kg x 104');
      expect(result.quantity, 1.2);
      expect(result.unitPrice, 104.0);
    });
  });

  group('simple count lines', () {
    test('2 x 22.90 -> quantity 2, unit piece, unitPrice 22.90', () {
      final result = extractor.extract('MILK 2 x 22.90');
      expect(result.quantity, 2.0);
      expect(result.unit, EUnit.piece);
      expect(result.unitPrice, 22.90);
    });
  });

  group('bare line, no quantity marker', () {
    test('defaults to quantity 1, unit piece, no unit price', () {
      final result = extractor.extract('BREAD 7.90');
      expect(result.quantity, 1.0);
      expect(result.unit, EUnit.piece);
      expect(result.unitPrice, isNull);
    });
  });

  group('unit normalization comparable price (design_spendlens.md §11)', () {
    test('1.2 kg @ 104 -> 86.67/kg', () {
      final comparable = extractor.comparableUnitPrice(
        quantity: 1.2,
        lineTotal: 104.0,
        unit: EUnit.kilogram,
      );
      expect(comparable, 86.67);
    });

    test('500 g @ 40 (0.5 kg, total 40) -> 80/kg', () {
      final comparable = extractor.comparableUnitPrice(
        quantity: 0.5,
        lineTotal: 40.0,
        unit: EUnit.kilogram,
      );
      expect(comparable, 80.0);
    });

    test('a piece-unit line has no comparable per-kg/per-L price', () {
      final comparable = extractor.comparableUnitPrice(
        quantity: 2.0,
        lineTotal: 45.80,
        unit: EUnit.piece,
      );
      expect(comparable, isNull);
    });
  });
}
