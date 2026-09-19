import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/store/domain/matcher/receipt_store_matcher.dart';
import 'package:spend_lens/features/store/domain/models/store/store.dart';

/// The matching layer `ReceiptStoreResolver`'s doc comment always deferred to
/// ("a repository-layer concern the use case above the parser performs") but
/// which was never written — so a scanned receipt was persisted with
/// `storeId: null` and appeared under no store at all.
///
/// The central guarantee under test is the NEGATIVE one: an unrelated header
/// must resolve to `null` so the field is left unselected, never to the
/// nearest store and never to a newly invented one.
void main() {
  Store store(String id, String name, {List<String> aliases = const []}) =>
      Store(
        id: id,
        name: name,
        receiptAliases: aliases,
        updatedAt: DateTime(2026, 9, 19),
      );

  const matcher = ReceiptStoreMatcher();

  final kaufland = store('1', 'Kaufland');
  final linella = store('2', 'Linella');
  final nr1 = store('3', 'Nr.1, Green Hills');

  group('no match leaves the store unselected', () {
    test('an unrelated header resolves to null, not to the closest store', () {
      expect(
        matcher.match(printedName: 'LINELLA', stores: [kaufland]),
        isNull,
      );
    });

    test('a null printed name resolves to null', () {
      expect(matcher.match(printedName: null, stores: [kaufland]), isNull);
    });

    test('a blank printed name resolves to null', () {
      expect(matcher.match(printedName: '   ', stores: [kaufland]), isNull);
    });

    test('an empty store list resolves to null', () {
      expect(matcher.match(printedName: 'KAUFLAND', stores: []), isNull);
    });

    test('punctuation-only input cleans to empty and resolves to null', () {
      expect(matcher.match(printedName: '---', stores: [kaufland]), isNull);
    });
  });

  group('matching an existing store', () {
    test('exact name, ignoring case', () {
      expect(
        matcher.match(printedName: 'KAUFLAND', stores: [kaufland, linella]),
        kaufland,
      );
    });

    test('a header carrying legal-entity noise still matches', () {
      // The real shape of the reported receipt: the brand plus a company form
      // and a postcode. Edit distance alone would reject this, which is why
      // the containment stage exists.
      expect(
        matcher.match(
          printedName: 'KAUFLAND SA MD-2001',
          stores: [kaufland, linella],
        ),
        kaufland,
      );
    });

    test('single-character OCR noise still matches', () {
      expect(
        matcher.match(printedName: 'KAUFLNAD', stores: [kaufland, linella]),
        kaufland,
      );
    });

    test('punctuation differences do not prevent a match', () {
      expect(
        matcher.match(printedName: 'NR1 GREEN HILLS', stores: [nr1]),
        nr1,
      );
    });
  });

  group('learned aliases', () {
    test('an alias resolves a spelling the name never would', () {
      // Deliberately nothing like "Kaufland" — a receipt that prints only the
      // operating company. Without the alias there is no way to connect them.
      const printed = 'SC VICTORIAGRUP SRL';
      final withAlias = store('1', 'Kaufland', aliases: [printed]);

      // Proves the alias is what did it: the same input against the
      // alias-less store is not a match.
      expect(matcher.match(printedName: printed, stores: [kaufland]), isNull);
      expect(
        matcher.match(printedName: printed, stores: [withAlias]),
        withAlias,
      );
    });

    test('an alias wins over another store whose NAME is an exact match', () {
      // The user explicitly taught us this spelling, so their instruction
      // outranks a coincidental name collision on a different store.
      final taught = store('1', 'Kaufland', aliases: ['Linella']);
      expect(
        matcher.match(printedName: 'LINELLA', stores: [taught, linella]),
        taught,
      );
    });
  });

  group('determinism', () {
    test('a tie resolves by id, not by list order', () {
      final a = store('1', 'Kaufland');
      final b = store('2', 'Kaufland');

      expect(matcher.match(printedName: 'KAUFLAND', stores: [a, b]), a);
      // Reversed input, identical answer — box iteration order must never
      // change which store a receipt lands under.
      expect(matcher.match(printedName: 'KAUFLAND', stores: [b, a]), a);
    });

    test('the longest contained name wins over a shorter one', () {
      final short = store('1', 'Green');
      final long = store('2', 'Green Hills');
      expect(
        matcher.match(
          printedName: 'GREEN HILLS MARKET',
          stores: [short, long],
        ),
        long,
      );
    });
  });
}
