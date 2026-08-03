import 'package:flutter/material.dart';

class EndChatDialog extends StatelessWidget {
  const EndChatDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("End Chat"),
        content: Text("Are you sure you want to end this conversation?"),
    actions: [
      TextButton(
          onPressed: (){
            Navigator.pop(context,false);
            }, 
          child: Text("Cancel")
      ),
      FilledButton(
          onPressed:(){
            Navigator.pop(context,true);
          }, child: Text("End Chat"))
    ],    
    );
      
  }
}
