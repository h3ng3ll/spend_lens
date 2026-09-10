/// The two billing periods the premium upgrade sheet offers.
///
/// Singular PascalCase with the project's `E` prefix (naming rule). The
/// sheet renders one option per value, so adding a plan here is the only
/// change a third tier would need on the presentation side.
enum ESubscriptionPlan {
  monthly,
  yearly,
}
