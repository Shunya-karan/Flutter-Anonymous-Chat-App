import 'package:flutter/material.dart';

class CustomMessenger {
  static void show(
      BuildContext context, {
        required String message,
        Color bgColor = Colors.black,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,style: TextStyle(
          fontWeight: FontWeight.w600
        ),),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}