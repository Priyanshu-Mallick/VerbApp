import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthController with ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> signInWithGoogle(BuildContext context) async {
    _setLoading(true);
    _user = await _authService.signInWithGoogle();
    if (_user == null || !_user!.isApproved) {
      _errorMessage = 'Login failed or user not approved';
      Navigator.pushReplacementNamed(context, '/not_registered');
    } else {
      _errorMessage = null;
      Navigator.pushReplacementNamed(context, '/home');
    }
    _setLoading(false);
  }

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
