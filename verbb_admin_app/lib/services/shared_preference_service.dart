import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _accessTokenKey = 'accessToken';
  static const String _emailKey = 'email';

  // Save login status and user info
  Future<void> saveUserSession(String email, String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_emailKey, email);
  }

  // Check if the user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Get stored email
  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  // Get stored access token
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Clear the session (used for logout)
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all saved preferences
  }
}
