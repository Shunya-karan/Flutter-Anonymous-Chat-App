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

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
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

  late final AnimationController _dotsController;

  @override
  void initState() {
    super.initState();

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

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
    _dotsController.dispose();
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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 16,
          title: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.person_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Stranger",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Anonymous chat",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton.icon(
                onPressed: () {
                  widget.socketService.socket.emit("skip_stranger");
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.08),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.white24),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                icon: const Icon(Icons.skip_next_rounded, size: 18),
                label: const Text("Skip", style: TextStyle(fontSize: 13)),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A1530),
                Color(0xFF2B1B4A),
                Color(0xFF12101D),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? Center(
                    child: Text(
                      "Say hi 👋 — you're connected with a stranger",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 13),
                    ),
                  )
                      : ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg["sender"] == myId;

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth:
                            MediaQuery.of(context).size.width * 0.75,
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              gradient: isMe
                                  ? const LinearGradient(
                                colors: [
                                  Color(0xFF8B5CF6),
                                  Color(0xFFEC4899),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                                  : null,
                              color: isMe
                                  ? null
                                  : Colors.white.withOpacity(0.08),
                              border: isMe
                                  ? null
                                  : Border.all(color: Colors.white24),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(isMe ? 16 : 4),
                                bottomRight:
                                Radius.circular(isMe ? 4 : 16),
                              ),
                            ),
                            child: Text(
                              msg["message"],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.5,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (strangerTyping)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(left: 12, bottom: 6),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        border: Border.all(color: Colors.white24),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                          bottomLeft: Radius.circular(4),
                        ),
                      ),
                      child: AnimatedBuilder(
                        animation: _dotsController,
                        builder: (context, _) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(3, (i) {
                              final t = (_dotsController.value - (i * 0.2)) % 1.0;
                              final scale = t < 0
                                  ? 0.4
                                  : 0.4 + 0.6 * (1 - (2 * t - 1).abs());
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: Opacity(
                                  opacity: 0.4 + 0.6 * scale.clamp(0.0, 1.0),
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            style: const TextStyle(color: Colors.white),
                            cursorColor: const Color(0xFFEC4899),
                            decoration: const InputDecoration(
                              hintText: "Type a message...",
                              hintStyle: TextStyle(color: Colors.white38),
                              border: InputBorder.none,
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            ),
                            onChanged: (value) {
                              widget.socketService.socket
                                  .emit("typing", widget.roomId);
                              typingTimer?.cancel();
                              typingTimer = Timer(
                                const Duration(seconds: 1),
                                    () {
                                  widget.socketService.socket
                                      .emit("stop_typing", widget.roomId);
                                },
                              );
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: sendMessage,
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_upward_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}