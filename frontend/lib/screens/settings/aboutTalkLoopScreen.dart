import 'package:flutter/material.dart';

class AboutTalkLoopScreen extends StatelessWidget {
  const AboutTalkLoopScreen({super.key});

  static const String appVersion = "1.0.0";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("About TalkLoop"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // App icon
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                "assets/images/LOGO.png",
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              "TalkLoop",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Talk anonymously. Meet someone new.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),

            const SizedBox(height: 32),

            _Section(
              title: "About TalkLoop",
              child: Text(
                "TalkLoop is an anonymous chat app that lets "
                    "you meet and talk with strangers in real time.",
                style: theme.textTheme.bodyMedium,
              ),
            ),

            const SizedBox(height: 24),

            _Section(
              title: "Features",
              child: Column(
                children: const [
                  _FeatureTile(
                    icon: Icons.people_outline,
                    title: "Anonymous conversations",
                    subtitle: "Chat without revealing your identity.",
                  ),
                  _FeatureTile(
                    icon: Icons.shuffle,
                    title: "Random matching",
                    subtitle: "Meet someone new with a simple tap.",
                  ),
                  _FeatureTile(
                    icon: Icons.forum_outlined,
                    title: "Real-time chat",
                    subtitle: "Send messages and see typing activity instantly.",
                  ),
                  _FeatureTile(
                    icon: Icons.block_outlined,
                    title: "Block & Report",
                    subtitle: "Block or report users you don't want to interact with.",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _Section(
              title: "Safety",
              child: Text(
                "If you have an uncomfortable experience, "
                    "you can block or report the stranger. "
                    "Blocked and reported users won't be matched with you.",
                style: theme.textTheme.bodyMedium,
              ),
            ),

            const SizedBox(height: 32),

            Text(
              "Version $appVersion",
              style: theme.textTheme.bodySmall,
            ),

            const SizedBox(height: 8),

            Text(
              "Made with ❤️",
              style: theme.textTheme.bodySmall,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle),
    );
  }
}