import 'package:flutter/material.dart';
import '../services/socket_service.dart';

class ChatScreen extends StatefulWidget {
  final SocketService socketService;
  final String roomId;

  const ChatScreen({
    super.key,
    required this.socketService,
    required this.roomId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final TextEditingController messageController = TextEditingController();

  List<Map<String, dynamic>> messages = [];
  String myId = "";

  @override
  @override
  void initState() {
    super.initState();

    myId = widget.socketService.socket.id!;

    // RECEIVE MESSAGE
    widget.socketService.socket.on(
      "receive_message",
          (data) {
        setState(() {
          messages.add({
            "sender": data["sender"],
            "message": data["message"],
          });
        });
      },
    );

    // STRANGER DISCONNECTED
    widget.socketService.socket.on(
      "stranger_disconnected",
          (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Stranger disconnected"),
            duration: Duration(seconds: 2),
          ),
        );

        Future.delayed(
          const Duration(seconds: 2),
              () {
            if (mounted) {
              Navigator.pop(context);
            }
          },
        );
      },
    );

    // SKIP SUCCESS
    widget.socketService.socket.on(
      "skip_success",
          (_) {
        if (mounted) {
          Navigator.pop(context);
        }
      },
    );
  }

  void sendMessage() {

    if (messageController.text.trim().isEmpty) {
      return;
    }

    widget.socketService.socket.emit(
      "send_message",
      {
        "roomId": widget.roomId,
        "message": messageController.text,
      },
    );

    messageController.clear();
  }

  @override
  void dispose() {

    widget.socketService.socket.off("receive_message");
    widget.socketService.socket.off("stranger_disconnected");
    widget.socketService.socket.off("skip_success");

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      child: Scaffold(
      
        appBar: AppBar(
          title: const Text("Anonymous Chat"),
            automaticallyImplyLeading: false,
            actions: [
              ElevatedButton(
                onPressed: () {
                  widget.socketService.socket.emit(
                      "skip_stranger"
                  );
                },
                child: Row(
                  children: [
                    Text("Skip"),
                    SizedBox(width: 10,),
                    Icon(Icons.skip_next)
                  ],
                ),
              ),
            ]
        ),
      
        body: Column(
          children: [
      
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
      
                  final msg = messages[index];
      
                  final isMe = msg["sender"] == myId;
      
                  return Align(
                    alignment:
                    isMe ? Alignment.centerRight : Alignment.centerLeft,
      
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      padding: const EdgeInsets.all(12),
      
                      decoration: BoxDecoration(
                        color: isMe
                            ? Colors.blue
                            : Colors.grey.shade300,
      
                        borderRadius: BorderRadius.circular(12),
                      ),
      
                      child: Text(
                        msg["message"],
                        style: TextStyle(
                          color: isMe
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
      
                },
              ),
            ),
      
            Row(
              children: [
      
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message",
                    ),
                  ),
                ),
      
                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send),
                ),
      
              ],
            ),
      
          ],
        ),
      
      ),
    );
  }
}