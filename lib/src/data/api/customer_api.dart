import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:pravasitax_flutter/src/data/models/customer_model.dart';

class CustomerAPI {
  static const String baseUrl = 'https://pravasitax.com/api/customer';
  static const String bearerToken = 'M6nBvCxAiL9d8eFgHjKmPqRs';

  final http.Client _client;

  CustomerAPI(this._client);

  Future<void> updateCustomer({
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
        throw Exception('Failed to update customer');
      }

      final responseData = json.decode(response.body);
      if (responseData['response'] != '200') {
        throw Exception(responseData['message'] ?? 'Failed to update customer');
      }
    } catch (e) {
      developer.log('Error updating customer', error: e);
      rethrow;
    }
  }

  Future<Customer> getDetails(String userToken) async {
    try {
      developer.log('Fetching customer details with token: [REDACTED]',
          name: 'CustomerAPI');

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
        name: 'CustomerAPI',
      );

      final responseData = json.decode(response.body);
      developer.log(
        'Parsed response data: $responseData',
        name: 'CustomerAPI',
      );

      if (responseData['response'] != '200' &&
          responseData['response'] != '2') {
        developer.log(
          'Error: Invalid response code\n'
          'Message: ${responseData['message']}',
          name: 'CustomerAPI',
        );
        throw Exception(
            responseData['message'] ?? 'Failed to get customer details');
      }

      if (responseData['data'] == null || responseData['data'] == '') {
        developer.log(
          'No customer data found, returning default customer',
          name: 'CustomerAPI',
        );
        return Customer(
          name: '',
          email: null,
          mobile: null,
          countryCode: null,
          residingCountry: null,
        );
      }

      developer.log(
        'Customer data from API: ${responseData['data']}',
        name: 'CustomerAPI',
      );

      return Customer.fromJson(responseData['data']);
    } catch (e, stack) {
      developer.log(
        'Error getting customer details',
        error: e,
        stackTrace: stack,
        name: 'CustomerAPI',
      );
      rethrow;
    }
  }
}

final customerAPIProvider = Provider<CustomerAPI>((ref) {
  return CustomerAPI(http.Client());
});
