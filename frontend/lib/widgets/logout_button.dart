import 'package:flutter/material.dart';
import 'package:frontend/core/network/socket_service.dart';
import 'package:frontend/core/storage/shared_pref_service.dart';
import 'package:frontend/screens/auth/login_screen.dart';

class LogoutButton extends StatelessWidget {

  final VoidCallback onPressed;

  const LogoutButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Future<void>Logout()async{
      await SharedPrefService.removeToken();
      SocketService.instance.disconnect();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_)=>LoginScreen()
          ), (_)=>false);
    }

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

        onPressed: Logout,
      ),
    );
  }
}