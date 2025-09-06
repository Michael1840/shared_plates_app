import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  late SharedPreferences prefs;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
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

  Future<void> clearTokens() async {
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }
}
