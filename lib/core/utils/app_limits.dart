/// App-wide free/premium quota constants (design_spendlens.md §6).
///
/// Single source of truth for the numbers otherwise hardcoded across the
/// Profile/Settings storage rows and the ARB `tPremiumOn` / `tPremiumOff` /
/// `toPremium` / `limitPremium` strings' `{quota}` placeholder — those
/// strings never hardcode "5 GB" / "100 MB" themselves; callers format the
/// quota label FROM these constants and pass it in as a parameter.
///
/// M9 wires this into the real `SubscriptionRepository` (Apphud). M2 only
/// needs the labels to exist so the ported ARB placeholders have a single,
/// non-duplicated source to read from.
abstract class AppLimits {
  /// The free tier's maximum number of stored receipts.
  static const int freeReceiptLimit = 50;

  /// Free tier cloud storage quota label.
  static const String freeCloudQuotaLabel = '100 MB';

  /// Premium tier cloud storage quota label.
  static const String premiumCloudQuotaLabel = '5 GB';

  /// The same quotas as BYTE counts.
  ///
  /// The labels above are for display; a progress bar needs a numeric
  /// denominator, and deriving one by parsing "100 MB" back out of a
  /// localized string would be absurd. Binary units (MiB/GiB), matching how
  /// Firebase reports object sizes.
  static const int freeCloudQuotaBytes = 100 * 1024 * 1024;

  static const int premiumCloudQuotaBytes = 5 * 1024 * 1024 * 1024;
}
