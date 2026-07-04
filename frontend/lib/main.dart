import 'package:flutter/material.dart';
import 'services/socket_service.dart';
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
      home: HomePage(socketService),
    );
  }
}

