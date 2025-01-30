import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/news_api.dart';
import '../models/news_model.dart';
import 'dart:developer' as developer;

final currentNewsPageProvider = StateProvider<int>((ref) => 0);
final hasMoreNewsProvider = StateProvider<bool>((ref) => true);

final newsListProvider = StateNotifierProvider<NewsNotifier, List<News>>((ref) {
  return NewsNotifier(ref);
});

final hasNewsProvider = FutureProvider<bool>((ref) async {
  try {
    final api = ref.read(newsAPIProvider);
    final news = await api.getNews(limit: 1, skip: 0);
    return news.isNotEmpty;
  } catch (e) {
    return false;
  }
});

class NewsNotifier extends StateNotifier<List<News>> {
  final Ref ref;
  bool isLoading = false;
  String? error;

  NewsNotifier(this.ref) : super([]) {
    loadMoreNews();
  }

  Future<void> loadMoreNews() async {
    if (isLoading || !ref.read(hasMoreNewsProvider)) return;

    try {
      isLoading = true;
      error = null;

      final api = ref.read(newsAPIProvider);
      final currentPage = ref.read(currentNewsPageProvider);

      developer.log('Loading news page $currentPage', name: 'NewsNotifier');

      final news = await api.getNews(
        limit: 10,
        skip: currentPage * 10,
      );

      if (news.isEmpty) {
        ref.read(hasMoreNewsProvider.notifier).state = false;
      } else {
        state = [...state, ...news];
        ref.read(currentNewsPageProvider.notifier).state = currentPage + 1;
      }
    } catch (e, stack) {
      developer.log(
        'Error loading news',
        error: e,
        stackTrace: stack,
        name: 'NewsNotifier',
      );
      error = e.toString();
      // If this is the first load (state is empty), rethrow to show error UI
      if (state.isEmpty) {
        rethrow;
      }
    } finally {
      isLoading = false;
    }
  }

  void refresh() {
    state = [];
    error = null;
    ref.read(currentNewsPageProvider.notifier).state = 0;
    ref.read(hasMoreNewsProvider.notifier).state = true;
    loadMoreNews();
  }
}
