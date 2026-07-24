import 'package:flutter/material.dart';
import 'package:frontend/core/network/apiClient.dart';
import 'package:frontend/core/theme/darkTheme.dart';
import 'package:frontend/core/theme/lightTheme.dart';
import 'package:frontend/screens/auth/login_screen.dart';
import 'package:frontend/screens/auth/profile_setup_screen.dart';
import 'package:frontend/screens/auth/register_screen.dart';
import 'package:frontend/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/theme/themeprovider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ApiClient.initialize();

  runApp(ChangeNotifierProvider(
      create: (_)=>ThemeProvider(),
      child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider =Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: LightTheme.theme,
      darkTheme: DarkTheme.theme,
      themeMode: themeProvider.themeMode,
      home: const SplashScreen(),
    );
  }
}

