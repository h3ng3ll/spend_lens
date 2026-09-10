import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards the defect this test is named for: `AuthBloc` set
/// `EAuthStatus.failed` with a user-facing `errorMessage`, and NOTHING in
/// the widget tree read it. A real sign-in failure was therefore silent —
/// the button appeared to do nothing, which is indistinguishable from being
/// unwired and invisible to `flutter analyze`.
///
/// A source scan rather than a widget pump: the regression is structural
/// ("is a listener attached at all?"), and pumping `ProfilePage` would drag
/// in Firebase, get_it and Hive to assert something a grep states directly.
void main() {
  final profilePage = File(
    'lib/features/auth/presentation/pages/profile_page/profile_page.dart',
  );

  test('ProfilePage attaches a BlocListener for AuthBloc', () {
    final source = profilePage.readAsStringSync();
    expect(
      source.contains('BlocListener<AuthBloc, AuthState>'),
      isTrue,
      reason:
          'Without an AuthBloc listener a failed sign-in sets errorMessage '
          'that no widget renders, so the failure is silent.',
    );
  });

  test('the listener actually surfaces the message', () {
    final source = profilePage.readAsStringSync();
    expect(
      source.contains('UiMessageService.showError(state.errorMessage)'),
      isTrue,
      reason: 'The listener must render errorMessage, not just observe it.',
    );
  });

  test('an empty message is not surfaced — cancellation must stay quiet', () {
    // The bloc maps a user cancellation to signedOut with an EMPTY message.
    // Toasting that would tell someone who dismissed the Google sheet that
    // sign-in "failed", which is both wrong and annoying.
    final source = profilePage.readAsStringSync();
    expect(
      source.contains('if (state.errorMessage.isEmpty) return;'),
      isTrue,
      reason: 'A cancellation carries no message and must not toast.',
    );
  });

  _googleCancellationGuard();

  test('the watch stream error carries a message, not a blank toast', () {
    final bloc = File(
      'lib/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart',
    ).readAsStringSync();

    // `onError: (_, _) => copyWith(status: failed)` left errorMessage empty,
    // so even a correct listener would have shown an empty toast.
    final onErrorIndex = bloc.indexOf('onError:');
    expect(onErrorIndex, greaterThan(-1));
    final onErrorBlock = bloc.substring(
      onErrorIndex,
      (onErrorIndex + 400).clamp(0, bloc.length),
    );
    expect(
      onErrorBlock.contains('errorMessage'),
      isTrue,
      reason:
          'A failed status with no message renders as a blank toast — worse '
          'than silence, since it looks broken and says nothing.',
    );
  });
}

/// Guards the Android-specific misclassification found on device.
///
/// Credential Manager reports an OAuth rejection (unregistered signing
/// SHA-1) as `GoogleSignInExceptionCode.canceled` with the description
/// "[16] Cancelled by user." — verified in a live `flutter run` log. The
/// plugin cannot distinguish that from a real dismissal, so the app was
/// silently suppressing a genuine configuration failure: Google appeared to
/// do nothing while Apple correctly reported its error.
void _googleCancellationGuard() {
  final repository = File(
    'lib/features/auth/data/repositories/firebase_auth_repository.dart',
  );

  test('a Google `canceled` with a description is NOT treated as silent', () {
    final source = repository.readAsStringSync();
    expect(
      source.contains('e.description == null || e.description!.isEmpty'),
      isTrue,
      reason:
          'Android reports an OAuth rejection as `canceled` with a '
          'description. Suppressing every `canceled` hides real failures.',
    );
  });
}
