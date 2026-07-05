import 'dart:async';

import 'package:flutter/material.dart';
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

    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;
    //
    // Navigator.pushReplacement(
    //   context,
    //   // MaterialPageRoute(
    //     // builder: (_) => const HomePage(),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(

        child: Center(

          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [

              Image.asset(
                "assets/images/logo.png",
                width: 100,
                height: 100,
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Talk",
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge,
                  ),Text(
                    " Loop",
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary
                    ),

                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text("Connect. Chat. Stay Anonymous.",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium,
              ),

              const SizedBox(height: 50),

              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}