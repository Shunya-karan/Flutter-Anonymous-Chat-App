import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/themeprovider.dart';

class AppearanceDialog extends StatelessWidget {
  const AppearanceDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return AlertDialog(
          title: const Text("Appearance"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                contentPadding: EdgeInsets.zero,
                title: const Text("System Default"),
                value: ThemeMode.system,
                groupValue: themeProvider.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    themeProvider.setTheme(value);
                    Navigator.pop(context);
                  }
                },
              ),

              RadioListTile<ThemeMode>(
                contentPadding: EdgeInsets.zero,
                title: const Text("Light"),
                value: ThemeMode.light,
                groupValue: themeProvider.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    themeProvider.setTheme(value);
                    Navigator.pop(context);
                  }
                },
              ),

              RadioListTile<ThemeMode>(
                contentPadding: EdgeInsets.zero,
                title: const Text("Dark"),
                value: ThemeMode.dark,
                groupValue: themeProvider.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    themeProvider.setTheme(value);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

    