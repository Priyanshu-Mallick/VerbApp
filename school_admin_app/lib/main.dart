import 'package:firebase_core/firebase_core.dart'; // Add Firebase core
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_controller.dart';
import 'services/shared_preference_service.dart';
import 'views/home_view.dart';
import 'views/login_view.dart';
import 'views/not_registered_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>(
          create: (_) => AuthController(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'School Admin App',
        theme: ThemeData.dark(),
        initialRoute: '/',
        routes: {
          '/': (context) => InitialPage(),
          '/home': (context) => const HomeView(),
          '/not_registered': (context) => const NotRegisteredView(),
        },
      ),
    );
  }
}

class InitialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);
    return FutureBuilder(
      future: Future.wait([
        Firebase.initializeApp(), // Firebase initialization
        SharedPreferenceService().isLoggedIn(), // Check if user is logged in
      ]),
      builder: (ctx, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final isLoggedIn = snapshot.data?[1] == true;
        if (isLoggedIn) {
          return const HomeView();
        } else {
          return const LoginView();
        }
      },
    );
  }
}
