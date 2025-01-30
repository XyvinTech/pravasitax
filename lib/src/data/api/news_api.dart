import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;
import '../models/news_model.dart';

class NewsAPI {
  static const String baseUrl = 'https://pravasitax.com/api/news';
  static const String bearerToken = 'M6nBvCxAiL9d8eFgHjKmPqRs';

  final http.Client _client;

  NewsAPI(this._client);

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      };

  Future<List<News>> getNews({int limit = 10, int skip = 0}) async {
    try {
      final queryParams = {
        'limit': limit.toString(),
        'skip': skip.toString(),
      };

      final uri =
          Uri.parse('$baseUrl/get').replace(queryParameters: queryParams);

      developer.log('Fetching news with URL: $uri', name: 'NewsAPI');

      final response = await _client.get(uri, headers: _headers);

      developer.log('Response status code: ${response.statusCode}',
          name: 'NewsAPI');
      developer.log('Response body: ${response.body}', name: 'NewsAPI');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['response'] == '200') {
          final List<dynamic> news = responseData['data'];
          return news.map((item) => News.fromJson(item)).toList();
        }
        throw Exception(responseData['message'] ?? 'Failed to fetch news');
      }
      throw Exception('Failed to fetch news: ${response.statusCode}');
    } catch (e, stack) {
      developer.log(
        'Error fetching news',
        error: e,
        stackTrace: stack,
        name: 'NewsAPI',
      );
      throw Exception('Failed to fetch news: $e');
    }
  }
}

final newsAPIProvider = Provider<NewsAPI>((ref) {
  return NewsAPI(http.Client());
});
