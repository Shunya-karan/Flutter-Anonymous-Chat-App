import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final int sentAt;
  final bool delivered;
  const ChatBubble({super.key,
  required this.isMe,
    required this.message,
    required this.sentAt,
    required this.delivered
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
          child:Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isMe
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSecondary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 4),

            Row(

              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  formattedTime,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color:Colors.black
                  ),
                ),

                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    delivered ? Icons.done_all_rounded : Icons.done_rounded,
                    size: 15,
                    color: theme.colorScheme.secondary
                  ),
                ],
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }
}
