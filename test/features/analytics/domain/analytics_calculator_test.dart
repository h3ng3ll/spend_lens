import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/analytics/domain/calculator/analytics_calculator.dart';
import 'package:spend_lens/features/category/domain/models/category/category.dart';
import 'package:spend_lens/features/expense/domain/models/expense/e_expense_source.dart';
import 'package:spend_lens/features/expense/domain/models/expense/expense.dart';

Expense _expense({
  required String id,
  required double amount,
  required String categoryId,
  required DateTime occurredAt,
  String currencyCode = 'MDL',
  EExpenseSource source = EExpenseSource.receipt,
}) {
  return Expense(
    id: id,
    amount: amount,
    currencyCode: currencyCode,
    categoryId: categoryId,
    occurredAt: occurredAt,
    source: source,
    updatedAt: occurredAt,
  );
}

Category _category(String id) {
  return Category(
    id: id,
    name: id,
    colorHex: '#000000',
    isBuiltIn: true,
    updatedAt: DateTime(2026),
  );
}

void main() {
  group('buildMonthlySummary', () {
    final categories = [_category('catFood'), _category('catTransport')];

    test('computes total, count and average for the month', () {
      final expenses = [
        _expense(
          id: '1',
          amount: 100.0,
          categoryId: 'catFood',
          occurredAt: DateTime(2026, 9, 1),
        ),
        _expense(
          id: '2',
          amount: 50.0,
          categoryId: 'catTransport',
          occurredAt: DateTime(2026, 9, 15),
        ),
      ];

      final summary = buildMonthlySummary(
        allExpenses: expenses,
        categories: categories,
        year: 2026,
        month: 8, // September, 0-based
        displayCurrencyCode: 'MDL',
      );

      expect(summary.total, 150.0);
      expect(summary.purchaseCount, 2);
      expect(summary.averagePurchase, 75.0);
    });

    test('previous-month comparison and % change', () {
      final expenses = [
        _expense(
          id: '1',
          amount: 100.0,
          categoryId: 'catFood',
          occurredAt: DateTime(2026, 8, 10), // August (prev month)
        ),
        _expense(
          id: '2',
          amount: 120.0,
          categoryId: 'catFood',
          occurredAt: DateTime(2026, 9, 10), // September (current)
        ),
      ];

      final summary = buildMonthlySummary(
        allExpenses: expenses,
        categories: categories,
        year: 2026,
        month: 8, // September
        displayCurrencyCode: 'MDL',
      );

      expect(summary.previousMonthTotal, 100.0);
      expect(summary.percentChangeVsPreviousMonth, closeTo(20.0, 0.001));
    });

    test('previousMonthTotal is null when there is no prior data — never fabricated as zero', () {
      final expenses = [
        _expense(
          id: '1',
          amount: 100.0,
          categoryId: 'catFood',
          occurredAt: DateTime(2026, 9, 10),
        ),
      ];

      final summary = buildMonthlySummary(
        allExpenses: expenses,
        categories: categories,
        year: 2026,
        month: 8,
        displayCurrencyCode: 'MDL',
      );

      expect(summary.previousMonthTotal, isNull);
      expect(summary.percentChangeVsPreviousMonth, isNull);
    });

    test('per-category share and count', () {
      final expenses = [
        _expense(
          id: '1',
          amount: 75.0,
          categoryId: 'catFood',
          occurredAt: DateTime(2026, 9, 1),
        ),
        _expense(
          id: '2',
          amount: 75.0,
          categoryId: 'catFood',
          occurredAt: DateTime(2026, 9, 2),
        ),
        _expense(
          id: '3',
          amount: 50.0,
          categoryId: 'catTransport',
          occurredAt: DateTime(2026, 9, 3),
        ),
      ];

      final summary = buildMonthlySummary(
        allExpenses: expenses,
        categories: categories,
        year: 2026,
        month: 8,
        displayCurrencyCode: 'MDL',
      );

      expect(summary.categoryShares.length, 2);
      final food = summary.categoryShares.firstWhere(
        (share) => share.categoryId == 'catFood',
      );
      expect(food.amount, 150.0);
      expect(food.count, 2);
      expect(food.sharePercent, closeTo(75.0, 0.001));

      final transport = summary.categoryShares.firstWhere(
        (share) => share.categoryId == 'catTransport',
      );
      expect(transport.amount, 50.0);
      expect(transport.count, 1);
      expect(transport.sharePercent, closeTo(25.0, 0.001));
    });

    test('cash-vs-receipt split', () {
      final expenses = [
        _expense(
          id: '1',
          amount: 100.0,
          categoryId: 'catFood',
          occurredAt: DateTime(2026, 9, 1),
          source: EExpenseSource.cash,
        ),
        _expense(
          id: '2',
          amount: 100.0,
          categoryId: 'catFood',
          occurredAt: DateTime(2026, 9, 2),
          source: EExpenseSource.receipt,
        ),
        _expense(
          id: '3',
          amount: 100.0,
          categoryId: 'catFood',
          occurredAt: DateTime(2026, 9, 3),
          source: EExpenseSource.receipt,
        ),
      ];

      final summary = buildMonthlySummary(
        allExpenses: expenses,
        categories: categories,
        year: 2026,
        month: 8,
        displayCurrencyCode: 'MDL',
      );

      expect(summary.cashShare, closeTo(1 / 3, 0.001));
    });

    test('empty month never divides by zero', () {
      final summary = buildMonthlySummary(
        allExpenses: const [],
        categories: categories,
        year: 2026,
        month: 8,
        displayCurrencyCode: 'MDL',
      );

      expect(summary.total, 0.0);
      expect(summary.purchaseCount, 0);
      expect(summary.averagePurchase, 0.0);
      expect(summary.cashShare, 0.0);
      expect(summary.categoryShares, isEmpty);
    });

    test('the display currency LABELS the total, it never filters it', () {
      final expenses = [
        _expense(
          id: '1',
          amount: 100.0,
          categoryId: 'catFood',
          occurredAt: DateTime(2026, 9, 1),
        ),
        _expense(
          id: '2',
          amount: 1000.0,
          categoryId: 'catFood',
          occurredAt: DateTime(2026, 9, 2),
          currencyCode: 'EUR',
        ),
      ];

      final summary = buildMonthlySummary(
        allExpenses: expenses,
        categories: categories,
        year: 2026,
        month: 8,
        displayCurrencyCode: 'MDL',
      );

      // The settings currency is a display label, so BOTH expenses count.
      // Filtering by each record's stored currencyCode is what zeroed the
      // whole Analytics screen: records carry a fixed code while the
      // setting is user-changeable, so the filter dropped every expense as
      // soon as the two differed.
      expect(summary.total, 1100.0);
      expect(summary.purchaseCount, 2);
      // The requested code is still what the summary reports.
      expect(summary.currencyCode, 'MDL');
    });
  });
}
