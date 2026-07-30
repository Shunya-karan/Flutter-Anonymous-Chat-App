import 'package:flutter/material.dart';

class CustomMessenger {
  static void show(
      BuildContext context, {
        required String message,
        Color bgColor = Colors.black,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor,
      ),
    );
  }
}