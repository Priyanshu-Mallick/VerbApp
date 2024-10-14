import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import 'home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // FocusNodes for email and password fields
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String? emailErrorMessage;
  String? passwordErrorMessage;

  @override
  void initState() {
    super.initState();

    // Add listeners to focus nodes to validate fields when focus is lost
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        _validateEmail();
      }
    });

    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        _validatePassword();
      }
    });
  }

  // Email validation function
  void _validateEmail() {
    setState(() {
      if (emailController.text.isEmpty) {
        emailErrorMessage = 'Email cannot be empty';
      } else if (!RegExp(
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(emailController.text)) {
        emailErrorMessage = 'Enter a valid email address';
      } else {
        emailErrorMessage = null; // Clear error if valid
      }
    });
  }

  // Password validation function
  void _validatePassword() {
    setState(() {
      if (passwordController.text.isEmpty) {
        passwordErrorMessage = 'Password cannot be empty';
      } else if (passwordController.text.length < 6) {
        passwordErrorMessage = 'Password must be at least 6 characters long';
      } else {
        passwordErrorMessage = null; // Clear error if valid
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Consumer<AuthController>(
          builder: (context, authController, _) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Email label
                  const Text(
                    'Email',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Email TextField with validation
                  TextFormField(
                    controller: emailController,
                    focusNode:
                        _emailFocusNode,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'admin@verbb.in',
                      hintStyle: const TextStyle(color: Colors.white54),
                      errorText:
                          emailErrorMessage,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  // Password label
                  const Text(
                    'Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Password TextField with validation
                  TextFormField(
                    controller: passwordController,
                    focusNode:
                        _passwordFocusNode,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Admin1234',
                      hintStyle: const TextStyle(color: Colors.white54),
                      errorText:
                          passwordErrorMessage,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  // Display error message if any from backend
                  if (authController.errorMessage != null)
                    Text(
                      authController.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  // Sign-in button
                  ElevatedButton(
                    onPressed: authController.isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState?.validate() == true &&
                                emailErrorMessage == null &&
                                passwordErrorMessage == null) {
                              // Remove existing error messages
                              setState(() {
                                emailErrorMessage = null;
                                passwordErrorMessage = null;
                              });

                              // Attempt to log in
                              await authController.signIn(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                              if (authController.user != null) {
                                // Navigate to another screen if login is successful
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeView(),
                                  ),
                                );
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Adding corner radius
                      ),
                    ),
                    child: authController.isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          )
                        : const Text(
                            'Sign in',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of FocusNodes when done to avoid memory leaks
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
