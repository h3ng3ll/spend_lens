/// String helpers used across the app.
///
/// Note: sinergy_hub's `string_x.dart` also carried a `parseChatMessage()`
/// helper that returned the `chat` feature's `TextType` union. That feature
/// is not part of SpendLens (design_spendlens.md §1 Step 3), so this is a
/// deliberately smaller extension — add SpendLens-specific string helpers
/// here as later milestones need them.
extension StringX on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
