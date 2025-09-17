import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  late SharedPreferences prefs;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _onboardingKey = 'onboarding_key';

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> setOnboardingCompleted() async {
    await prefs.setBool(_onboardingKey, true);
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<String?> getAccessToken() async {
    return prefs.getString(_accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return prefs.getString(_refreshTokenKey);
  }

  Future<bool?> getOnboarding() async {
    return prefs.getBool(_onboardingKey);
  }

  Future<void> clearTokens() async {
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }
}
