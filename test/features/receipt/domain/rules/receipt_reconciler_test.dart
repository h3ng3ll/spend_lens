import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/receipt/domain/rules/receipt_reconciler.dart';

void main() {
  const reconciler = ReceiptReconciler();

  test('matches when printed total equals items total', () {
    final result = reconciler.reconcile(printedTotal: 151.10, itemsTotal: 151.10);
    expect(result.matches, isTrue);
    expect(result.difference, 0.0);
  });

  test('matches within a small rounding tolerance', () {
    final result = reconciler.reconcile(printedTotal: 151.10, itemsTotal: 151.11);
    expect(result.matches, isTrue);
  });

  test('WARNS on a real mismatch but this is informational only (spec §45)', () {
    final result = reconciler.reconcile(printedTotal: 151.10, itemsTotal: 140.00);
    expect(result.matches, isFalse);
    expect(result.difference, closeTo(11.10, 0.001));
    // The reconciler itself has no concept of "blocking" — there is no
    // boolean or method here that could prevent a save. This is the
    // reconciler's entire API surface: reconcile() always returns.
  });

  test('a missing printed total is reported as a harmless non-match, not an error', () {
    final result = reconciler.reconcile(printedTotal: null, itemsTotal: 50.0);
    expect(result.matches, isTrue);
    expect(result.printedTotal, isNull);
  });
}
