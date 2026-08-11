import 'package:frontend/core/constants/apiConstants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  SocketService._();

  static final SocketService instance = SocketService._();

  late IO.Socket socket;

  void connect(String token) {
    socket = IO.io(
      ApiConstants.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({
        "token": token,
      })
          .disableAutoConnect()
          .build(),
    );

    // Register listeners BEFORE connect
    socket.onConnect((_) {
      print("Socket Connected");
      print("Socket ID: ${socket.id}");

      // Tell server this socket wants to know
      // whether it currently has an active chat.
      socket.emit("check_chat_state");
    });

    socket.onDisconnect((_) {
      print("Socket Disconnected");
    });

    socket.onConnectError((error) {
      print("Connect Error: $error");
    });

    socket.connect();
  }

  void disconnect() {
    socket.disconnect();
  }
}