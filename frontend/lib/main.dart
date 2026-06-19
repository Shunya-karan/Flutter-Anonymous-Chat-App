import 'package:flutter/material.dart';
import 'services/socket_service.dart';
import 'screens/chat_screen.dart';
import 'screens/interest_screen.dart';

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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String status = "Tap below to meet someone new";
  int onlineUsers = 0;
  List<String> selectedInterests = [];

  bool get isSearching =>
      status.toLowerCase().contains("look") ||
          status.toLowerCase().contains("search");

  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    widget.socketService.socket.off("matched");

    widget.socketService.socket.on("matched", (roomId) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
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
    _pulseController.dispose();
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.bubble_chart_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "TalkLoop",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4ADE80),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "$onlineUsers online",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRadarAvatar(),
                  const SizedBox(height: 36),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      status,
                      key: ValueKey(status),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  ),
                  if (selectedInterests.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        alignment: WrapAlignment.center,
                        children: selectedInterests
                            .map((tag) => Chip(
                          label: Text(tag,
                              style: const TextStyle(fontSize: 12)),
                          backgroundColor:
                          Colors.white,
                          labelStyle:
                          const TextStyle(color: Colors.grey),
                          side: BorderSide.none,
                        ))
                            .toList(),
                      ),
                    ),
                  const SizedBox(height: 48),
                  _buildFindButton(),
                  const SizedBox(height: 16),
                  Text(
                    isSearching
                        ? "Hang tight, this won't take long"
                        : "Pick your interests, or just dive in",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5), fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadarAvatar() {
    return SizedBox(
      width: 140,
      height: 140,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              if (isSearching) ..._buildPulseRings(),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withOpacity(0.5),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  isSearching
                      ? Icons.travel_explore_rounded
                      : Icons.diversity_3_rounded,
                  color: Colors.white,
                  size: 42,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildPulseRings() {
    return List.generate(2, (i) {
      final progress = (_pulseController.value + (i * 0.5)) % 1.0;
      return Container(
        width: 96 + progress * 90,
        height: 96 + progress * 90,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF8B5CF6).withOpacity((1 - progress) * 0.6),
            width: 2,
          ),
        ),
      );
    });
  }

  Widget _buildFindButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isSearching ? null : _findStranger,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEC4899),
          disabledBackgroundColor: Colors.white.withOpacity(0.1),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          elevation: isSearching ? 0 : 6,
          shadowColor: const Color(0xFFEC4899).withOpacity(0.5),
        ),
        child: isSearching
            ? const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 2.4, color: Colors.white70),
            ),
            SizedBox(width: 12),
            Text("Searching...",
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ],
        )
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shuffle_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text("Find Stranger",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}