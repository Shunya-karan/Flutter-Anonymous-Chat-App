import 'package:flutter/material.dart';

class CustomeMessanger extends StatelessWidget {
  final String message;
  const CustomeMessanger({super.key,
          required this.message
  });

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child: SnackBar(content: Text(message)));
  }
}
