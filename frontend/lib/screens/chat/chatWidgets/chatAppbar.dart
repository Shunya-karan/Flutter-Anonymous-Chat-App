import 'package:flutter/material.dart';
import 'package:frontend/screens/chat/chatWidgets/chatMenu.dart';

class ChatAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String strangerName;
  final String? strangerAvatar;
  final bool isOnline;
  final VoidCallback onSkip;
  final VoidCallback onEndChat;
  final VoidCallback onReport;
  final VoidCallback onBlock;

  const ChatAppbar({
    super.key,
    required this.strangerName,
    this.strangerAvatar,
    required this.isOnline,
    required this.onSkip,
    required this.onEndChat,
    required this.onReport,
    required this.onBlock,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = strangerAvatar?.isNotEmpty ?? false;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 1,
      titleSpacing: 8,
      title: Row(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.25),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 23,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  backgroundImage: hasImage
                      ? AssetImage("assets/avatar/$strangerAvatar.png")
                      : null,
                  child: !hasImage
                      ? Icon(
                    Icons.person_rounded,
                    color: theme.colorScheme.primary,
                  )
                      : null,
                ),
              ),

              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                    color: isOnline ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.surface,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  strangerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  isOnline ? "Online" : "Offline",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isOnline
                        ? Colors.green
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        FilledButton(onPressed: onSkip, child: Text("Skip ")),
        ChatMenu(
            onEndChat: onEndChat,
            onReport: onReport,
            onBlock: onBlock
        ),
      ],
    );
  }
}