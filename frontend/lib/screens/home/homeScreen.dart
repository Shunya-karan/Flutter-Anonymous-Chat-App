import 'package:flutter/material.dart';
import 'package:frontend/core/network/socket_service.dart';
import 'package:frontend/models/userModel.dart';
import 'package:frontend/services/userServices.dart';
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

  List<String> userInterests  = [];
  final socketService = SocketService.instance;
  bool  isSearching = false;

  UserModel?user;
  bool isLoading =true;

  @override
  void initState() {
    super.initState();
    LoadProfile();
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
    try {
      socketService.socket.emit("find_stranger", {
        "interests": userInterests,
      });
      setState(() {
        isSearching = true;
        status = "Looking for a stranger...";
      });
    }catch(error){
      print(error);
    }
  }

  Future<void>LoadProfile()async{
    try{
      final profile=await UserService.getProfile();
      setState(() {
        user = profile;
        userInterests = profile.interests;
        isLoading=false;
      });
    }catch(_){
      setState(() {
        isLoading=false;
      });
    }
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
              WelcomeHeader(username: user?.username??"",
                profileImage: user?.profileImage,),
              SizedBox(height: 30,),
              OnlineUsersCard(onlineUsers: onlineUsers),
              SizedBox(height: 30,),
              HeroCard(isSearching: isSearching,),
              SizedBox(height: 30,),
              InterestsCard(interests: user?.interests??[],),
              SizedBox(height: 40,),
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