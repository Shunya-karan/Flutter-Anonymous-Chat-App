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
  final ScrollController scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [];
  String myId = "";
  bool strangerTyping = false;
  Timer? typingTimer;
  bool isSearchingAgain = false;
  late Function(dynamic) receiveMessageListener;
  late Function(dynamic) typingListener;
  late Function(dynamic) stopTypingListener;
  late Function(dynamic) skipListener;
  late Function(dynamic) disconnectListener;


  @override
  void initState() {
    super.initState();

    widget.socketService.socket.off("skip_success");
    widget.socketService.socket.off("stranger_disconnected");

    myId = widget.socketService.socket.id!;

    receiveMessageListener = (data) {
      if (!mounted) return;
      setState(() {
        messages.add({
          "sender": data["sender"],
          "message": data["message"],
        });
      });
      _scrollToBottom();
    };
    widget.socketService.socket.on("receive_message", receiveMessageListener);

    // STRANGER DISCONNECTED
    disconnectListener = (_) {
      searchAgain();
    };
    widget.socketService.socket.on("stranger_disconnected", disconnectListener);

    // SKIP SUCCESS
    skipListener = (_) {
      searchAgain();
    };
    widget.socketService.socket.on("skip_success", skipListener);

    // USER TYPING
    typingListener = (_) {
      if (!mounted) return;
      setState(() {
        strangerTyping = true;
      });
    };
    widget.socketService.socket.on("user_typing", typingListener);

    // USER STOP TYPING
    stopTypingListener = (_) {
      if (!mounted) return;
      setState(() {
        strangerTyping = false;
      });
    };
    widget.socketService.socket.on("user_stop_typing", stopTypingListener);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void searchAgain() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Finding a new stranger..."),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF2B1B4A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    if (isSearchingAgain) return;
    isSearchingAgain = true;
    Future.delayed(
      const Duration(seconds: 1),
          () {
        if (!mounted) return;
        Navigator.pop(context, true);
      },
    );
  }

  void sendMessage() {
    if (messageController.text
        .trim()
        .isEmpty) {
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
    widget.socketService.socket.off(
      "skip_success",
      skipListener,
    );

    widget.socketService.socket.off(
      "stranger_disconnected",
      disconnectListener,
    );
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Row(
            children: [
              CircleAvatar(
                child: Icon(Icons.person),
              ),
              SizedBox(width: 10),
              Text("Stranger"),
            ],
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                widget.socketService.socket.emit("skip_stranger");
              },
              icon: const Icon(Icons.skip_next),
              label: const Text("Skip"),
            ),
            const SizedBox(width: 10),
          ],
        ),

        body: Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? const Center(
                child: Text(
                  "You are connected.\nSay hello 👋",
                  textAlign: TextAlign.center,
                ),
              )
                  : ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isMe = msg["sender"] == myId;

                  return Align(
                    alignment: isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      constraints: BoxConstraints(
                        maxWidth:
                        MediaQuery
                            .of(context)
                            .size
                            .width * 0.75,
                      ),
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
                              : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            if (strangerTyping)
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  bottom: 8,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Typing...",
                    ),
                  ),
                ),
              ),

            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(25),
                        ),
                      ),
                      onChanged: (value) {
                        widget.socketService.socket
                            .emit("typing", widget.roomId);

                        typingTimer?.cancel();

                        typingTimer = Timer(
                          const Duration(seconds: 1),
                              () {
                            widget.socketService.socket.emit(
                              "stop_typing",
                              widget.roomId,
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 8),

                  CircleAvatar(
                    radius: 24,
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
