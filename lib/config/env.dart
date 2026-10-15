import 'package:flutter/services.dart' show appFlavor;

enum AppEnvironment { staging, production }

/// Build-time environment config.
///
/// Values come from `env/<flavor>.json`, passed with
/// `--flavor <flavor> --dart-define-from-file=env/<flavor>.json`.
class Env {
  Env._();

  static const String _flavor = String.fromEnvironment('FLAVOR');
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');
  static const String appName = String.fromEnvironment('APP_NAME',
      defaultValue: 'Petsmore Telemarketing');

  static AppEnvironment get environment =>
      AppEnvironment.values.byName(_flavor);

  static bool get isProduction => environment == AppEnvironment.production;

  /// Fails fast at startup so a build can never run against the wrong backend.
  static void validate() {
    const hint =
        'Run with --flavor <staging|production> --dart-define-from-file=env/<flavor>.json';
    if (_flavor.isEmpty || apiBaseUrl.isEmpty) {
      throw StateError('Environment not configured. $hint');
    }
    if (!AppEnvironment.values.any((e) => e.name == _flavor)) {
      throw StateError('Unknown FLAVOR "$_flavor". $hint');
    }
    if (appFlavor != _flavor) {
      throw StateError(
          'Native flavor "$appFlavor" does not match env file "$_flavor". $hint');
    }
    if (!apiBaseUrl.startsWith('https://')) {
      throw StateError('API_BASE_URL must use https.');
    }
  }
}
