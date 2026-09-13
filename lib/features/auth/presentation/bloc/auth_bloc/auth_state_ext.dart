part of 'auth_bloc.dart';

/// The UI reads these getters, never the enum directly.
extension AuthStateX on AuthState {
  bool get isSignedOut => status == EAuthStatus.signedOut;

  bool get isSigningIn => status == EAuthStatus.signingIn;

  bool get isSignedIn => status == EAuthStatus.signedIn;

  bool get isFailed => status == EAuthStatus.failed;

  /// An account deletion is running. Used to block a second tap and to show
  /// progress — the flow makes several network round trips.
  bool get isDeleting => status == EAuthStatus.deleting;

  /// The account was deleted. A one-shot signal the UI listens for to leave
  /// the Profile screen; `watchUser()` then settles the state to `signedOut`.
  bool get isDeleted => status == EAuthStatus.deleted;

  /// Alias for [isSigningIn] — the minimum `isLoading` contract (A3 rule 9).
  bool get isLoading => isSigningIn;

  /// Alias for [isSignedIn] — the minimum `isReady`/`isSuccess` contract
  /// (A3 rule 9).
  bool get isReady => isSignedIn;

  /// Every state in which the user has no account attached — signed out, an
  /// attempt in flight, and a FAILED attempt.
  ///
  /// The sign-in offer must be gated on this, never on [isSignedOut] alone:
  /// a failed authorization leaves the bloc in [EAuthStatus.failed], which is
  /// neither `signedOut` nor `signedIn`, so an `isSignedOut`/`isSignedIn` pair
  /// of branches renders NOTHING and the Google/Apple buttons disappear with
  /// no way to retry.
  bool get isNotSignedIn => !isSignedIn;

  /// Whether the account-deletion control should be offered at all.
  ///
  /// Apple requires the path only for accounts, so it is hidden for a user who
  /// has none — there is nothing to delete, and the on-device "Delete all
  /// records" action already covers that case.
  bool get canDeleteAccount => isSignedIn && uid.isNotEmpty;

  /// `true` when signed in through Apple rather than Google.
  ///
  /// Read this instead of negating [isGoogleAccount] directly: that flag is
  /// only meaningful while signed in, so a bare `!isGoogleAccount` reports
  /// "Apple" for a signed-OUT user too.
  bool get isAppleAccount => isSignedIn && !isGoogleAccount;

  /// The profile's full name, empty when neither part is set.
  String get displayName => '$firstName $lastName'.trim();

  bool get hasName => displayName.isNotEmpty;

  /// Whether an avatar image is available to render. Drives BOTH the avatar
  /// itself and — per `edit_profile_screen_rules.md` — whether the edit
  /// screen offers a Remove affordance at all.
  bool get hasAvatar => avatarFilename.isNotEmpty;

  /// Whether the profile-editing feature is available to this user.
  ///
  /// The feature is HIDDEN, not merely disabled, while signed out: there is
  /// no account to attach a name or photo to, and no uid to scope the remote
  /// write by. Callers gate the tap target AND the edit badge on this.
  bool get canEditProfile => isSignedIn && uid.isNotEmpty;

  /// The identity line's primary text: the name when set, otherwise the email
  /// (which is what every signed-in user had before names existed, so an
  /// un-named account reads exactly as it did).
  String get identityPrimary => hasName ? displayName : email;

  /// The secondary line, empty when it would merely repeat [identityPrimary].
  String get identitySecondary => hasName ? email : '';
}
