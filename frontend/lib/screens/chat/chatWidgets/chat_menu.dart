import 'package:flutter/material.dart';

class ChatMenu extends StatelessWidget {
  final VoidCallback onSkip;
  final VoidCallback onEndChat;
  final VoidCallback onReport;
  final VoidCallback onBlock;

  const ChatMenu({
    super.key,
    required this.onSkip,
    required this.onEndChat,
    required this.onReport,
    required this.onBlock,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopupMenuButton<String>(
      tooltip: "Chat Options",
      icon: const Icon(Icons.more_vert_rounded),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),

      ),
      elevation: 6,
      color: theme.colorScheme.surface,
      onSelected: (value) {
        switch (value) {
          case "skip":
            onSkip();
            break;

          case "end":
            onEndChat();
            break;

          case "report":
            onReport();
            break;

          case "block":
            onBlock();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: "skip",
          child: Row(
            children: const [
              Icon(Icons.skip_next_rounded),
              SizedBox(width: 12),
              Text("Skip Stranger"),
            ],
          ),
        ),

        PopupMenuItem(
          value: "end",
          child: Row(
            children: const [
              Icon(Icons.call_end_rounded),
              SizedBox(width: 12),
              Text("End Chat"),
            ],
          ),
        ),

        const PopupMenuDivider(),

        PopupMenuItem(
          value: "report",
          child: Row(
            children: const [
              Icon(
                Icons.flag_outlined,
                color: Colors.orange,
              ),
              SizedBox(width: 12),
              Text("Report User"),
            ],
          ),
        ),

        PopupMenuItem(
          value: "block",
          child: Row(
            children: const [
              Icon(
                Icons.block_rounded,
                color: Colors.red,
              ),
              SizedBox(width: 12),
              Text("Block User"),
            ],
          ),
        ),
      ],
    );
  }
}