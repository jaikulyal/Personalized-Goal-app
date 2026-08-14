import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _accessTokenKey = 'access_token';

  Future<void> saveAccessToken(String token) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(_accessTokenKey, token);
  }

  Future<String?> getAccessToken() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getString(_accessTokenKey);
  }

  Future<void> clearAccessToken() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(_accessTokenKey);
  }
}
