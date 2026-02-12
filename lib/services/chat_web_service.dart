import 'dart:async';
import 'dart:convert';

import 'package:web_socket_client/web_socket_client.dart';

enum ConnectionStatus {
  connecting,
  connected,
  disconnected,
}

class ChatWebService {
  // Static single instance of this class (Singleton pattern)
  // This ensures only ONE ChatWebService exists in the entire app
  static final ChatWebService _instance = ChatWebService._internal();

  // WebSocket variable used to open and maintain a real-time connection
  // It is nullable because the connection may not be established yet
  WebSocket? _socket;
  StreamSubscription? _messageStreamSubscription;
  StreamSubscription? _connectionStreamSubscription;

  // Factory constructor
  // Whenever ChatWebService() is called, it returns the SAME instance
  // instead of creating a new object
  factory ChatWebService() => _instance;

  // Private constructor
  // Prevents other classes from creating new instances directly
  // This is called ONLY ONCE when _instance is created
  ChatWebService._internal();

  final _searchResultController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _contentController = StreamController<Map<String, dynamic>>.broadcast();
  final _connectionStatusController =
      StreamController<ConnectionStatus>.broadcast();

  Map<String, dynamic>? _lastSearchResult;

  Stream<Map<String, dynamic>> get searchResultStream async* {
    if (_lastSearchResult != null) {
      yield _lastSearchResult!;
    }
    yield* _searchResultController.stream;
  }

  Stream<Map<String, dynamic>> get contentStream => _contentController.stream;
  Stream<ConnectionStatus> get connectionStatusStream =>
      _connectionStatusController.stream;

  void connect() {
    // Return if the socket is already created
    if (_socket != null) return;

    _connectionStatusController.add(ConnectionStatus.connecting);

    _socket = WebSocket(Uri.parse("ws://localhost:8000/ws/chat"));

    // Listen to the connection state stream to handle reconnects
    _connectionStreamSubscription = _socket!.connection.listen((state) {
      print("WebSocket connection state: $state");

      if (state is Connected) {
        _connectionStatusController.add(ConnectionStatus.connected);
      } else if (state is Connecting || state is Reconnecting) {
        _connectionStatusController.add(ConnectionStatus.connecting);
      } else {
        _connectionStatusController.add(ConnectionStatus.disconnected);
      }

      // When a connection is established, re-subscribe to the messages stream.
      // This ensures we're listening even after a reconnect.
      _messageStreamSubscription?.cancel();
      _messageStreamSubscription = _socket!.messages.listen((message) {
        final data = json.decode(message);
        if (data['type'] == 'search_result') {
          _lastSearchResult = data;
          _searchResultController.add(data);
        } else if (data['type'] == 'content') {
          _contentController.add(data);
        }
      });
    });
  }

  void chat(String query) {
    if (_socket == null) {
      print("Error: chat() called before connect().");
      return;
    }
    _lastSearchResult = null;

    _socket!.send(json.encode({
      'query': query
    })); //the line sends users messages to the server through websockets
  }

  void dispose() {
    _messageStreamSubscription?.cancel();
    _connectionStreamSubscription?.cancel();
    _socket?.close();
    _searchResultController.close();
    _contentController.close();
    _connectionStatusController.close();
  }
}