import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/receipt/domain/parser/stages/receipt_date_extractor.dart';

void main() {
  const extractor = ReceiptDateExtractor();

  group('the 4 supported date formats (design_spendlens.md §11)', () {
    test('DD.MM.YYYY', () {
      expect(extractor.extract('07.09.2026'), DateTime(2026, 9, 7));
    });

    test('DD/MM/YYYY', () {
      expect(extractor.extract('07/09/2026'), DateTime(2026, 9, 7));
    });

    test('DD-MM-YYYY', () {
      expect(extractor.extract('07-09-2026'), DateTime(2026, 9, 7));
    });

    test('ISO YYYY-MM-DD', () {
      expect(extractor.extract('2026-09-07'), DateTime(2026, 9, 7));
    });
  });

  test('the day-first convention applies even when day <= 12 — not itself ambiguous', () {
    // Moldovan/Romanian receipts are universally day-first, so 05.03.2026
    // is unhesitatingly 5-March under this parser's one fixed convention.
    expect(extractor.extract('05.03.2026'), DateTime(2026, 3, 5));
  });

  test('an out-of-range day (e.g. Feb 30) is rejected, not silently rolled over', () {
    expect(extractor.extract('30.02.2026'), isNull);
  });

  test('a line with no date returns null', () {
    expect(extractor.extract('TOTAL DE PLATA 151.10'), isNull);
  });

  group('resolveAmbiguous — an ambiguous date returns null (design_spendlens.md §36)', () {
    test('two DIFFERENT, both-valid readings resolve to null rather than a silent swap', () {
      // A hypothetical case where a caller genuinely has two plausible
      // readings for the same printed digits (e.g. day-first vs
      // month-first) and they disagree — 5-March vs 3-May.
      final dayFirst = extractor.extract('05.03.2026'); // 5 March
      final monthFirst = DateTime(2026, 5, 3); // 3 May, if month-first

      expect(
        extractor.resolveAmbiguous(
          dayFirstReading: dayFirst,
          monthFirstReading: monthFirst,
        ),
        isNull,
      );
    });

    test('when both readings agree, the shared date is returned', () {
      final reading = DateTime(2026, 5, 5);
      expect(
        extractor.resolveAmbiguous(
          dayFirstReading: reading,
          monthFirstReading: reading,
        ),
        reading,
      );
    });

    test('when only one reading is a valid calendar date, that one wins', () {
      final onlyValid = DateTime(2026, 9, 25);
      expect(
        extractor.resolveAmbiguous(
          dayFirstReading: onlyValid,
          monthFirstReading: null,
        ),
        onlyValid,
      );
    });
  });
}
