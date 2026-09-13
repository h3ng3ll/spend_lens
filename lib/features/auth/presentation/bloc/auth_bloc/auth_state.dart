part of 'auth_bloc.dart';

enum EAuthStatus { signedOut, signingIn, signedIn, failed, deleting, deleted }

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState({
    @Default(EAuthStatus.signedOut) EAuthStatus status,
    @Default('') String errorMessage,

    /// `true` when signed in via Google, `false` for Apple/anonymous. Only
    /// meaningful when `status == EAuthStatus.signedIn`.
    @Default(false) bool isGoogleAccount,

    /// The signed-in user's email, for the Profile artboard's `account`
    /// row. Empty when signed out.
    @Default('') String email,

    /// The Firebase uid. Every remote profile call is scoped by it, and the
    /// edit screen cannot save without one. Empty when signed out.
    @Default('') String uid,

    /// Projection of the stored [UserProfile], so the three avatar surfaces
    /// and the identity line render from the auth state they ALREADY watch
    /// rather than each opening a second subscription.
    @Default('') String firstName,
    @Default('') String lastName,

    /// FILENAME of the cached avatar on disk, resolved through
    /// `AvatarImageStore`. Empty renders the placeholder glyph.
    ///
    /// Never the bytes: a `Uint8List` here forces `DeepCollectionEquality`
    /// into the generated `==`/`hashCode` and the raw bytes into `toString()`,
    /// which is what tombstoned the app when `AppObserver` logged a
    /// transition. See `AvatarImageStore`.
    @Default('') String avatarFilename,
  }) = _AuthState;
}
