import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;
import '../models/article_model.dart';

class InformationHubAPI {
  static const String baseUrl = 'https://pravasitax.com/api/information-hub';
  static const String bearerToken = 'M6nBvCxAiL9d8eFgHjKmPqRs';

  final http.Client _client;

  InformationHubAPI(this._client);

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      };

  Future<List<Article>> getArticles({
    int limit = 10,
    int skip = 0,
    String? category,
    String? subCategory,
  }) async {
    try {
      final queryParams = {
        'limit': limit.toString(),
        'skip': skip.toString(),
        if (category != null)
          'category': category.toLowerCase().replaceAll(' ', '-'),
        if (subCategory != null)
          'sub_category': subCategory.toLowerCase().replaceAll(' ', '-'),
      };

      final uri = Uri.parse('$baseUrl/articles-list')
          .replace(queryParameters: queryParams);

      developer.log('Fetching articles with URL: $uri',
          name: 'InformationHubAPI');
      developer.log('Headers: $_headers', name: 'InformationHubAPI');

      final response = await _client.get(uri, headers: _headers);

      developer.log('Response status code: ${response.statusCode}',
          name: 'InformationHubAPI');
      developer.log('Response body: ${response.body}',
          name: 'InformationHubAPI');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['response'] == '200') {
          final List<dynamic> articles = responseData['data'];
          return articles.map((article) => Article.fromJson(article)).toList();
        }
        throw Exception(responseData['message'] ?? 'Failed to fetch articles');
      }
      throw Exception('Failed to fetch articles: ${response.statusCode}');
    } catch (e, stackTrace) {
      developer.log(
        'Error fetching articles',
        error: e,
        stackTrace: stackTrace,
        name: 'InformationHubAPI',
      );
      throw Exception('Failed to fetch articles: $e');
    }
  }

  Future<Article> getArticle(String id) async {
    try {
      final uri = Uri.parse('$baseUrl/get-article').replace(
        queryParameters: {'id': id},
      );

      developer.log('Fetching article with URL: $uri',
          name: 'InformationHubAPI');

      final response = await _client.get(uri, headers: _headers);

      developer.log('Article response status: ${response.statusCode}',
          name: 'InformationHubAPI');
      developer.log('Article response body: ${response.body}',
          name: 'InformationHubAPI');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['response'] == '200') {
          final articleData = responseData['data'];
          return Article(
            id: articleData['_id'] ?? articleData['id'] ?? '',
            title: articleData['title'] ?? '',
            shortDescription: articleData['short_description'],
            author: articleData['author'],
            postedDate: articleData['posted_date'] != null
                ? DateTime.tryParse(articleData['posted_date'].toString())
                : null,
            tags: (articleData['tags'] as List?)?.cast<String>(),
            thumbnail: articleData['thumbnail'],
            category: articleData['category'] ?? '',
            subCategory: articleData['sub_category'],
            statusText: articleData['status_text'],
            url: articleData['url'],
            content: articleData['content'],
          );
        }
        throw Exception(responseData['message'] ?? 'Failed to fetch article');
      }
      throw Exception('Failed to fetch article: ${response.statusCode}');
    } catch (e, stackTrace) {
      developer.log(
        'Error fetching article',
        error: e,
        stackTrace: stackTrace,
        name: 'InformationHubAPI',
      );
      throw Exception('Failed to fetch article: $e');
    }
  }

  Future<List<CategorySubCategory>> getCategorySubCategories() async {
    try {
      developer.log('Fetching categories', name: 'InformationHubAPI');

      final response = await _client.get(
        Uri.parse('$baseUrl/get-category-sub-category-list'),
        headers: _headers,
      );

      developer.log('Categories response status: ${response.statusCode}',
          name: 'InformationHubAPI');
      developer.log('Categories response body: ${response.body}',
          name: 'InformationHubAPI');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['response'] == '200') {
          final Map<String, dynamic> categoriesData = responseData['data'];

          // Transform the map into a list of CategorySubCategory
          final List<CategorySubCategory> categories = [];
          categoriesData.forEach((category, subCategories) {
            categories.add(CategorySubCategory(
              category: category,
              subCategories: (subCategories as List).cast<String>(),
            ));
          });

          developer.log('Parsed categories: ${categories.length}',
              name: 'InformationHubAPI');
          return categories;
        }
        throw Exception(
            responseData['message'] ?? 'Failed to fetch categories');
      }
      throw Exception('Failed to fetch categories: ${response.statusCode}');
    } catch (e, stackTrace) {
      developer.log(
        'Error fetching categories',
        error: e,
        stackTrace: stackTrace,
        name: 'InformationHubAPI',
      );
      throw Exception('Failed to fetch categories: $e');
    }
  }
}

final informationHubAPIProvider = Provider<InformationHubAPI>((ref) {
  return InformationHubAPI(http.Client());
});
