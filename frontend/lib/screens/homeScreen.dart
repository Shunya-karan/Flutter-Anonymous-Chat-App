import 'package:flutter/material.dart';
import 'package:frontend/services/socket_service.dart';
import 'chat_screen.dart';
import 'interest_screen.dart';

class HomePage extends StatefulWidget {
  final SocketService socketService;

  const HomePage(this.socketService, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
     {
  String status = "Tap below to meet someone new";
  int onlineUsers = 0;
  List<String> selectedInterests = [];

  bool get isSearching =>
      status.toLowerCase().contains("look") ||
          status.toLowerCase().contains("search");


  @override
  void initState() {
    super.initState();



    widget.socketService.socket.off("matched");

    widget.socketService.socket.on("matched", (roomId) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ChatScreen(
                socketService: widget.socketService,
                roomId: roomId,
              ),
        ),
      ).then((result) {
        if (result == true) {
          setState(() {
            status = "🔍 Looking for a stranger...";
          });
          widget.socketService.socket.emit("find_stranger", {
            "interests": selectedInterests,
          });
        } else {
          setState(() {
            status = "Tap below to meet someone new";
          });
        }
      });
    });

    widget.socketService.socket.on("online_count", (count) {
      setState(() {
        onlineUsers = count;
      });
    });
  }

  @override
  void dispose() {
    widget.socketService.socket.off("matched");
    widget.socketService.socket.off("online_count");
    super.dispose();
  }

  Future<void> _findStranger() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => InterestScreen()),
    );

    if (result != null) {
      selectedInterests = List<String>.from(result);
      widget.socketService.socket.emit("find_stranger", {
        "interests": selectedInterests,
      });
    }

    setState(() {
      status = "🔍 Looking for a stranger...";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TalkLoop"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.circle,
                        color: Colors.green,
                        size: 12,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "$onlineUsers Users Online",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue.shade100,
                child: Icon(
                  isSearching
                      ? Icons.search
                      : Icons.people_alt_rounded,
                  size: 50,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 30),

              Text(
                isSearching
                    ? "Searching for someone..."
                    : "Meet New People",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Connect anonymously with people who share your interests.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              if (selectedInterests.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          "Selected Interests",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: selectedInterests
                              .map(
                                (interest) => Chip(
                              label: Text(interest),
                            ),
                          )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              if (isSearching)
                Card(
                  color: Colors.blue.shade50,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Looking for a stranger...",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 30),

              OutlinedButton.icon(
                onPressed: isSearching
                    ? null
                    : () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => InterestScreen(),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      selectedInterests =
                      List<String>.from(result);
                    });
                  }
                },
                icon: const Icon(Icons.interests),
                label: const Text("Choose Interests"),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: isSearching
                      ? null
                      : _findStranger,
                  icon: Icon(
                    isSearching
                        ? Icons.hourglass_empty
                        : Icons.chat,
                  ),
                  label: Text(
                    isSearching
                        ? "Searching..."
                        : "Start Chat",
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                status,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  }