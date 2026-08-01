import 'package:flutter/material.dart';

class WelcomeHeader extends StatelessWidget {
  final String username;

  const WelcomeHeader({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: size.width * 0.16,
          width: size.width * 0.16,
          constraints: const BoxConstraints(
            minHeight: 58,
            minWidth: 58,
            maxHeight: 72,
            maxWidth: 72,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18),

            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.15),
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Image.asset(
            "assets/images/LOGO.png",
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),

        Material(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          elevation: 2,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Scaffold.of(context).openEndDrawer();
            },
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.15),
                ),
              ),
              child: Icon(
                Icons.menu_outlined,
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}