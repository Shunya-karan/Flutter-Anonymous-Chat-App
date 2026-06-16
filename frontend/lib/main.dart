import 'package:flutter/material.dart';
import 'services/socket_service.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  MyApp({super.key});

  final SocketService socketService = SocketService();

  @override
  Widget build(BuildContext context) {

    socketService.connect();

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: HomePage(socketService),
    );
  }
}

class HomePage extends StatefulWidget {

  final SocketService socketService;

  const HomePage(this.socketService, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String status = "Not Connected";
  int onlineUsers = 0;
  @override
  void initState() {
    super.initState();

    // widget.socketService.socket.off("matched");
    widget.socketService.socket.on("matched", (roomId) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            socketService: widget.socketService,
            roomId: roomId,
          ),
        ),
      ).then((result){
        if(result==true){
          setState(() {
            status="searching...";
          });
          widget.socketService.socket.emit("find_stranger",);
        }
      });

    });

    widget.socketService.socket.on("online_count", (count) {
        setState(() {
          onlineUsers = count;
        });

      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("TalkLoop"),
      ),

      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Text(
              status,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22),
            ),

            const SizedBox(height: 20),
            Text(
              "🟢 Online Users: $onlineUsers",
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                widget.socketService.socket.emit(
                    "find_stranger"
                );

                setState(() {
                  status = "Searching...";
                });

              },

              child: const Text("Find Stranger"),
            )

          ],
        ),
      ),
    );
  }
}