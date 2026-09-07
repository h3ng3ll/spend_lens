import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Nonce generation/hashing for Sign in with Apple's replay-protection
/// handshake (design_spendlens.md §9 bug 2).
///
/// Apple's flow requires a RAW nonce sent to Firebase and a SHA-256 HASH of
/// that same nonce sent to Apple — the two must be paired, or Firebase
/// cannot verify the Apple identity token came from the same request this
/// app started. Fixing bug 2 is exactly making both halves of that pairing
/// actually happen — see `firebase_auth_repository.dart`'s `_iosCall()`.
class CryptoService {
  const CryptoService();

  static const int _defaultNonceLength = 32;

  /// Generates a cryptographically secure random nonce.
  String generateNonce([int length = _defaultNonceLength]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  /// Returns the SHA-256 hash of [input] as a lowercase hex string.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
