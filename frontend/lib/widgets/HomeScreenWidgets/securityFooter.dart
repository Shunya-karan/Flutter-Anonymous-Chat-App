import 'package:flutter/material.dart';
import 'package:frontend/theme/lightTheme.dart';

class Securityfooter extends StatelessWidget {
  const Securityfooter({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final iconColor = Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: double.infinity,
      child: Card(
        clipBehavior: Theme.of(context).cardTheme.clipBehavior,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildItem(Icons.lock, "Anonymous", iconColor, textStyle),
              _buildItem(Icons.bolt, "Fast Match", iconColor, textStyle),
              _buildItem(Icons.shield, "Secure", iconColor, textStyle),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String label, Color color, TextStyle? style) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text(label, style: style),
      ],
    );
  }
}