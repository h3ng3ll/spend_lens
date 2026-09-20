import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/receipt/domain/parser/stages/receipt_structure_resolver.dart';

/// `ReceiptStructureResolver` holds the most consequential predicates in the
/// parser — which region a line belongs to, and therefore whether it becomes
/// a product at all — and had no direct test coverage at all.
///
/// The case that brought this file into being: a receipt's VAT block prints a
/// bare rate row, and when the line grouper splits the `TVA` label away from
/// the figure, nothing vetoed it. `footerKeywords` needs the keyword,
/// `reachedTotal` needs the total line to have matched first, and
/// `isNameOnlyLine` requires letters so it could not even park it. The result
/// was a Product named `1.008 %` priced at 19.95 — and, because VAT is
/// already inside the printed total, an inflated `itemsTotal` that made the
/// parser discard the correctly-read total as implausible.
void main() {
  const resolver = ReceiptStructureResolver();

  group('hasNoProductName rejects a name that identifies no product', () {
    const rejected = <String>[
      '1.008 %', // the reported bug
      '1.008 % 19.95',
      '20 %',
      '1 008', // what the cleaner reduces the bug to
      '', // the empty-name leak
      '   ',
      '%',
      '...',
      '- - -',
      '19.95',
      '5941234567890', // a barcode
      // An amount plus the receipt's VAT CLASS CODE. The single trailing
      // letter is a tax class, not a name — read as one it produced a
      // product called after its own price.
      '99.88 A',
      '139.88 A',
      '71.98 A',
      '88 58',
    ];

    for (final name in rejected) {
      test('"$name" names no product', () {
        expect(resolver.hasNoProductName(name), isTrue);
      });
    }
  });

  group('hasNoProductName NEVER rejects a real product name', () {
    const kept = <String>[
      // THE false-positive guard. A 45%-fat cheese is a real product whose
      // name contains a percentage; an earlier over-broad guard on a
      // `%`-bearing line already dropped this once, which then stranded its
      // price line as a bogus item of its own.
      'Branza Maasdam 45% 130g BREST',
      'COCA COLA 2L 19.95',
      'ROSII 1.2 kg @ 104',
      'LAPTE ZUZU 1L 22.90',
      'TVA 1.008 % 19.99', // keyword lines stay isFooterLine's job
      'Articole 5',
      // Real names from the reported receipt — the shortest still clear
      // the two-letter bar.
      'SET 2 LAVETE NF',
      'TESS CEAI 1886',
      'FILEU PUT 8,9KG',
      'DET CAPSULE 28BUC',
      '2L A',
      'Ou',
    ];

    for (final name in kept) {
      test('"$name" is kept', () {
        expect(resolver.hasNoProductName(name), isFalse);
      });
    }

    test('a Romanian name with diacritics is kept', () {
      // `\p{L}` rather than `[A-Za-z]` — otherwise a name written entirely
      // in diacritics would read as letterless and be dropped.
      expect(resolver.hasNoProductName('Brânză de vaci'), isFalse);
      expect(resolver.hasNoProductName('Pâine'), isFalse);
    });
  });

  group('the predicate keys on letters, not on the percent sign', () {
    test('a percentage alone is rejected but a named percentage is kept', () {
      expect(resolver.hasNoProductName('45%'), isTrue);
      expect(resolver.hasNoProductName('Branza 45%'), isFalse);
    });
  });

  group('existing predicates still hold (regressions they each fixed)', () {
    test('isFooterLine does not match REST inside BREST', () {
      // A bare `contains` check classified the cheese as a footer line and
      // dropped it, stranding its price line as a bogus item.
      expect(resolver.isFooterLine('Branza Maasdam 45% 130g BREST'), isFalse);
      expect(resolver.isFooterLine('REST 0.00'), isTrue);
    });

    test('isFooterLine matches the VAT keyword when it shares the line', () {
      expect(resolver.isFooterLine('TVA 20% 26.20'), isTrue);
    });

    test('isNameOnlyLine still parks the 45% cheese as a pending name', () {
      // The fragment path must keep working: this line has letters and no
      // decimal money token, so it is the NAME half of a wrapped item.
      expect(
        resolver.isNameOnlyLine('Branza Maasdam 45% 130g BREST'),
        isTrue,
      );
    });

    test('isNameOnlyLine keeps a single-line weighed item intact', () {
      // `104` is a bare integer, so a decimals-only test would have misread
      // this complete item as a name awaiting a price on the next row.
      expect(resolver.isNameOnlyLine('ROSII 1.2 kg @ 104'), isFalse);
    });

    test('isPriceContinuation recognizes a wrapped item price line', () {
      expect(resolver.isPriceContinuation('1 _ x 25.50= 25.50 A'), isTrue);
      expect(resolver.isPriceContinuation('0.274 _ x 165.40= 45.32 A'), isTrue);
    });

    test('isPriceContinuation rejects a self-priced named line', () {
      expect(resolver.isPriceContinuation('COCA COLA 2L 19.95'), isFalse);
    });
  });

  group('what the letter count deliberately does NOT catch', () {
    test('an OCR-mangled fragment with two letters is kept', () {
      // `8,151e1 17 98 A` — the `e` of an exponent-looking OCR artefact plus
      // the tax letter. It clears the bar and is KEPT, which is correct: it
      // is the tail of a real line (`SACOSA ECOTAX8,151e1 17 98 A`), and the
      // parser joins it with the name fragment above rather than judging it
      // alone. Catching this would need name-shape heuristics that would
      // start dropping real products.
      expect(resolver.hasNoProductName('8,151e1 17 98 A'), isFalse);
    });
  });

  group('a VAT class code is not a name', () {
    test('an amount plus a single trailing letter is rejected', () {
      // `99.88 A` became a product named after its own price. One letter is
      // the tax class the receipt prints, never a product word.
      expect(resolver.hasNoProductName('99.88 A'), isTrue);
    });

    test('but two letters are enough for a real short name', () {
      expect(resolver.hasNoProductName('2L A'), isFalse);
      expect(resolver.hasNoProductName('Ou'), isFalse);
    });

    test('a short fragment of a real name is parked, never judged here', () {
      // `45% 130g` has one letter, so this predicate alone would reject it
      // — but it never arrives: isNameOnlyLine parks it as a pending name
      // fragment, and the parser tests the JOINED name.
      expect(resolver.isNameOnlyLine('45% 130g'), isTrue);
      expect(resolver.isNameOnlyLine('2L A'), isTrue);
      // The price-bearing junk line, by contrast, is NOT parked — it goes
      // to the item branch where the guard applies.
      expect(resolver.isNameOnlyLine('99.88 A'), isFalse);
    });
  });
}
