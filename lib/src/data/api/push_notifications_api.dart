import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

class PushNotificationsAPI {
  static const String baseUrl = 'https://pushnotifications.pravasitax.com';

  final http.Client _client;

  PushNotificationsAPI(this._client);

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
      };

  Future<void> registerFCMToken(String userId, String fcmToken) async {
    log('userId:$userId\n fcm:$fcmToken');
    try {
      final uri = Uri.parse('$baseUrl/register-fcm-token');

      final data = {
        'userId': userId,
        'fcmToken': fcmToken,
      };

      developer.log('Registering FCM token with data: $data',
          name: 'PushNotificationsAPI');

      final response = await _client.post(
        uri,
        headers: _headers,
        body: json.encode(data),
      );

      developer.log('Register FCM token response: ${response.body}',
          name: 'PushNotificationsAPI');

      if (response.statusCode != 200) {
        throw Exception('Failed to register FCM token: ${response.statusCode}');
      }

      final responseData = json.decode(response.body);
      if (responseData['response'] != '200') {
        throw Exception(
            responseData['message'] ?? 'Failed to register FCM token');
      }
    } catch (e, stack) {
      developer.log(
        'Error registering FCM token',
        error: e,
        stackTrace: stack,
        name: 'PushNotificationsAPI',
      );
      throw Exception('Failed to register FCM token: $e');
    }
  }
}

final pushNotificationsAPIProvider = Provider<PushNotificationsAPI>((ref) {
  return PushNotificationsAPI(http.Client());
});
