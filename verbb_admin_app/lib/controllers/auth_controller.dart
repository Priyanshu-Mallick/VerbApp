import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/shared_preference_service.dart';

class AuthController with ChangeNotifier {
  final AuthService _authService = AuthService();
  final SharedPreferenceService _sharedPreferenceService =
      SharedPreferenceService();

  UserModel? _user;
  UserModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Sign in using email and password
  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    try {
      _user = await _authService.login(email, password);
      _errorMessage = null;
    } catch (error) {
      _errorMessage = error.toString();
    }
    _setLoading(false);
  }

  // Auto sign-in if session exists
  Future<void> autoLogin() async {
    _setLoading(true);
    bool loggedIn = await _sharedPreferenceService.isLoggedIn();
    if (loggedIn) {
      String? email = await _sharedPreferenceService.getEmail();
      String? token = await _sharedPreferenceService.getAccessToken();
      if (email != null && token != null) {
        _user = UserModel(email: email, accessToken: token);
      }
    }
    _setLoading(false);
  }

  // Sign out
  void signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
