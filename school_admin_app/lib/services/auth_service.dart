import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';
import 'api_service.dart';
import 'shared_preference_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ApiService _apiService = ApiService();
  final SharedPreferenceService _sharedPreferenceService =
      SharedPreferenceService();

  // Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // User canceled sign-in

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result =
          await _firebaseAuth.signInWithCredential(credential);
      User? user = result.user;

      if (user != null) {
        // Check if user is registered via API
        final response = await _apiService.verifySchool(user.email!);
        if (response != null) {
          UserModel newUser = UserModel(
            uid: user.uid,
            email: user.email!,
            role: 'school_admin',
            isApproved: response['is_active'] ?? false,
          );
          if (newUser.isApproved) {
            // Save user session
            await _sharedPreferenceService.saveUserSession(
              newUser.email,
              googleAuth.accessToken!,
            );
          }
          return newUser;
        }
      }
    } catch (e) {
      print('Error in signInWithGoogle: $e');
    }
    return null;
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
    await _sharedPreferenceService.clearSession();
  }
}
