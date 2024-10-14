import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_controller.dart';
import 'controllers/home_controller.dart';
import 'views/home_view.dart';
import 'views/login_view.dart';

void main() async {
  runApp(const VerbbAdminApp());
}

class VerbbAdminApp extends StatelessWidget {
  const VerbbAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthController()),
        ChangeNotifierProvider(create: (context) => HomeController())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Verbb Admin App',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF5D5FEF),
          scaffoldBackgroundColor: const Color(0xFF1F1E1E),
          textTheme: const TextTheme(
            bodyText2: TextStyle(color: Colors.white),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF353440),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            hintStyle: const TextStyle(color: Colors.white70),
          ),
        ),
        home: const InitialPage(),
      ),
    );
  }
}

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  void initState() {
    super.initState();

    // Using addPostFrameCallback to call autoLogin after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthController>(context, listen: false).autoLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    if (authController.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (authController.user != null) {
      return const HomeView();
    } else {
      return const LoginView();
    }
  }
}
