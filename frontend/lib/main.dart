import 'package:flutter/material.dart';
import 'package:frontend/core/network/apiClient.dart';
import 'package:frontend/core/network/networkService.dart';
import 'package:frontend/providers/userProvider.dart';
import 'package:frontend/theme/darkTheme.dart';
import 'package:frontend/theme/lightTheme.dart';
import 'package:frontend/screens/splash/splashScreen.dart';
import 'package:frontend/widgets/CustomWidgets/ntworkErrorBanner.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/themeProvider.dart';

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isOffline = false;

  @override
  void initState() {
    super.initState();
    NetworkService.instance.start(
      onChanged: (connected) {
        if (!mounted) return;

        setState(() {
          isOffline = !connected;
        });
      },
    );
  }

  @override
  void dispose() {
    NetworkService.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider =Provider.of<ThemeProvider>(context);
    return MaterialApp(
      builder: (context,child){
        return Stack(
          children: [
            child ?? const SizedBox(),

            if (isOffline)
              const NetworkErrorBanner(),
          ],
        );
      },
      debugShowCheckedModeBanner: false,
      theme: LightTheme.theme,
      darkTheme: DarkTheme.theme,
      themeMode: themeProvider.themeMode,
      home: const SplashScreen(),
    );
  }
}

