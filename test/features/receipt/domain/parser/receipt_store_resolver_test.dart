import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/receipt/domain/parser/stages/receipt_store_resolver.dart';

void main() {
  const resolver = ReceiptStoreResolver();

  test('picks the first non-address, non-numeric header line as the store name', () {
    expect(
      resolver.resolve(['KAUFLAND MOLDOVA', 'STR. GHIOCEILOR 1', '07.09.2026']),
      'KAUFLAND MOLDOVA',
    );
  });

  test('skips an address line even if it comes first', () {
    expect(
      resolver.resolve(['STR. GHIOCEILOR 1', 'LIDL', '06/09/2026']),
      'LIDL',
    );
  });

  test('skips a mostly-numeric line (e.g. a fiscal code)', () {
    expect(
      resolver.resolve(['1234567890', 'METRO CASH & CARRY']),
      'METRO CASH & CARRY',
    );
  });

  test('returns null when every header line is address/numeric noise', () {
    expect(
      resolver.resolve(['STR. GHIOCEILOR 1', 'TEL 022123456', '1234567']),
      isNull,
    );
  });

  test('returns null for an empty header list', () {
    expect(resolver.resolve(const []), isNull);
  });
}
