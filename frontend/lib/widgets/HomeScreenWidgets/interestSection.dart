import 'package:flutter/material.dart';

class InterestsCard extends StatelessWidget {
  final List<String> interests;

  const InterestsCard({
    super.key,
    required this.interests,
  });

  IconData _getInterestIcon(String interest) {
    switch (interest.toLowerCase()) {
      case "coding":
        return Icons.code;
      case "gaming":
        return Icons.sports_esports;
      case "music":
        return Icons.music_note;
      case "sports":
        return Icons.sports_soccer;
      case "movies":
        return Icons.movie;
      case "books":
        return Icons.menu_book;
      case "travel":
        return Icons.flight;
      case "food":
        return Icons.restaurant;
      case "photography":
        return Icons.camera_alt;
      case "fitness":
        return Icons.fitness_center;
      case "technology":
        return Icons.memory;
      case "art":
        return Icons.palette;
      default:
        return Icons.interests;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme
        .of(context)
        .colorScheme
        .primary;

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Interests",
                style: Theme
                    .of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Find people with similar hobbies.",
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  // color: Colors.grey,
                ),
              ),

              const SizedBox(height: 20),

              Wrap(
                spacing: 15,
                runSpacing: 15,
                children: interests.map((interest) {
                  return Chip(
                    avatar: Icon(
                      _getInterestIcon(interest),
                      size: 18,
                      color: primary,
                    ),

                    label: Text(
                      interest,
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    backgroundColor:
                    primary.withOpacity(.08),

                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(30),
                    ),

                    side: BorderSide.none,

                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}