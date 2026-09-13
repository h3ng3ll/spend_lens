import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// The user's editable identity: name, email and avatar.
///
/// NOT a Hive-registered model. It is persisted as a JSON string in the
/// `profiles` box (`UserProfileLocalRepository`) rather than through
/// `@GenerateAdapters`, because model typeIds 0-7 and enum typeIds 100-105 are
/// pinned as literals by `test/core/hive/hive_type_ids_test.dart` — a
/// regeneration that renumbers either range corrupts already-stored data.
/// Encoding to JSON keeps this feature entirely out of that numbering.
///
/// It is also deliberately absent from [ESyncCollection]: it has no `id` and no
/// `syncStatus`, and it mirrors to `/users/{uid}` as a single document rather
/// than through the record-sync engine.
@freezed
sealed class UserProfile with _$UserProfile {
  const factory UserProfile({
    @Default('') String uid,
    @Default('') String firstName,
    @Default('') String lastName,

    /// Provider-owned, shown read-only on the edit screen. Never editable:
    /// it is the identity Google/Apple authenticated, not a user preference.
    @Default('') String email,

    /// Firebase Storage download URL for `users/{uid}/profile/avatar.jpg`, or
    /// the provider's own photo when the user has not set one. Empty = no
    /// avatar, which is what makes the remove affordance conditional.
    @Default('') String photoUrl,
    @Default(false) bool isGoogleAccount,
    DateTime? updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

extension UserProfileX on UserProfile {
  /// The identity line's primary text. Empty when neither name part is set,
  /// which is the signal for callers to fall back to the email.
  String get displayName => '$firstName $lastName'.trim();

  bool get hasName => displayName.isNotEmpty;

  bool get hasPhoto => photoUrl.isNotEmpty;
}
