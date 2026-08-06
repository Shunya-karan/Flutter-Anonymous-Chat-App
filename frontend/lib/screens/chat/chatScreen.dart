import 'package:flutter/material.dart';
import 'package:frontend/screens/chat/chatWidgets/chatAppbar.dart';
import 'package:frontend/screens/chat/chatWidgets/chatBubble.dart';
import 'package:frontend/screens/chat/chatWidgets/chatInputBar.dart';
import 'package:frontend/screens/chat/chatWidgets/connectionBanner.dart';
import 'package:frontend/screens/chat/chatWidgets/emptyChatView.dart';
import 'package:frontend/screens/chat/chatWidgets/typingIndicator.dart';
import 'package:frontend/widgets/CustomWidgets/CustomeMessanger.dart';
import 'package:frontend/widgets/Dialogs/blockUserDialog.dart';
import 'package:frontend/widgets/Dialogs/endChatDialog.dart';
import 'package:frontend/widgets/Dialogs/reportUserDialog.dart';
import '../../core/network/socketService.dart';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  final SocketService socketService;
  final String roomId;
  final String strangerName;
  final String strangerAvatar;

  const ChatScreen({
    super.key,
    required this.socketService,
    required this.roomId,
    required this.strangerAvatar,
    required this.strangerName
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
  Timer? bannerTimer;
  bool isSearchingAgain = false;
  String? bannerMessage;
  Color bannerColor = Colors.green;
  bool isEndingChat = false;

  late Function(dynamic) receiveMessageListener;
  late Function(dynamic) typingListener;
  late Function(dynamic) stopTypingListener;
  late Function(dynamic) skipListener;
  late Function(dynamic) disconnectListener;
  late Function(dynamic) strangerChatEndedListener;
  late Function(dynamic) endChatSuccessListener;
  late Function(dynamic) reportSuccessListener;
  late Function(dynamic) reportFailedListener;
  late Function(dynamic) blockSuccessListener;
  late Function(dynamic) blockFailedListener;

  @override
  void initState() {
    super.initState();

    widget.socketService.socket.off("skip_success");
    widget.socketService.socket.off("stranger_disconnected");

    myId = widget.socketService.socket.id!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showBanner(
        "Connected",
        Colors.green,
        hideAfter: const Duration(seconds: 2),
      );
    });
    //receiving messages
    receiveMessageListener = (data) {
      if (!mounted) return;
      setState(() {
        messages.add({
          "sender": data["sender"],
          "message": data["message"],
          "sentAt":data["sentAt"]
        });
      });
      _scrollToBottom();
    };
    widget.socketService.socket.on("receive_message", receiveMessageListener);

    // STRANGER DISCONNECTED
    disconnectListener = (_) {
      showBanner(
        "Stranger left. Finding another stranger...",
        Colors.orange,
        hideAfter: const Duration(seconds: 2),
      );
      searchAgain();
    };
    widget.socketService.socket.on("stranger_disconnected", disconnectListener);

    // SKIP SUCCESS
    skipListener = (_) {
      showBanner(
        "Finding another  stranger...",
        Colors.blue,
        hideAfter: const Duration(seconds: 2),
      );
      searchAgain();
    };
    widget.socketService.socket.on("skip_success", skipListener);

    //user ended chat
    endChatSuccessListener=(_){
      if(!mounted) return;
      Navigator.pop(context);
      CustomMessenger.show(context, message: "Chat ended.",bgColor: Colors.green);
      isEndingChat = false;
    };
    widget.socketService.socket.on("chat_ended", endChatSuccessListener);

    // if Stranger Ended chat
    strangerChatEndedListener=(_){
      showBanner(
        "Stranger ended the chat. Finding another stranger...",
        Colors.orangeAccent,
        hideAfter: const Duration(seconds: 2),
      );
      searchAgain();
    };
    widget.socketService.socket.on("stranger_ended_chat", strangerChatEndedListener);

    // USER TYPING
    typingListener = (_) {
        if (strangerTyping) return;
        setState(() {
          strangerTyping = true;
        });
        _scrollToBottom();
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

    //USER REPORTING
    reportSuccessListener = (_) {
      if (!mounted) return;
      CustomMessenger.show(context, message: "User Reported Successfully",bgColor: Colors.green);
    };
    widget.socketService.socket.on(
      "report_success",
      reportSuccessListener,
    );

    reportFailedListener = (data) {
      if (!mounted) return;
      CustomMessenger.show(context,
          message: data["message"] ?? "Unable to report user.",
          bgColor: Colors.red);
    };
    widget.socketService.socket.on(
      "report_failed",
      reportFailedListener,
    );

    blockSuccessListener = (_) {
      if (!mounted) return;
      CustomMessenger.show(context, message: "User Blocked Successfully",bgColor: ColorScheme.of(context).error);
    };
    widget.socketService.socket.on(
      "blocked_success",
      blockSuccessListener,
    );

    blockFailedListener = (data) {
      if (!mounted) return;
      CustomMessenger.show(context,
          message: data["message"] ?? "Unable to block user.",
          bgColor: Colors.red);
    };
    widget.socketService.socket.on(
      "block_failed",
      blockFailedListener,
    );
  }

  @override
  void dispose() {
    // if user disconnected or skipeed then it will deletee this things
    typingTimer?.cancel();
    bannerTimer?.cancel();
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
      "chat_ended",
      endChatSuccessListener,
    );
    widget.socketService.socket.off(
      "stranger_ended_chat",
      strangerChatEndedListener,
    );
    widget.socketService.socket.off(
      "stranger_disconnected",
      disconnectListener,
    );
    widget.socketService.socket.off(
      "report_success",
      reportSuccessListener,
    );

    widget.socketService.socket.off(
      "report_failed",
      reportFailedListener,
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
        appBar: ChatAppbar(strangerName: widget.strangerName,
            isOnline: true,
            strangerAvatar: widget.strangerAvatar,
            onSkip: skipStranger,
            onEndChat: endChat,
            onBlock: blockUser,
            onReport:reportUser,
            ),

        body: SafeArea(
          child: Column(
            children: [
              if(bannerMessage!=null)
                ConnectionBanner(message: bannerMessage!,
                    color: bannerColor),
              //empty chatView
              Expanded(child: messages.isEmpty
              ?EmptyChatView()
              : ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(12),
              itemCount:  messages.length,
              itemBuilder: (context, index) {

                final msg = messages[index];
                final isMe = msg["sender"] == myId;
                return ChatBubble(
                  message: msg["message"],
                  isMe: isMe,
                  sentAt: msg["sentAt"],
                );
                },
              ),
              ),
              if (strangerTyping)
                TypingIndicator(strangerName: widget.strangerName),
                //inputbar
              ChatInputBar(
                controller: messageController,
                onTyping: handleTyping,
                onSend: (message) {
                  sendMessage(message);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void skipStranger() {
    widget.socketService.socket.emit("skip_stranger");
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

  Future<void> endChat() async {
    final shouldEnd = await showDialog<bool>(
      context: context,
      builder: (_) => const EndChatDialog(),
    );

    if (shouldEnd != true) return;
    if (isEndingChat) return;
    isEndingChat = true;
    widget.socketService.socket.emit("end_chat");
  }

  void searchAgain() {
    if (!mounted) return;

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

  void sendMessage(String message) {
    widget.socketService.socket.emit(
      "send_message",
      {
        "roomId": widget.roomId,
        "message": message,
      },
    );
    messageController.clear();
    widget.socketService.socket.emit(
      "stop_typing",
      widget.roomId,
    );
  }

  void handleTyping() {
    widget.socketService.socket.emit(
        "typing",
        widget.roomId
    );
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
  }

  void showBanner(String message,
      Color color,
      {Duration? hideAfter}) {
    if (!mounted) return;

    setState(() {
      bannerMessage = message;
      bannerColor = color;
    });
    if (hideAfter != null) {
      bannerTimer?.cancel();
      bannerTimer=Timer(hideAfter, () {
        if(!mounted)return;
        setState(() {
          bannerMessage = null;
        });
      });
  }
  }

  Future<void> reportUser() async {
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => const ReportUserDialog(),
    );

    if (reason == null) return;

    widget.socketService.socket.emit(
      "report_user",
      {
        "reason": reason,
      },
    );
  }

  Future<void> blockUser() async {
     await showDialog<String>(
      context: context,
      builder: (_) => const BlockUserDialog(),
    );
    widget.socketService.socket.emit(
      "block_user"
    );
  }
}
