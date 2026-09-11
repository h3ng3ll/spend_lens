import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// App environment configuration.
///
/// design_spendlens.md binding decision 1: NO dev/prod flavors. One concrete
/// [ConcreteEnv], one `.env`, no `EnvHelper`, no `--dart-define=DARTENV`, no
/// flavored `firebase_options`. Values are read from the single bundled
/// `.env` (see `.env.example` for the placeholder shape); the file itself is
/// gitignored and never committed with real values.
abstract class Env {
  String get googleServerClientId;

  String get googleIosClientId;

  String get googleIosReversedClientId;

  String get appHudApiKey;

  String get revenueCatKey;

  int get freeReceiptLimit;
}

/// The single, concrete environment. No subclasses, no flavor switch.
class ConcreteEnv implements Env {
  static const int _defaultFreeReceiptLimit = 50;

  @override
  String get googleServerClientId => dotenv.get(
    'GOOGLE_SERVER_CLIENT_ID',
    fallback: '',
  );

  @override
  String get googleIosClientId => dotenv.get(
    'GOOGLE_IOS_CLIENT_ID',
    fallback: '',
  );

  @override
  String get googleIosReversedClientId => dotenv.get(
    'GOOGLE_IOS_REVERSED_CLIENT_ID',
    fallback: '',
  );

  @override
  String get appHudApiKey => Platform.isAndroid
      ? dotenv.get(
          'APPHUD_GOOGLE_PLAY_API_KEY',
          fallback: '',
        )
      : dotenv.get(
          'APPHUD_APP_STORE_API_KEY',
          fallback: '',
        );

  @override
  int get freeReceiptLimit {
    final raw = dotenv.maybeGet(
      'FREE_RECEIPT_LIMIT',
    );
    if (raw == null || raw.isEmpty) return _defaultFreeReceiptLimit;
    return int.tryParse(raw) ?? _defaultFreeReceiptLimit;
  }

  @override
  String get revenueCatKey => dotenv.get(
    'REVENUE_CAT_KEY',
    fallback: '',
  );
}
