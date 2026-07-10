import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {

  final VoidCallback onPressed;

  const LogoutButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(

        icon: const Icon(
          Icons.logout,
          color: Colors.red,
        ),

        label: const Text(
          "Logout",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),

        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),
          side: const BorderSide(
            color: Colors.red,
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(16),
          ),
        ),

        onPressed: onPressed,
      ),
    );
  }
}