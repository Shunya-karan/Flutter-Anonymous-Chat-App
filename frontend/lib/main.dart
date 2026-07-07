import 'package:flutter/material.dart';
import 'package:frontend/core/network/apiClient.dart';
import 'package:frontend/core/theme/darkTheme.dart';
import 'package:frontend/core/theme/lightTheme.dart';
import 'package:frontend/screens/auth/login_screen.dart';
import 'package:frontend/screens/auth/profile_setup_screen.dart';
import 'package:frontend/screens/auth/register_screen.dart';
import 'package:frontend/screens/splash/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ApiClient.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: LightTheme.theme,
      home: const SplashScreen(),
    );
  }
}

