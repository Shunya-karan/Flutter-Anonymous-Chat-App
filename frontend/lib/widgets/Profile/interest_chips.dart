import 'package:flutter/material.dart';

class InterestChips extends StatelessWidget {
  final List<String> interests;

  const InterestChips({
    super.key,
    required this.interests,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (interests.isEmpty) {
      return Text(
        "No interests selected",
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: interests.map((interest) {
        return Chip(
          avatar: Icon(
            Icons.interests,
            size: 18,
            color: theme.colorScheme.primary,
          ),
          label: Text(
            interest,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor:
          theme.colorScheme.primaryContainer.withOpacity(0.5),
          side: BorderSide(
            color: theme.colorScheme.primary.withOpacity(0.2),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      }).toList(),
    );
  }
}