import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void connect() {
    socket = IO.io(
        "http://10.96.180.243:3000",
        // "http://localhost:3000",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print("Connected");
    });
  }
}