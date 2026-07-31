import 'package:flutter/material.dart';
import 'package:frontend/core/network/apiClient.dart';
import 'package:frontend/providers/userprovider.dart';
import 'package:frontend/theme/darkTheme.dart';
import 'package:frontend/theme/lightTheme.dart';
import 'package:frontend/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/themeprovider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ApiClient.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_){
            final provider=ThemeProvider();
            provider.LoadTheme();
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: const MyApp(),
    ),
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

