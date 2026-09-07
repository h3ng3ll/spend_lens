/// The scanner's persisted camera-flash preference (design_spendlens.md §3;
/// ARB keys `flash{Auto,On,Off}`). Read by the Scanner screen (M7); stored
/// on [AppSettings] because it is a device-level preference, not part of any
/// single receipt.
enum EFlashMode {
  auto,
  on,
  off,
}
