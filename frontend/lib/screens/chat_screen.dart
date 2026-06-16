import 'package:flutter/material.dart';
import '../services/socket_service.dart';
import 'dart:async';

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
  bool strangerTyping = false;
  Timer? typingTimer;
  late Function(dynamic) receiveMessageListener;
  late Function(dynamic) typingListener;
  late Function(dynamic) stopTypingListener;

  @override
  void initState() {
    super.initState();

    myId = widget.socketService.socket.id!;

    receiveMessageListener = (data) {
      if (!mounted) return;
      setState(() {
        messages.add({
          "sender": data["sender"],
          "message": data["message"],
        });
      });

    };
    widget.socketService.socket.on("receive_message", receiveMessageListener,);

    // STRANGER DISCONNECTED
    widget.socketService.socket.on("stranger_disconnected",(_) {
      searchAgain();
      },
    );
    // SKIP SUCCESS
    widget.socketService.socket.on("skip_success", (_) {
      searchAgain();
      },
    );
    //USER TYPING
    typingListener = (_) {
      if (!mounted) return;
      setState(() {
        strangerTyping = true;
      });

    };
    widget.socketService.socket.on("user_typing", typingListener,);
    //USER STOP TYPING
    stopTypingListener = (_) {
      if (!mounted) return;
      setState(() {
        strangerTyping = false;
      });

    };
    widget.socketService.socket.on("user_stop_typing", stopTypingListener,);
  }

  void searchAgain() {
    if(!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Finding a new stranger..."),
        duration: Duration(seconds: 1),
      ),
    );
    Future.delayed(
      const Duration(seconds: 1),
          () {
        if (!mounted) return ;
          Navigator.pop(context, true);
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

    widget.socketService.socket.emit(
      "stop_typing",
      widget.roomId,
    );

    messageController.clear();
  }

  @override
  void dispose() {
    typingTimer?.cancel();
    widget.socketService.socket.off(
      "receive_message",
      receiveMessageListener,
    );

    widget.socketService.socket.off(
      "user_typing",
      typingListener,
    );

    widget.socketService.socket.off(
      "user_stop_typing",
      stopTypingListener,
    );
    messageController.dispose();
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
      
        body: SafeArea(
          child: Column(
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
              if (strangerTyping)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Stranger is typing...",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
          
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        onChanged: (value) {
                          widget.socketService.socket.emit("typing", widget.roomId);
                          typingTimer?.cancel();
                          typingTimer = Timer(
                            const Duration(seconds: 1),
                                () {
                              widget.socketService.socket.emit("stop_typing", widget.roomId);
                            },
                          );
                        },
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
      
      ),
    );
  }
}