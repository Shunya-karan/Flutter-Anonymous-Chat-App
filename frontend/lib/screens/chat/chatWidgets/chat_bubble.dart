import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  const ChatBubble({super.key,
  required this.isMe,
    required this.message
  });

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);
    return Align(
      alignment: isMe?Alignment.centerRight:Alignment.centerLeft,
      child: Container(
        margin:  EdgeInsets.symmetric(vertical: 4),
        padding:  EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        constraints: BoxConstraints(
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
        child: Text(
          message,
          style: TextStyle(
            color: isMe
                ? Colors.white
                : theme.colorScheme.onSurface,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
