import 'dart:io';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  SocketService._();

  static final SocketService instance =SocketService._();
  late IO.Socket socket;

  void connect(String token) {
    socket = IO.io(
        // "http://10.137.58.243:3000",
        "http://localhost:3000",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({
        "token":token
      })
          .disableAutoConnect()
          .build(),
    );
    socket.connect();

    socket.onConnect((_) {
      print("Socket Connected");
    });

    socket.onDisconnect((_) {
      print("Socket Disconnected");
    });

    socket.onConnectError((error) {
      print("Connect Error: $error");
    });
  }

  void disconnect() {
    socket.disconnect();
  }
}