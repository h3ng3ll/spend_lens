import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/receipt/domain/parser/stages/receipt_line_grouper.dart';

import '../../../../fixtures/synthetic_receipt_fixtures.dart';

void main() {
  const grouper = ReceiptLineGrouper();

  test('groups a single-column receipt into one line per block', () {
    final grouped = grouper.group(
      SyntheticReceiptFixtures.cleanSingleColumnReceipt(),
    );
    expect(grouped.length, 7);
    expect(grouped.first.text, 'KAUFLAND MOLDOVA');
  });

  group('two-column layout (design_spendlens.md §11)', () {
    test('merges a same-row name block and price block into one line', () {
      final grouped = grouper.group(
        SyntheticReceiptFixtures.twoColumnReceipt(),
      );

      // 2 header lines + 3 merged item rows + 1 total line = 6 grouped
      // lines from 9 input blocks (3 of which were column-split pairs).
      expect(grouped.length, 6);

      final milkLine = grouped.firstWhere((l) => l.text.contains('MILK'));
      expect(milkLine.text, 'MILK 1L 22.90');

      final breadLine = grouped.firstWhere((l) => l.text.contains('BREAD'));
      expect(breadLine.text, 'BREAD 7.90');
    });

    test('left-to-right ordering is preserved within a merged row', () {
      final grouped = grouper.group(
        SyntheticReceiptFixtures.twoColumnReceipt(),
      );
      final tomatoLine = grouped.firstWhere(
        (l) => l.text.contains('TOMATOES'),
      );
      // Name (left column) must precede price (right column).
      expect(tomatoLine.text.indexOf('TOMATOES'), lessThan(tomatoLine.text.indexOf('16.30')));
    });
  });

  test('an empty block list groups to an empty list', () {
    expect(grouper.group(const []), isEmpty);
  });
}
