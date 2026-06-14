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

  @override
  void initState() {
    super.initState();

    widget.socketService.socket.on("matched", (roomId) {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            socketService: widget.socketService,
            roomId: roomId,
          ),
        ),
      );

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Anonymous Chat"),
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