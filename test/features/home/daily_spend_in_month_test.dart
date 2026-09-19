import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/expense/domain/models/expense/expense.dart';
import 'package:spend_lens/features/home/presentation/utils/home_calculations.dart';

/// Backs Home's month chart. The series must cover the WHOLE month — a
/// sparse one would space three purchases evenly across the width and imply
/// a rhythm that is not there.
Expense expense({
  required String id,
  required double amount,
  required DateTime occurredAt,
}) => Expense(
  id: id,
  amount: amount,
  currencyCode: 'MDL',
  categoryId: 'catOther',
  occurredAt: occurredAt,
  updatedAt: occurredAt,
);

void main() {
  test('returns one entry per calendar day, in order', () {
    // September 2026 has 30 days. `month` is 0-based, so 8 == September.
    final days = dailySpendInMonth(const [], year: 2026, month: 8);

    expect(days, hasLength(30));
    expect(days.first.day, 1);
    expect(days.last.day, 30);
  });

  test('handles month lengths, including a leap February', () {
    expect(dailySpendInMonth(const [], year: 2026, month: 1), hasLength(28));
    expect(dailySpendInMonth(const [], year: 2028, month: 1), hasLength(29));
    expect(dailySpendInMonth(const [], year: 2026, month: 0), hasLength(31));
  });

  test('sums every expense that falls on the same day', () {
    final days = dailySpendInMonth(
      [
        expense(id: '1', amount: 10.0, occurredAt: DateTime(2026, 9, 19, 9)),
        expense(id: '2', amount: 5.5, occurredAt: DateTime(2026, 9, 19, 18)),
      ],
      year: 2026,
      month: 8,
    );

    final nineteenth = days[18];
    expect(nineteenth.day, 19);
    expect(nineteenth.amount, 15.5);
    expect(nineteenth.hasData, isTrue);
  });

  test('marks days with no expenses as hasData false', () {
    // The distinction the chart depends on: an empty day renders as a faint
    // stub, never as a data bar (chronic
    // `chart-zero-value-bar-paints-the-data-fill-so-empty-reads-as-measured`).
    final days = dailySpendInMonth(
      [expense(id: '1', amount: 10.0, occurredAt: DateTime(2026, 9, 19))],
      year: 2026,
      month: 8,
    );

    expect(days[18].hasData, isTrue);
    expect(days[0].hasData, isFalse);
    expect(days[0].amount, 0.0);
  });

  test('a genuine zero-value expense still counts as measured', () {
    // `hasData` is not `amount > 0` — a day that netted zero was still a day
    // something happened on.
    final days = dailySpendInMonth(
      [expense(id: '1', amount: 0.0, occurredAt: DateTime(2026, 9, 2))],
      year: 2026,
      month: 8,
    );

    expect(days[1].hasData, isTrue);
    expect(days[1].amount, 0.0);
  });

  test('ignores expenses from other months and years', () {
    final days = dailySpendInMonth(
      [
        expense(id: '1', amount: 10.0, occurredAt: DateTime(2026, 8, 19)),
        expense(id: '2', amount: 20.0, occurredAt: DateTime(2025, 9, 19)),
        expense(id: '3', amount: 30.0, occurredAt: DateTime(2026, 9, 19)),
      ],
      year: 2026,
      month: 8,
    );

    expect(days[18].amount, 30.0);
    expect(days.where((d) => d.hasData), hasLength(1));
  });
}
