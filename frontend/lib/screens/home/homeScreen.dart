import 'package:flutter/material.dart';
import 'package:frontend/core/network/socket_service.dart';
import 'package:frontend/widgets/homecard.dart';
import 'package:frontend/widgets/interestSection.dart';
import 'package:frontend/widgets/onlineUser.dart';
import 'package:frontend/widgets/securityFooter.dart';
import 'package:frontend/widgets/startChatButton.dart';
import 'package:frontend/widgets/welcomHeader.dart';
import '../chat/chat_screen.dart';
import '../auth/interest_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage( {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String status = "Tap to meet someone ";

  int onlineUsers = 0;

  List<String> userInterests  = ["Coding","Gaming",
    "Music",
    "Sports"];

  final socketService = SocketService.instance;
  bool  isSearching = false;

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
        if(!mounted) return;

        if (result == true) {
          setState(() {
            isSearching = true;
            status = " Looking for a stranger...";
          });
          socketService.socket.emit("find_stranger",
              {
            "interests": userInterests ,
          });
        } else {
          setState(() {
            isSearching=false;
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

//Find Stranger function
  Future<void> _findStranger() async {
      socketService.socket.emit("find_stranger", {
        "interests": userInterests ,
      });
    setState(() {
      isSearching=true;
      status = "Looking for a stranger...";
    });
  }

  @override
  void dispose() {
    socketService.socket.off("matched");
    socketService.socket.off("online_count");
    super.dispose();
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
              SizedBox(height: 25,),
              OnlineUsersCard(onlineUsers: onlineUsers),
              SizedBox(height: 25,),
              HeroCard(isSearching: isSearching,),
              SizedBox(height: 25,),
              InterestsCard(interests: userInterests,),
              SizedBox(height: 30,),
              StartChatButton(isSearching: isSearching,
                status: status,
                onPressed:_findStranger,),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(child: Securityfooter()),

    );
  }
  }