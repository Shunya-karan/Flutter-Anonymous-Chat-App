import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final int sentAt;
  const ChatBubble({super.key,
  required this.isMe,
    required this.message,
    required this.sentAt
  });

  @override
  Widget build(BuildContext context) {
    final time = DateTime.fromMillisecondsSinceEpoch(sentAt);
    final formattedTime = DateFormat('h:mm a').format(time);
    final theme= Theme.of(context);
    return Align(
      alignment: isMe?Alignment.centerRight:Alignment.centerLeft,
      child: IntrinsicWidth(
        child: Container(
          margin:  EdgeInsets.symmetric(vertical: 4),
          padding:  EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          constraints: BoxConstraints(
            minWidth: 60,
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: isMe
                ? theme.colorScheme.primary
                : theme.colorScheme.secondary,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft:
              Radius.circular(isMe ? 18 : 4),
              bottomRight:
              Radius.circular(isMe ? 4 : 18),
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 55),
                child: Text(
                  message,
                  style: theme.textTheme.bodyLarge,
                ),
              ),

              Positioned(
                right: 0,
                bottom: 0,
                child: Text(
                  formattedTime,
                  style: theme.textTheme.labelSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
