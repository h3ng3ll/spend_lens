/// Formats a byte count for display.
///
/// Binary units, matching how Firebase reports object sizes and how
/// [AppLimits]' quota constants are defined — so the bar's numerator and
/// denominator are in the same units and the fraction is honest.
String formatBytes(int bytes) {
  if (bytes <= 0) return '0 MB';

  const kb = 1024;
  const mb = kb * 1024;
  const gb = mb * 1024;

  if (bytes >= gb) {
    final value = bytes / gb;
    // One decimal below 10 GB so "1.2 GB" does not collapse to "1 GB".
    return value >= 10 ? '${value.round()} GB' : '${value.toStringAsFixed(1)} GB';
  }
  if (bytes >= mb) return '${(bytes / mb).round()} MB';
  if (bytes >= kb) return '${(bytes / kb).round()} KB';
  return '$bytes B';
}
