/// Name/email Apple hands back on the FIRST authorization only (subsequent
/// sign-ins omit them) — design_spendlens.md §9. Not persisted to Hive;
/// consumed once by the auth flow to prefill a display name if the app ever
/// needs one.
class AppleCredentials {
  final String? firstName;
  final String? lastName;
  final String? email;

  const AppleCredentials({this.firstName, this.lastName, this.email});

  bool get hasAny => firstName != null || lastName != null || email != null;
}
