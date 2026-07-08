import 'package:flutter/material.dart';
import 'package:frontend/core/network/socket_service.dart';
import 'package:frontend/widgets/homecard.dart';
import 'package:frontend/widgets/interestSection.dart';
import 'package:frontend/widgets/onlineUser.dart';
import 'package:frontend/widgets/welcomHeader.dart';
import '../chat/chat_screen.dart';
import '../auth/interest_screen.dart';

class HomePage extends StatefulWidget {
  // final SocketService socketService;

  const HomePage( {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String status = "Tap below to meet someone new";
  int onlineUsers = 0;
  List<String> selectedInterests = [];
  final socketService = SocketService.instance;
  bool get isSearching =>
      status.toLowerCase().contains("look") ||
          status.toLowerCase().contains("search");


  @override
  void initState() {
    super.initState();

    socketService.socket.off("matched");

    socketService.socket.on("matched", (roomId) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ChatScreen(
                socketService: socketService,
                roomId: roomId,
              ),
        ),
      ).then((result) {
        if (result == true) {
          setState(() {
            status = " Looking for a stranger...";
          });
          socketService.socket.emit("find_stranger", {
            "interests": selectedInterests,
          });
        } else {
          setState(() {
            status = "Tap below to meet someone new";
          });
        }
      });
    });

    socketService.socket.on("online_count", (count) {
      setState(() {
        onlineUsers = count;
      });
    });
  }

  @override
  void dispose() {
    socketService.socket.off("matched");
    socketService.socket.off("online_count");
    super.dispose();
  }

  Future<void> _findStranger() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => InterestScreen()),
    );

    if (result != null) {
      selectedInterests = List<String>.from(result);
      socketService.socket.emit("find_stranger", {
        "interests": selectedInterests,
      });
    }
    setState(() {
      status = "Looking for a stranger...";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WelcomeHeader(username: "Karan"),
              SizedBox(height: 15,),
              OnlineUsersCard(onlineUsers: onlineUsers),
              SizedBox(height: 25,),
              HeroCard(isSearching: isSearching,),
              SizedBox(height: 25,),
              InterestsCard(interests: [
                "Coding","Gaming",
                "Music",
                "Sports",
              ],)
            ],
          )
        ),
      ),
    );
  }
  }