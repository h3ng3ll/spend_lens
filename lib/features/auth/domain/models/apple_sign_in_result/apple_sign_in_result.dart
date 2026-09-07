import 'package:firebase_auth/firebase_auth.dart';

import '../apple_credentials/apple_credentials.dart';

/// The Firebase credential alongside the [AppleCredentials] Apple provided
/// for this authorization (design_spendlens.md §9).
class AppleSignInResult {
  final UserCredential userCredential;
  final AppleCredentials credentials;

  const AppleSignInResult({
    required this.userCredential,
    required this.credentials,
  });
}
