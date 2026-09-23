import 'package:flutter/material.dart';

/// Earliest purchase date the picker offers. A receipt older than this is
/// not something a user is realistically entering.
final DateTime _kFirstPickableDate = DateTime(2000);

/// Asks for a date, then a time, and returns them combined — or `null` when
/// the user dismisses the date step.
///
/// Dismissing the TIME step keeps [initial]'s time of day, so a user who
/// only wants to fix the day is not forced through the clock.
///
/// Future dates are not offered: a receipt records a purchase that already
/// happened. An [initial] in the future (a clock-skewed device) is clamped
/// to now so the picker can still open.
Future<DateTime?> pickDateTime(BuildContext context, DateTime initial) async {
  final now = DateTime.now();
  final start = initial.isAfter(now) ? now : initial;

  final date = await showDatePicker(
    context: context,
    initialDate: start,
    firstDate: _kFirstPickableDate,
    lastDate: now,
    // Same reason as every other modal in this app.
    useRootNavigator: true,
  );
  if (date == null || !context.mounted) return null;

  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(start),
    useRootNavigator: true,
  );
  final picked = time ?? TimeOfDay.fromDateTime(start);

  return DateTime(date.year, date.month, date.day, picked.hour, picked.minute);
}
