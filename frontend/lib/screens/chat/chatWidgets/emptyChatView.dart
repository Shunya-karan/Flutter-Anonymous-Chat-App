import 'package:flutter/material.dart';

class EmptyChatView extends StatelessWidget {
  const EmptyChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "You are connected.\nSay hello",
        textAlign: TextAlign.center,
      ),
    );
  }
}
