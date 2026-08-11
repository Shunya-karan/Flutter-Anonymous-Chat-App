import 'package:flutter/material.dart';
import 'package:frontend/core/network/socketService.dart';
import 'package:frontend/providers/userProvider.dart';
import 'package:frontend/widgets/CustomWidgets/CustomeMessanger.dart';
import 'package:frontend/widgets/Menus/appDrawer.dart';
import 'package:frontend/widgets/HomeScreenWidgets/homecard.dart';
import 'package:frontend/widgets/HomeScreenWidgets/interestSection.dart';
import 'package:frontend/widgets/HomeScreenWidgets/onlineUser.dart';
import 'package:frontend/widgets/HomeScreenWidgets/securityFooter.dart';
import 'package:frontend/widgets/HomeScreenWidgets/startChatButton.dart';
import 'package:frontend/widgets/HomeScreenWidgets/welcomHeader.dart';
import 'package:provider/provider.dart';
import '../chat/chatScreen.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage( {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String status = "Tap to meet someone ";

  int onlineUsers = 0;

  // List<String> userInterests  = [];
  final socketService = SocketService.instance;
  bool  isSearching = false;
  bool isLoading =true;


  @override
  void initState() {
    super.initState();
    matchStranger();
    _registerMatchingTimeoutListener();
    onlineCount();
    _registerRateLimitListeners();
  }

  Future<void>onlineCount()async{
     socketService.socket.on("online_count", (count) {
      setState(() {
        onlineUsers = count;
      });
    });
  }

  Future<void>matchStranger()async{
    final user = context.read<UserProvider>().user;
    socketService.socket.off("matched");
    socketService.socket.on("matched", (data) {
      if (!mounted) return;
      setState(() {
        isSearching = false;
      });
      final roomId = data["roomId"];

      final stranger = data["stranger"];

      final strangerName = stranger["displayName"];
      final strangerAvatar = stranger["avatar"];


      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ChatScreen(
                socketService: socketService,
                roomId: roomId,
                strangerName: strangerName,
                strangerAvatar: strangerAvatar,
                strangerUserId: data["strangerUserId"],
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
                "interests": user?.interests??[] ,
              });
        } else {
          setState(() {
            isSearching=false;
            status = "Tap below to meet someone new";
          });
        }
      });
    });
  }

  //Find Stranger function
  Future<void> _findStranger() async {
    if (isSearching) {
      return;
    }
    final user = context.read<UserProvider>().user;
    try {
      socketService.socket.emit("find_stranger", {
        "interests": user?.interests??[] ,
      });
      if(!mounted) return;
      setState(() {
        isSearching = true;
        status = "Looking for a stranger...";
      });


    }catch(error){
      print(error);
    }
  }

  //MatchingTimeOut
  void _registerMatchingTimeoutListener(){
    socketService.socket.on("search_timeout", (_) {
      if (!mounted) return;

      setState(() {
        status = "No strangers found";
        isSearching = false;
      });

      CustomMessenger.show(
        context,
        message: "No strangers are available right now. Try again later.",
        bgColor: Colors.red
      );
    });
  }

  void _registerRateLimitListeners(){
        // if already matching
        socketService.socket.on("already_searching",(data) {
          if(!mounted) return;
          setState(() {
            status = "Already searching ...";
            isSearching = true;
          });
          CustomMessenger.show(
            context,
            message: data["message"] ?? "You are already searching.",
            bgColor: Colors.orange,
          );
        });
        socketService.socket.on("already_chatting", (data) {
          if (!mounted) return;

          CustomMessenger.show(
            context,
            message: data["message"] ??
                "You are already chatting with a stranger.",
            bgColor: Colors.orange,
          );
        });
        // if matching too quickly
        socketService.socket.on("match_rate_limit", (data) {
          if(!mounted) return;
          setState(() {
            status = "Search Again";
            isSearching = false;
          });
          CustomMessenger.show(
            context,
            message: data["message"] ?? "You're searching too quickly.",
            bgColor: Colors.orange,
          );
        });
  }

  @override
  void dispose() {
    socketService.socket.off("matched");
    socketService.socket.off("online_count");
    socketService.socket.off("search_timeout");
    socketService.socket.off("already_searching");
    socketService.socket.off("match_rate_limit");
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      endDrawer: AppDrawer(username: user.username,
      profileImage: user.profileImage,
        bio: user.bio,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WelcomeHeader(username: user.username),
              SizedBox(height: 40,),
              OnlineUsersCard(onlineUsers: onlineUsers),
              SizedBox(height: 40,),
              HeroCard(isSearching: isSearching,),
              SizedBox(height: 40,),
              InterestsCard(interests: user.interests,),
              SizedBox(height: 60,),
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