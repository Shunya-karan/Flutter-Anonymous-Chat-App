import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String username;
  final String? bio;
  final String? profileImage;

  const ProfileHeader({
    super.key,
    required this.username,
    this.bio,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = profileImage?.isNotEmpty ?? false;
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: theme.colorScheme.surface,
            backgroundImage:
            hasImage ? NetworkImage(profileImage!) : null,
            child: !hasImage
                ? Icon(
              Icons.person_rounded,
              size: 60,
              color: theme.colorScheme.primary,
            )
                : null,
          ),
        ),

        const SizedBox(height: 20),

        Text(
          username,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            (bio?.trim().isNotEmpty ?? false)
                ? bio!
                : "No bio added yet.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}