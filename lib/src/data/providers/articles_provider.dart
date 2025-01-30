import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/information_hub_api.dart';
import '../models/article_model.dart';

final selectedCategoryProvider = StateProvider<String?>((ref) => null);
final selectedSubCategoryProvider = StateProvider<String?>((ref) => null);

final currentPageProvider = StateProvider<int>((ref) => 0);
final hasMoreArticlesProvider = StateProvider<bool>((ref) => true);
final articlesListProvider =
    StateNotifierProvider<ArticlesNotifier, List<Article>>((ref) {
  return ArticlesNotifier(ref);
});

class ArticlesNotifier extends StateNotifier<List<Article>> {
  final Ref ref;
  bool isLoading = false;

  ArticlesNotifier(this.ref) : super([]) {
    loadMoreArticles();
  }

  Future<void> loadMoreArticles() async {
    if (isLoading || !ref.read(hasMoreArticlesProvider)) return;

    try {
      isLoading = true;
      final api = ref.read(informationHubAPIProvider);
      final currentPage = ref.read(currentPageProvider);
      final category = ref.read(selectedCategoryProvider);
      final subCategory = ref.read(selectedSubCategoryProvider);

      log('Loading page $currentPage', name: 'ArticlesNotifier');

      final articles = await api.getArticles(
        limit: 10,
        skip: currentPage * 10,
        category: category,
        subCategory: subCategory,
      );

      if (articles.isEmpty) {
        ref.read(hasMoreArticlesProvider.notifier).state = false;
      } else {
        state = [...state, ...articles];
        ref.read(currentPageProvider.notifier).state = currentPage + 1;
      }
    } catch (e, stack) {
      log('Error loading articles',
          error: e, stackTrace: stack, name: 'ArticlesNotifier');
    } finally {
      isLoading = false;
    }
  }

  void refresh() {
    state = [];
    ref.read(currentPageProvider.notifier).state = 0;
    ref.read(hasMoreArticlesProvider.notifier).state = true;
    loadMoreArticles();
  }
}

final categoriesProvider =
    FutureProvider<List<CategorySubCategory>>((ref) async {
  final api = ref.watch(informationHubAPIProvider);
  try {
    log('Loading categories', name: 'categoriesProvider');
    final categories = await api.getCategorySubCategories();
    log('Categories loaded successfully: ${categories.length} categories',
        name: 'categoriesProvider');
    return categories;
  } catch (e, stack) {
    log(
      'Error loading categories in provider',
      error: e,
      stackTrace: stack,
      name: 'categoriesProvider',
    );
    rethrow;
  }
});

final articleDetailProvider =
    FutureProvider.family<Article, String>((ref, id) async {
  final api = ref.watch(informationHubAPIProvider);
  return api.getArticle(id);
});
