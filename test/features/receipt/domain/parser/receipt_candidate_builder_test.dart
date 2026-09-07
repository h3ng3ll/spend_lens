import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/product/domain/models/product/e_unit.dart';
import 'package:spend_lens/features/receipt/domain/parser/stages/receipt_candidate_builder.dart';

void main() {
  const builder = ReceiptCandidateBuilder();

  test('builds a simple piece-count candidate', () {
    final candidate = builder.build(
      line: 'BREAD 7.90',
      lineConfidence: 0.9,
      lineIndex: 0,
    );
    expect(candidate, isNotNull);
    expect(candidate!.rawName, 'BREAD');
    expect(candidate.quantity, 1.0);
    expect(candidate.unit, EUnit.piece);
    expect(candidate.lineTotal, 7.90);
  });

  test('builds a weighed candidate with a comparable unit price', () {
    final candidate = builder.build(
      line: 'ROSII 1.2 kg @ 104',
      lineConfidence: 0.85,
      lineIndex: 1,
    );
    expect(candidate, isNotNull);
    expect(candidate!.rawName, 'ROSII');
    expect(candidate.quantity, 1.2);
    expect(candidate.unit, EUnit.kilogram);
    expect(candidate.unitPrice, 104.0);
    expect(candidate.lineTotal, 104.0);
  });

  test('returns null for a line with no extractable price', () {
    expect(
      builder.build(line: 'MULTUMIM PENTRU VIZITA', lineConfidence: 0.9, lineIndex: 0),
      isNull,
    );
  });

  test('returns null for a pure barcode line (no name survives stripping)', () {
    expect(
      builder.build(line: '5941234567890', lineConfidence: 0.9, lineIndex: 0),
      isNull,
    );
  });

  test('preserves the ORIGINAL line index passed in', () {
    final candidate = builder.build(
      line: 'MILK 2 x 22.90',
      lineConfidence: 0.9,
      lineIndex: 5,
    );
    expect(candidate!.lineIndex, 5);
  });
}
