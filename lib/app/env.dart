enum AppEnvironment { dev, prod }

abstract final class Env {
  static const _name = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseKey = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

  static AppEnvironment get environment =>
      _name == 'prod' ? AppEnvironment.prod : AppEnvironment.dev;

  static bool get isDev => environment == AppEnvironment.dev;

  static bool get hasBackend =>
      supabaseUrl.isNotEmpty && supabaseKey.isNotEmpty;

  static const shareBaseUrl = String.fromEnvironment(
    'SHARE_BASE_URL',
    defaultValue: 'https://sharedplates.app',
  );

  static const testEmail = String.fromEnvironment('TEST_EMAIL');
  static const testPassword = String.fromEnvironment('TEST_PASSWORD');

  static bool get hasTestAccount =>
      isDev && hasBackend && testEmail.isNotEmpty && testPassword.isNotEmpty;
}
