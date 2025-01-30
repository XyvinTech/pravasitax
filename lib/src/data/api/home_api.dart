import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;
import '../models/home_page_model.dart';

class HomeAPI {
  static const String baseUrl = 'https://pravasitax.com/api/home';
  static const String bearerToken = 'M6nBvCxAiL9d8eFgHjKmPqRs';

  final http.Client _client;

  HomeAPI(this._client);

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      };

  DateTime? _parseDateTime(dynamic dateData) {
    try {
      if (dateData == null) return null;

      if (dateData is Map && dateData['\$date'] is Map) {
        final longValue = dateData['\$date']['\$numberLong'];
        if (longValue != null) {
          return DateTime.fromMillisecondsSinceEpoch(
              int.parse(longValue.toString()));
        }
      }
      return null;
    } catch (e) {
      developer.log('Error parsing date: $e', name: 'HomeAPI');
      return null;
    }
  }

  Future<HomePageData> getHomePageData() async {
    try {
      developer.log('Fetching home page data from API', name: 'HomeAPI');

      final response = await _client.post(
        Uri.parse('$baseUrl/get-home-page-data'),
        headers: _headers,
      );

      developer.log('API Response Status Code: ${response.statusCode}',
          name: 'HomeAPI');
      developer.log('API Response Body: ${response.body}', name: 'HomeAPI');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['response'] == '200') {
          try {
            developer.log(
                'Raw service list data: ${responseData['data']['serviceList']}',
                name: 'HomeAPI');
            developer.log(
                'Raw tax tools data: ${responseData['data']['taxTools']}',
                name: 'HomeAPI');

            // Safely transform the data before parsing
            final Map<String, dynamic> transformedData = {
              'serviceList': (responseData['data']['serviceList'] as List?)
                      ?.map((item) => {
                            'service': item['service'] ?? '',
                            'url': item['url'],
                            'image': item['image'],
                          })
                      .toList() ??
                  [],
              'scenarios': (responseData['data']['scenarios'] as List?)
                      ?.map((item) => {
                            'scenario': item['scenario'] ?? '',
                            'url': item['url'],
                          })
                      .toList() ??
                  [],
              'firstSectionBanners':
                  (responseData['data']['firstSectionBanners'] as List?)
                          ?.map((item) => {
                                'title': item['title'] ?? '',
                                'label': item['label'] ?? '',
                                'url': item['url'],
                                'image': item['image'] ?? '',
                                'button': item['button'],
                              })
                          .toList() ??
                      [],
              'taxTools': (responseData['data']['taxTools'] as List?)
                      ?.map((item) => {
                            'title': item['title'] ?? '',
                            'url': item['url'],
                            'image': item['image'],
                          })
                      .toList() ??
                  [],
              'event': responseData['data']['event'] != null
                  ? {
                      'title': responseData['data']['event']['title'] ?? '',
                      'type': responseData['data']['event']['type'],
                      'banner': responseData['data']['event']['banner'] ?? '',
                      'date': responseData['data']['event']['date'] ?? '',
                      'time': responseData['data']['event']['time'] ?? '',
                      'location':
                          responseData['data']['event']['location'] ?? '',
                      'price': responseData['data']['event']['price'],
                    }
                  : null,
              'blogs': (responseData['data']['blogs'] as List?)
                      ?.map((item) => {
                            'id': item['_id'] ?? '',
                            'title': item['title'] ?? '',
                            'url': item['url'],
                            'shortDescription': item['short_description'],
                            'author': item['author'],
                            'postedDate': _parseDateTime(item['posted_date']),
                            'tags':
                                (item['tags'] as List?)?.cast<String>() ?? [],
                            'thumbnail': item['thumbnail'],
                            'category': item['category'],
                            'subCategory': item['sub_category'],
                            'statusText': item['status_text'],
                          })
                      .toList() ??
                  [],
            };

            developer.log('Transformed data: $transformedData',
                name: 'HomeAPI');

            final homeData = HomePageData.fromJson(transformedData);
            developer.log('Successfully parsed home page data',
                name: 'HomeAPI');
            return homeData;
          } catch (e, stackTrace) {
            developer.log(
              'Error parsing home page data',
              error: e,
              stackTrace: stackTrace,
              name: 'HomeAPI',
            );
            throw Exception('Failed to parse home data: $e');
          }
        }
        throw Exception(responseData['message'] ?? 'Failed to fetch home data');
      }
      throw Exception('Failed to fetch home data: ${response.statusCode}');
    } catch (e, stackTrace) {
      developer.log(
        'Error fetching home page data',
        error: e,
        stackTrace: stackTrace,
        name: 'HomeAPI',
      );
      throw Exception(e.toString());
    }
  }
}

final homeAPIProvider = Provider<HomeAPI>((ref) {
  return HomeAPI(http.Client());
});
