import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:pravasitax_flutter/src/data/models/user_model.dart';

class UserAPI {
  static const String baseUrl = 'https://pravasitax.com/api/user';
  static const String bearerToken = 'M6nBvCxAiL9d8eFgHjKmPqRs';

  final http.Client _client;

  UserAPI(this._client);

  Future<void> updateUser({
    required String userToken,
    required String name,
    String? mobile,
    String? countryCode,
    String? residingCountry,
  }) async {
    try {
      final data = {
        'name': name,
        if (mobile != null) 'mobile': mobile,
        if (countryCode != null) 'country_code': countryCode,
        if (residingCountry != null) 'residing_country': residingCountry,
      };

      final response = await _client.post(
        Uri.parse('$baseUrl/update'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'User-Token': userToken,
        },
        body: {
          'data': json.encode(data),
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update user');
      }

      final responseData = json.decode(response.body);
      if (responseData['response'] != '200') {
        throw Exception(responseData['message'] ?? 'Failed to update user');
      }
    } catch (e) {
      developer.log('Error updating user', error: e);
      rethrow;
    }
  }

  Future<User> getDetails(String userToken) async {
    try {
      developer.log('Fetching user details with token: [REDACTED]',
          name: 'UserAPI');

      final response = await _client.get(
        Uri.parse('$baseUrl/get-details'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'User-Token': userToken,
          'Content-Type': 'application/json',
        },
      );

      developer.log(
        'Response received:\n'
        'Status Code: ${response.statusCode}\n'
        'Headers: ${response.headers}\n'
        'Body: ${response.body}',
        name: 'UserAPI',
      );

      final responseData = json.decode(response.body);
      developer.log(
        'Parsed response data: $responseData',
        name: 'UserAPI',
      );

      if (responseData['response'] != '200') {
        developer.log(
          'Error: Invalid response code\n'
          'Message: ${responseData['message']}',
          name: 'UserAPI',
        );
        throw Exception(
            responseData['message'] ?? 'Failed to get user details');
      }

      if (responseData['data'] == null || responseData['data'] == '') {
        developer.log(
          'No user data found, returning default user',
          name: 'UserAPI',
        );
        return User(
          name: '',
          email: null,
          mobile: null,
          countryCode: null,
          residingCountry: null,
          department: null,
          designation: null,
        );
      }

      developer.log(
        'User data from API: ${responseData['data']}',
        name: 'UserAPI',
      );

      return User.fromJson(responseData['data']);
    } catch (e, stack) {
      developer.log(
        'Error getting user details',
        error: e,
        stackTrace: stack,
        name: 'UserAPI',
      );
      rethrow;
    }
  }
}

final userAPIProvider = Provider<UserAPI>((ref) {
  return UserAPI(http.Client());
});
