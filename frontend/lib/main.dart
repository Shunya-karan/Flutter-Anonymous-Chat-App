import 'package:flutter/material.dart';
import 'package:frontend/core/theme/darkTheme.dart';
import 'package:frontend/core/theme/lightTheme.dart';
import 'package:frontend/screens/auth/login_screen.dart';
import 'package:frontend/screens/splash/splash_screen.dart';
import 'core/network/socket_service.dart';
import 'screens/home/homeScreen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final SocketService socketService = SocketService();

  @override
  Widget build(BuildContext context) {
    socketService.connect();

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: LightTheme.theme,
      // darkTheme: DarkTheme.theme,
      // themeMode: ThemeMode.system,

      home: LoginScreen(),
    );
  }
}

