import 'package:flutter/material.dart';

class BlockUserDialog extends StatefulWidget {
  const BlockUserDialog({super.key});

  @override
  State<BlockUserDialog> createState() => _BlockUserDialogState();
}

class _BlockUserDialogState extends State<BlockUserDialog> {


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Block User"),
      content: Text("You won't be matched with this user again."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: const Text("Block"),
        ),
      ],
    );
  }
}