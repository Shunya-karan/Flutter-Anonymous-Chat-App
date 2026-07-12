import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return ListTile(

      leading: CircleAvatar(
        radius: 18,
        backgroundColor:
        Theme.of(context).colorScheme.primary.withOpacity(.1),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),

      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),

      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 18,
      ),

      onTap: onTap,
    );
  }
}