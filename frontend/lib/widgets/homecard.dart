import 'package:flutter/material.dart';

class HeroCard extends StatelessWidget {
  final bool isSearching;

  const HeroCard({
    super.key,
    required this.isSearching,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primary,
            primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(
            isSearching
                ? Icons.search
                : Icons.people_alt_rounded,
            color: Colors.white,
            size: 60,
          ),

          const SizedBox(height: 20),

          Text(
            isSearching
                ? "Searching..."
                : "Ready to Meet Someone?",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            isSearching
                ? "We're finding someone who shares your interests."
                : "Start an anonymous conversation with people from around the world.",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}