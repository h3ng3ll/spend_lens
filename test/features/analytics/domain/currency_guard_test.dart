import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/analytics/domain/calculator/currency_guard.dart';
import 'package:spend_lens/features/expense/domain/models/expense/expense.dart';

Expense _expense(double amount, String currencyCode, DateTime at) {
  return Expense(
    id: '$amount-$currencyCode',
    amount: amount,
    currencyCode: currencyCode,
    categoryId: 'catFood',
    occurredAt: at,
    updatedAt: at,
  );
}

void main() {
  group('currency guard', () {
    test('totalInCurrency sums only the requested currency — mixed currencies never combine', () {
      final now = DateTime(2026, 9, 1);
      final expenses = [
        _expense(100.0, 'MDL', now),
        _expense(1000.0, 'EUR', now),
        _expense(50.0, 'MDL', now),
      ];

      expect(totalInCurrency(expenses, 'MDL'), 150.0);
      expect(totalInCurrency(expenses, 'EUR'), 1000.0);
      expect(totalInCurrency(expenses, 'USD'), 0.0);
    });

    test('hasMixedCurrencies detects more than one currency present', () {
      final now = DateTime(2026, 9, 1);
      expect(
        hasMixedCurrencies([_expense(10.0, 'MDL', now), _expense(10.0, 'MDL', now)]),
        isFalse,
      );
      expect(
        hasMixedCurrencies([_expense(10.0, 'MDL', now), _expense(10.0, 'EUR', now)]),
        isTrue,
      );
    });

    test('distinctCurrencies returns every currency code present', () {
      final now = DateTime(2026, 9, 1);
      final codes = distinctCurrencies([
        _expense(10.0, 'MDL', now),
        _expense(10.0, 'EUR', now),
        _expense(10.0, 'MDL', now),
      ]);
      expect(codes, {'MDL', 'EUR'});
    });
  });
}
