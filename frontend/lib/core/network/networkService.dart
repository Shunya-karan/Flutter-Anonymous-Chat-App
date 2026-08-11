import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkService {
  NetworkService._();

  static final NetworkService instance = NetworkService._();

  final InternetConnection _connection = InternetConnection();

  StreamSubscription<InternetStatus>? _subscription;

  bool isConnected = true;

  void start({
    required Function(bool connected) onChanged,
  }) {
    _subscription?.cancel();

    _subscription = _connection.onStatusChange.listen((status) {
          final connected = status == InternetStatus.connected;

          isConnected = connected;

          onChanged(connected);
        });
  }

  Future<bool> checkConnection() async {
    final connected =
    await _connection.hasInternetAccess;

    isConnected = connected;

    return connected;
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}