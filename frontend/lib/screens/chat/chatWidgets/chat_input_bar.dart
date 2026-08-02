import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>onSend;
  final VoidCallback onTyping;
  const ChatInputBar({super.key,
    required this.controller,
    required this.onSend,
    required this.onTyping,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
    padding: EdgeInsets.fromLTRB(12, 8, 12, 10),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withOpacity(0.2)
          )
        )
      ),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.newline,
                onChanged: (_)=>onTyping(),
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(color: Colors.black87)
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 18,vertical: 14
                  )
                ),
          )
          ),
          SizedBox(width: 10,),
          CircleAvatar(
            radius: 24,
            child: IconButton(onPressed: (){
              final text = controller.text.trim();
              if(text.isEmpty)return;
              onSend(text);
            }, icon: Icon(Icons.send)),
          )
        ],
      ),
        );
  }
}
