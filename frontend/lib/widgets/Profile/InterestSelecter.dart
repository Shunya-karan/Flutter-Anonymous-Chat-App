import 'package:flutter/material.dart';

class InterestSelector extends StatelessWidget {
  final List<String> selectedInterests;
  final ValueChanged<List<String>> onChanged;

  const InterestSelector({super.key,
  required this.selectedInterests,
    required this.onChanged
  });

  static const List<String> interests =  [
    "Sports",
    "Gaming",
    "Music",
    "Coding",
    "Movies",
    "Books",
    "Travel",
    "Food",
    "Photography",
    "Fitness",
    "Technology",
    "Art",
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: interests.map((interest) {
          final selected = selectedInterests.contains(interest);
          return FilterChip(
            label: Text(interest),
            selected: selected,
            onSelected: (_) {
              final updatedInterests = List<String>.from(selectedInterests);
                if (selected) {
                  updatedInterests.remove(
                      interest);
                } else {
                  updatedInterests.add(
                      interest);
                }
                onChanged(updatedInterests);
            },
          );

        }).toList(),
      );
  }
}
