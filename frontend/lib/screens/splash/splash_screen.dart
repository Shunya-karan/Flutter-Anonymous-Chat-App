import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/core/network/socket_service.dart';
import 'package:frontend/core/storage/shared_pref_service.dart';
import 'package:frontend/screens/auth/login_screen.dart';
import 'package:frontend/screens/home/homeScreen.dart';

// import '../auth/login_screen.dart';
// import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    _navigate();
  }

  Future<void> _navigate() async {

    await Future.delayed(const Duration(seconds: 2));

    final token=await SharedPrefService.getToken();
    if (!mounted) return;

    if(token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
      return;
    }

      SocketService.instance.connect(token);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const Spacer(),

              // Logo
              Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Image.asset(
                    "assets/images/LOGO.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // App Name
              RichText(
                text: TextSpan(
                  style: theme.textTheme.headlineLarge,
                  children: [
                    const TextSpan(text: "Talk"),
                    TextSpan(
                      text: " Loop",
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Connect. Chat. Stay Anonymous.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  letterSpacing: 0.3,
                ),
              ),

              const Spacer(),

              Column(
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: theme.colorScheme.primary,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    "Loading...",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }}