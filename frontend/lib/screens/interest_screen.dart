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

  final Map<String, IconData> interestIcons = {
    "Coding": Icons.code_rounded,
    "Gaming": Icons.sports_esports_rounded,
    "Movies": Icons.movie_rounded,
    "Anime": Icons.theater_comedy_rounded,
    "Music": Icons.music_note_rounded,
    "Sports": Icons.sports_basketball_rounded,
  };

  List<String> selectedInterest = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Select Interests",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1530),
              Color(0xFF2B1B4A),
              Color(0xFF12101D),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Pick a few topics and we'll try to match you with someone who's into the same things.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.55),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: interests.map((interest) {
                      final isSelected = selectedInterest.contains(interest);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedInterest.remove(interest);
                            } else {
                              selectedInterest.add(interest);
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 14),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? const LinearGradient(
                              colors: [
                                Color(0xFF8B5CF6),
                                Color(0xFFEC4899),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                                : null,
                            color: isSelected
                                ? null
                                : Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : Colors.white24,
                            ),
                            boxShadow: isSelected
                                ? [
                              BoxShadow(
                                color: const Color(0xFF8B5CF6)
                                    .withOpacity(0.4),
                                blurRadius: 14,
                                spreadRadius: 1,
                              ),
                            ]
                                : [],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                interestIcons[interest] ?? Icons.tag_rounded,
                                size: 18,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white70,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                interest,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white70,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.check_circle_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, selectedInterest);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEC4899),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                          elevation: 6,
                          shadowColor: const Color(0xFFEC4899).withOpacity(0.5),
                        ),
                        child: Text(
                          selectedInterest.isEmpty
                              ? "Continue"
                              : "Continue (${selectedInterest.length})",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedInterest = [];
                        });
                        Navigator.pop(context, selectedInterest);
                      },
                      child: Text(
                        "Skip — match with anyone",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}