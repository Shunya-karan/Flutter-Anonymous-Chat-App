import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RateTalkLoopScreen extends StatefulWidget {
  const RateTalkLoopScreen({super.key});

  @override
  State<RateTalkLoopScreen> createState() =>
      _RateTalkLoopScreenState();
}

class _RateTalkLoopScreenState
    extends State<RateTalkLoopScreen> {

  int selectedRating = 0;

  // Replace this with your actual Play Store URL
  static const String playStoreUrl =
      "https://play.google.com/store/apps/details?id=YOUR_PACKAGE_NAME";

  Future<void> rateApp() async {
    final uri = Uri.parse(playStoreUrl);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to open Play Store."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rate TalkLoop"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            Icon(
              Icons.star_rounded,
              size: 80,
              color: theme.colorScheme.primary,
            ),

            const SizedBox(height: 24),

            Text(
              "Enjoying TalkLoop?",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            Text(
              "Your feedback helps us improve TalkLoop.",
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 35),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                    (index) {
                  final rating = index + 1;

                  return IconButton(
                    onPressed: () {
                      setState(() {
                        selectedRating = rating;
                      });
                    },
                    icon: Icon(
                      rating <= selectedRating
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      size: 42,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed:
                selectedRating == 0 ? null : rateApp,
                child: const Text(
                  "Rate TalkLoop",
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              "You'll be taken to the Play Store to leave your review.",
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}