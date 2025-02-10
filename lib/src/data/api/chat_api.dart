

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

class ChatAPI {
  static const String baseUrl = 'https://pravasitax.com/api';
  static const String bearerToken = 'M6nBvCxAiL9d8eFgHjKmPqRs';

  final http.Client _client;

  ChatAPI(this._client);

  Map<String, String> _getHeaders(String userToken) => {
        'Authorization': 'Bearer $bearerToken',
        'User-Token': userToken,
        'Content-Type': 'application/json',
      };

  Future<Map<String, dynamic>> createConversation(
      String userToken, String title, String type) async {
    try {
      final uri = Uri.parse('$baseUrl/chat/conversations/create');

      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll(_getHeaders(userToken))
        ..fields['conversation_title'] = title
        ..fields['conversation_type'] = type;

      final response = await http.Response.fromStream(await request.send());

      developer.log('Create conversation response: ${response.body}',
          name: 'ChatAPI');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['response'] == '200') {
          return {
            '_id': responseData['data'],
            'title': title,
            'type': type,
            'staffs': [],
            'customer': userToken,
            'created_at': DateTime.now().toString(),
            'status': 1,
            'status_text': 'active',
            'unread_messages': 0,
            'total_messages': 0,
            'last_message': ''
          };
        }
        throw Exception(
            responseData['message'] ?? 'Failed to create conversation');
      }
      throw Exception('Failed to create conversation: ${response.statusCode}');
    } catch (e, stack) {
      developer.log(
        'Error creating conversation',
        error: e,
        stackTrace: stack,
        name: 'ChatAPI',
      );
      throw Exception('Failed to create conversation: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getConversations(String userToken) async {
    try {
      final uri = Uri.parse('$baseUrl/chat/conversations/get');
      developer.log('User token: $userToken', name: 'ChatAPI');
      developer.log('Request URL: $uri', name: 'ChatAPI');
      developer.log('Headers: ${_getHeaders(userToken)}', name: 'ChatAPI');

      final response = await _client.get(uri, headers: _getHeaders(userToken));

      developer.log('Get conversations raw response: ${response.body}',
          name: 'ChatAPI');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
  
        // Validate response structure
        if (responseData is! Map<String, dynamic>) {
          throw Exception('Invalid response format: expected object');
        }

        if (responseData['response'] != '200') {
          throw Exception(responseData['message'] ??
              'Failed to get conversations: Invalid response code');
        }

        if (responseData['data'] == null || responseData['data'] is! List) {
          throw Exception('Invalid data format: expected array');
        }

        final conversations =
            List<Map<String, dynamic>>.from(responseData['data']);

        // Log parsed conversations for debugging
        developer.log('Parsed ${conversations.length} conversations',
            name: 'ChatAPI');
        for (var conversation in conversations) {
          developer.log(
              'Conversation ID: ${conversation['_id']}, Title: ${conversation['title']}',
              name: 'ChatAPI');

          // Validate staff array
          if (conversation['staffs'] != null) {
            developer.log(
                'Staff count: ${(conversation['staffs'] as List).length}',
                name: 'ChatAPI');
          }
        }

        return conversations;
      }
      throw Exception('Failed to get conversations: ${response.statusCode}');
    } catch (e, stack) {
      developer.log(
        'Error getting conversations',
        error: e,
        stackTrace: stack,
        name: 'ChatAPI',
      );
      throw Exception('Failed to get conversations: $e');
    }
  }

  Future<void> assignStaffToConversation(
      String userToken, String conversationId, String staffId) async {
    try {
      final uri =
          Uri.parse('$baseUrl/chat/conversations/assign-staff-to-conversation');

      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll(_getHeaders(userToken))
        ..fields['conversation_id'] = conversationId
        ..fields['staff_id'] = staffId;

      final response = await http.Response.fromStream(await request.send());

      developer.log('Assign staff response: ${response.body}', name: 'ChatAPI');

      if (response.statusCode != 200) {
        throw Exception('Failed to assign staff: ${response.statusCode}');
      }

      final responseData = json.decode(response.body);
      if (responseData['response'] != '200') {
        throw Exception(responseData['message'] ?? 'Failed to assign staff');
      }
    } catch (e, stack) {
      developer.log(
        'Error assigning staff',
        error: e,
        stackTrace: stack,
        name: 'ChatAPI',
      );
      throw Exception('Failed to assign staff: $e');
    }
  }

  Future<void> markConversationAsCompleted(
      String userToken, String conversationId) async {
    try {
      final uri = Uri.parse('$baseUrl/chat/conversations/mark-as-completed');

      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll(_getHeaders(userToken))
        ..fields['conversation_id'] = conversationId;

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to mark conversation as completed: ${response.statusCode}');
      }

      final responseData = json.decode(response.body);
      if (responseData['response'] != '200') {
        throw Exception(responseData['message'] ??
            'Failed to mark conversation as completed');
      }
    } catch (e, stack) {
      developer.log(
        'Error marking conversation as completed',
        error: e,
        stackTrace: stack,
        name: 'ChatAPI',
      );
      throw Exception('Failed to mark conversation as completed: $e');
    }
  }

  Future<void> sendMessage(
      String userToken, String conversationId, String message) async {
    try {
      final uri = Uri.parse('$baseUrl/chat/messages/send');

      developer.log('Sending message to conversation: $conversationId',
          name: 'ChatAPI');
      developer.log('Message content: $message', name: 'ChatAPI');

      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll(_getHeaders(userToken))
        ..fields['conversation_id'] = conversationId
        ..fields['message'] = message;

      final response = await http.Response.fromStream(await request.send());

      developer.log('Send message response: ${response.body}', name: 'ChatAPI');

      if (response.statusCode != 200) {
        throw Exception('Failed to send message: ${response.statusCode}');
      }

      final responseData = json.decode(response.body);
      if (responseData['response'] != '200') {
        throw Exception(responseData['message'] ?? 'Failed to send message');
      }
    } catch (e, stack) {
      developer.log(
        'Error sending message',
        error: e,
        stackTrace: stack,
        name: 'ChatAPI',
      );
      throw Exception('Failed to send message: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getMessages(
      String userToken, String conversationId) async {
    try {
      final uri = Uri.parse('$baseUrl/chat/messages/get').replace(
        queryParameters: {'conversation_id': conversationId},
      );

      developer.log('Getting messages for conversation: $conversationId',
          name: 'ChatAPI');
      developer.log('Request URL: $uri', name: 'ChatAPI');

      final response = await _client.get(uri, headers: _getHeaders(userToken));

      developer.log('Get messages raw response: ${response.body}',
          name: 'ChatAPI');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['response'] == '200') {
          final messages =
              List<Map<String, dynamic>>.from(responseData['data']);
          developer.log('Raw message data: $messages', name: 'ChatAPI');
          // Log each message's fields
          for (var msg in messages) {
            developer.log('Message fields: ${msg.keys.join(", ")}',
                name: 'ChatAPI');
            developer.log(
                'Message content: ${msg["message"] ?? msg["content"]}',
                name: 'ChatAPI');
          }
          // Convert message field to content if needed
          return messages
              .map((msg) => {
                    ...msg,
                    'content': msg['message'] ?? msg['content'] ?? '',
                  })
              .toList();
        }
        throw Exception(responseData['message'] ?? 'Failed to get messages');
      }
      throw Exception('Failed to get messages: ${response.statusCode}');
    } catch (e, stack) {
      developer.log(
        'Error getting messages',
        error: e,
        stackTrace: stack,
        name: 'ChatAPI',
      );
      throw Exception('Failed to get messages: $e');
    }
  }

  Future<void> markMessageAsDelivered(
      String userToken, String messageId) async {
    try {
      final uri = Uri.parse('$baseUrl/chat/message/mark-as-delivered');

      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll(_getHeaders(userToken))
        ..fields['message_id'] = messageId;

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to mark message as delivered: ${response.statusCode}');
      }

      final responseData = json.decode(response.body);
      if (responseData['response'] != '200') {
        throw Exception(
            responseData['message'] ?? 'Failed to mark message as delivered');
      }
    } catch (e, stack) {
      developer.log(
        'Error marking message as delivered',
        error: e,
        stackTrace: stack,
        name: 'ChatAPI',
      );
      throw Exception('Failed to mark message as delivered: $e');
    }
  }

  Future<void> markMessageAsRead(String userToken, String messageId) async {
    try {
      final uri = Uri.parse('$baseUrl/chat/message/mark-as-read');

      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll(_getHeaders(userToken))
        ..fields['message_id'] = messageId;

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to mark message as read: ${response.statusCode}');
      }

      final responseData = json.decode(response.body);
      if (responseData['response'] != '200') {
        throw Exception(
            responseData['message'] ?? 'Failed to mark message as read');
      }
    } catch (e, stack) {
      developer.log(
        'Error marking message as read',
        error: e,
        stackTrace: stack,
        name: 'ChatAPI',
      );
      throw Exception('Failed to mark message as read: $e');
    }
  }
}

final chatAPIProvider = Provider<ChatAPI>((ref) {
  return ChatAPI(http.Client());
});
