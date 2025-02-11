import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pravasitax_flutter/src/data/providers/news_provider.dart';
import 'package:pravasitax_flutter/src/data/models/news_model.dart';
import 'package:pravasitax_flutter/src/interface/widgets/video_web_view.dart';
import 'dart:developer' as developer;
import 'package:pravasitax_flutter/src/interface/widgets/loading_indicator.dart';

class FeedPage extends ConsumerStatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  final PageController _pageController = PageController();
  int? _currentVideoIndex;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_pageController.position.pixels >=
        _pageController.position.maxScrollExtent * 0.8) {
      if (ref.read(hasMoreNewsProvider)) {
        ref.read(newsListProvider.notifier).loadMoreNews();
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(newsListProvider.notifier).refresh();
        },
        child: Consumer(
          builder: (context, ref, child) {
            final news = ref.watch(newsListProvider);
            final hasMore = ref.watch(hasMoreNewsProvider);

            // Handle initial loading and errors
            if (news.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading news...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        ref.read(newsListProvider.notifier).refresh();
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: news.length,
              physics: const AlwaysScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentVideoIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final newsItem = news[index];
                return _buildNewsPage(
                  newsItem,
                  isLastItem: index == news.length - 1 && !hasMore,
                  isCurrentPage: _currentVideoIndex == index,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildNewsPage(News news,
      {bool isLastItem = false, bool isCurrentPage = false}) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (news.media.type == 'image')
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          news.media.url,
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(Icons.image,
                                  size: 50, color: Colors.grey[400]),
                            );
                          },
                        ),
                      ),
                    )
                  else if (news.media.type == 'video')
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: isCurrentPage
                            ? VideoWebView(
                                videoUrl: news.media.url,
                                autoPlay: true,
                                looping: true,
                                borderRadius: 16,
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.play_arrow_rounded,
                                      size: 50,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xFF66A9F3C7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'FINANCE',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF0F7036),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          news.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          news.createdAt,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          news.content,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isLastItem)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    'Swipe down for next story',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          if (isLastItem)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'End of feed',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
