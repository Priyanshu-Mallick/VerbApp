import 'dart:convert';

import '../models/user_model.dart';
import 'api_service.dart';
import 'shared_preference_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final SharedPreferenceService _sharedPreferenceService =
      SharedPreferenceService();

  Future<UserModel> login(String email, String password) async {
    print("Email: $email Password: $password");
    try {
      final response = await _apiService.post(
          '/token',
          {
            'username': email,
            'password': password,
          },
          contentType: 'application/x-www-form-urlencoded');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String accessToken = data['access_token'];

        // Save the login session in shared preferences
        await _sharedPreferenceService.saveUserSession(email, accessToken);

        // Return UserModel with email and token
        return UserModel(email: email, accessToken: accessToken);
      } else {
        print('Error code: ${response.statusCode}');
        print(response.body);
        throw Exception('Invalid email or password');
      }
    } catch (error) {
      throw Exception('Failed to authenticate: $error');
    }
  }

  Future<void> signOut() async {
    await _sharedPreferenceService.clearSession();
  }
}
