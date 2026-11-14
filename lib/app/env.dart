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
}
