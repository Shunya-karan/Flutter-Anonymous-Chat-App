import 'package:flutter/material.dart';

class InterestScreen extends StatefulWidget {
  const InterestScreen({super.key});

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  final List<String> interests = [
    "Coding",
    "Gaming",
    "Movies",
    "Anime",
    "Music",
    "Sports",
  ];


  List<String> selectedInterest = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Interests"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Choose your interests to find people with similar preferences.",
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 30),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: interests.map((interest) {
                  final isSelected =
                  selectedInterest.contains(interest);

                  return FilterChip(
                    label: Text(interest),
                    selected: isSelected,
                    onSelected: (value) {
                      setState(() {
                        if (value) {
                          selectedInterest.add(interest);
                        } else {
                          selectedInterest.remove(interest);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        selectedInterest,
                      );
                    },
                    child: Text(
                      selectedInterest.isEmpty
                          ? "Continue"
                          : "Continue (${selectedInterest.length})",
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context, []);
                  },
                  child: const Text(
                    "Skip",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
