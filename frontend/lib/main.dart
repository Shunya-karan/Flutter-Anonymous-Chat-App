import 'package:flutter/material.dart';
import 'package:frontend/core/theme/darkTheme.dart';
import 'package:frontend/core/theme/lightTheme.dart';
import 'package:frontend/screens/auth/login_screen.dart';
import 'package:frontend/screens/auth/register_screen.dart';
import 'package:frontend/screens/splash/splash_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: LightTheme.theme,
      home: const RegisterScreen(),
    );
  }
}

