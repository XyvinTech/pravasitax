import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/chat_api.dart';
import '../models/chat_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final conversationsProvider =
    FutureProvider.family<List<Conversation>, String>((ref, userToken) async {
  final chatAPI = ref.watch(chatAPIProvider);
  final conversations = await chatAPI.getConversations(userToken);
  return conversations.map((json) => Conversation.fromJson(json)).toList();
});

final conversationMessagesProvider = FutureProvider.family<List<MessageModel>,
    ({String userToken, String conversationId})>((ref, params) async {
  final chatAPI = ref.watch(chatAPIProvider);
  final messages =
      await chatAPI.getMessages(params.userToken, params.conversationId);
  return messages.map((json) => MessageModel.fromJson(json)).toList();
});

final createConversationProvider = FutureProvider.family<Conversation,
    ({String userToken, String title, String type})>((ref, params) async {
  final api = ref.watch(chatAPIProvider);
  final conversation =
      await api.createConversation(params.userToken, params.title, params.type);
  return Conversation.fromJson(conversation);
});

final sendMessageProvider = FutureProvider.family<
    void,
    ({
      String userToken,
      String conversationId,
      String message
    })>((ref, params) async {
  final chatAPI = ref.watch(chatAPIProvider);
  await chatAPI.sendMessage(
      params.userToken, params.conversationId, params.message);
});

final markMessageAsDeliveredProvider =
    FutureProvider.family<void, ({String userToken, String messageId})>(
        (ref, params) async {
  final api = ref.watch(chatAPIProvider);
  await api.markMessageAsDelivered(params.userToken, params.messageId);
});

final markMessageAsReadProvider =
    FutureProvider.family<void, ({String userToken, String messageId})>(
        (ref, params) async {
  final api = ref.watch(chatAPIProvider);
  await api.markMessageAsRead(params.userToken, params.messageId);
});

final assignStaffToConversationProvider = FutureProvider.family<
    void,
    ({
      String userToken,
      String conversationId,
      String staffId
    })>((ref, params) async {
  final api = ref.watch(chatAPIProvider);
  await api.assignStaffToConversation(
      params.userToken, params.conversationId, params.staffId);
});

final markConversationAsCompletedProvider =
    FutureProvider.family<void, ({String userToken, String conversationId})>(
        (ref, params) async {
  final api = ref.watch(chatAPIProvider);
  await api.markConversationAsCompleted(
      params.userToken, params.conversationId);
});

// /// Socket provider
// final socketProvider = Provider<IO.Socket>((ref) {
//   final socket = IO.io(
//     'https://pushnotifications.pravasitax.com', // Replace with your server URL
//     IO.OptionBuilder()
//         .setTransports(['websocket']) // Use WebSocket transport
//         .disableAutoConnect() // Disable auto-connect
//         .build(),
//   );

//   socket.connect();

//   ref.onDispose(() {
//     socket.disconnect();
//   });

//   return socket;
// });

// /// Stream provider for new messages with `userId` as a parameter
// final newMessageProvider =
//     StreamProvider.family<List<MessageModel>, String>((ref, userId) async* {
//   final socket = ref.watch(socketProvider);

//   // List to store chat messages
//   final List<MessageModel> messages = [];

//   // Stream controller to emit updates
//   final controller = StreamController<List<MessageModel>>();

//   // Register the userId when the socket connects
//   socket.onConnect((_) {
//     socket.emit('register', userId);
//     log('Connecting');
//   });

//   // Listen for `newMessage` events

//   socket.on('newMessage', (data) {
//     if (data is Map<String, dynamic>) {
//       final newMessage = MessageModel.fromJson(data);
//       messages.add(newMessage);
//       controller
//           .add(List<MessageModel>.from(messages)); // Emit updated messages
//     }
//   });

//   // Yield initial empty state
//   yield List<MessageModel>.from(messages);

//   // Dispose the controller when the provider is disposed
//   ref.onDispose(() {
//     controller.close();
//   });

//   // Return the stream from the controller
//   yield* controller.stream;
// });

// Define a Socket.IO client providerr
final socketIoClientProvider = Provider<SocketIoClient>((ref) {
  return SocketIoClient();
});

// Define a message stream provider
final messageStreamProvider = StreamProvider.autoDispose<MessageModel>((ref) {
  final socketIoClient = ref.read(socketIoClientProvider);
  return socketIoClient.messageStream;
});

class SocketIoClient {
  late IO.Socket _socket;
  final _controller = StreamController<MessageModel>.broadcast();

  SocketIoClient();

  Stream<MessageModel> get messageStream => _controller.stream;

  void connect(String senderId, WidgetRef ref) {
    const uri = 'https://pushnotifications.pravasitax.com';

    // Initialize socket.io client
    _socket = IO.io(
      uri,
      IO.OptionBuilder()
          .setTransports(['websocket']) // Use WebSocket transport
          .disableAutoConnect() // Disable auto-connect
          .build(),
    );

    log('Connecting to: $uri');

    // Listen for connection events
    _socket.onConnect((_) {
          _socket.emit('register', senderId);
          
      log('Connected to: $uri');
    });

    // Listen to messages from the server
    _socket.on('newMessage', (data) {
      log(data.toString());
      print("im inside event listener");
      print('Received message: $data');
      log(' Received message${data.toString()}');
      final messageModel = MessageModel.fromJson(data);

   
      if (!_controller.isClosed) {
        _controller.add(messageModel);
      }
    });

    // Handle connection errors
    _socket.on('connect_error', (error) {
      print('Connection Error: $error');
      if (!_controller.isClosed) {
        _controller.addError(error);
      }
    });

    // Handle disconnection
    _socket.onDisconnect((_) {
      print('Disconnected from server');
      if (!_controller.isClosed) {
        _controller.close();
      }
    });

    // Connect manually
    _socket.connect();
  }

  void disconnect() {
    _socket.disconnect();
    _socket.dispose(); // To prevent memory leaks
    if (!_controller.isClosed) {
      _controller.close();
    }
  }
}
