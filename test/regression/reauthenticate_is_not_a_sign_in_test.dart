import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// REGRESSION: `reauthenticate()` was a SIGN-IN, not a re-authentication.
///
/// It called `signInWithGoogle()` / `signInWithApple()`, which end in
/// `_auth.signInWithCredential(...)` / `_auth.signInWithProvider(...)`. Those
/// start a NEW session rather than re-verifying the existing user, which
/// caused two defects during account deletion:
///
///   1. An account chooser appeared, listing every Google account on the
///      device — `authenticate()` on google_sign_in v7 is always the
///      interactive path and takes no account hint.
///   2. Picking a different account swapped the session, so the flow deleted
///      the WRONG account while the intended one survived with its data.
///
/// A source test because the defect is a matter of WHICH Firebase API is
/// called. `flutter analyze` is blind to it — both spellings compile, and the
/// wrong one only misbehaves on a real device with more than one account.
void main() {
  late String source;

  /// Strips comments, so prose DESCRIBING the old defect cannot trip the scan
  /// that forbids it — the same convention `security_rules_cover_paths_test`
  /// and `no_commented_out_code_test` use.
  String stripComments(String input) => input
      .split('\n')
      .map((line) {
        final trimmed = line.trimLeft();
        if (trimmed.startsWith('//')) return '';
        final index = line.indexOf('//');
        return index == -1 ? line : line.substring(0, index);
      })
      .join('\n');

  setUp(() {
    final file = File(
      'lib/features/auth/data/repositories/firebase_auth_repository.dart',
    );
    expect(file.existsSync(), isTrue);
    source = stripComments(file.readAsStringSync());
  });

  /// `reauthenticate()` plus the private helpers it delegates to, which is
  /// the whole re-authentication path. The public sign-in methods are
  /// deliberately excluded: they SHOULD sign in.
  String reauthPath() {
    final start = source.indexOf('Future<Either<Failure, Unit>> reauthenticate(');
    expect(start, isNot(-1));
    return source.substring(start);
  }

  test('re-verifies the existing user instead of signing in again', () {
    expect(
      reauthPath(),
      contains('reauthenticateWithCredential'),
      reason: 'only this re-verifies the CURRENT user in place; a sign-in can '
          'return a different account',
    );
  });

  test('never starts a new session on the re-auth path', () {
    final path = reauthPath();

    expect(
      path,
      isNot(contains('_auth.signInWithCredential')),
      reason: 'THE BUG: this replaced the session instead of refreshing it',
    );
    expect(path, isNot(contains('_auth.signInWithProvider')));
    expect(
      path,
      isNot(contains('await signInWithGoogle()')),
      reason: 'the sign-in path shows the account chooser',
    );
    expect(path, isNot(contains('await signInWithApple()')));
  });

  test('verifies the refreshed credential belongs to the same user', () {
    expect(
      reauthPath(),
      contains('_reauthenticatedAs'),
      reason: 'the returned uid must be compared, not discarded — discarding '
          'it is what allowed the wrong account to be deleted',
    );
  });

  test('prefers the silent path so no account chooser appears', () {
    expect(
      reauthPath(),
      contains('attemptSilent'),
      reason: 'authenticate() always shows the chooser on v7; the silent '
          'attempt is what keeps it off screen',
    );
  });

  test('the genuine sign-in path still signs in', () {
    // The control: this fix must not disturb first authentication.
    final signIn = source.substring(
      source.indexOf('Future<Either<Failure, UserCredential>> signInWithGoogle('),
    );
    expect(signIn.contains('_auth.signInWithCredential'), isTrue);
  });
}
