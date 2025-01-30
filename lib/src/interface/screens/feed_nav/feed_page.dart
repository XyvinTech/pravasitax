import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pravasitax_flutter/src/data/providers/news_provider.dart';
import 'package:pravasitax_flutter/src/data/models/news_model.dart';
import 'package:video_player/video_player.dart';
import 'dart:developer' as developer;

class _CachedVideoController {
  final VideoPlayerController controller;
  final DateTime createdAt;

  _CachedVideoController(this.controller) : createdAt = DateTime.now();

  bool get isExpired => DateTime.now().difference(createdAt).inHours >= 1;
}

class FeedPage extends ConsumerStatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  final PageController _pageController = PageController();
  Map<String, _CachedVideoController> _videoControllers = {};
  VideoPlayerController? _currentlyPlayingController;

  // Class to track video controller creation time

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onScroll);
    // Initialize video for first item if it's a video
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final news = ref.read(newsListProvider);
      if (news.isNotEmpty && news[0].media.type == 'video') {
        await _initializeVideoForIndex(0);
      }
    });
  }

  Future<void> _initializeVideoForIndex(int index) async {
    try {
      // Pause currently playing video if any
      if (_currentlyPlayingController != null) {
        await _currentlyPlayingController!.pause();
        _currentlyPlayingController = null;
      }

      final news = ref.read(newsListProvider);
      if (index < news.length && news[index].media.type == 'video') {
        developer.log(
            'Initializing video for index $index with URL: ${news[index].media.url}',
            name: 'FeedPage');
        final controller =
            await _getVideoController(news[index].media.url, news[index].id);
        if (mounted) {
          _currentlyPlayingController = controller;
          await controller.play();
          setState(() {});
        }
      }
    } catch (e, stack) {
      developer.log('Error initializing video',
          error: e, stackTrace: stack, name: 'FeedPage');
    }
  }

  Future<VideoPlayerController> _getVideoController(
      String url, String newsId) async {
    try {
      // Check if we have a cached controller that's not expired
      if (_videoControllers.containsKey(newsId)) {
        final cached = _videoControllers[newsId]!;
        if (!cached.isExpired) {
          developer.log('Returning cached controller for $newsId',
              name: 'FeedPage');
          return cached.controller;
        } else {
          developer.log('Removing expired controller for $newsId',
              name: 'FeedPage');
          await cached.controller.dispose();
          _videoControllers.remove(newsId);
        }
      }

      // Try to use HTTPS if the URL is HTTP
      String secureUrl = url;
      if (url.startsWith('http://')) {
        secureUrl = 'https://' + url.substring(7);
        developer.log('Converting to secure URL: $secureUrl', name: 'FeedPage');
      }

      developer.log('Creating new controller for URL: $secureUrl',
          name: 'FeedPage');

      // Create the controller with additional configuration
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(secureUrl),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
        httpHeaders: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
          'Cache-Control': 'max-age=3600', // 1 hour cache
        },
      );

      // Initialize with retry mechanism
      bool initialized = false;
      int retryCount = 0;
      const maxRetries = 3;

      while (!initialized && retryCount < maxRetries) {
        try {
          await controller.initialize();
          initialized = true;
          developer.log(
              'Controller initialized successfully on attempt ${retryCount + 1}',
              name: 'FeedPage');
        } catch (e) {
          retryCount++;
          // If using HTTPS failed on first try, fall back to HTTP
          if (retryCount == 1 && secureUrl != url) {
            developer.log('HTTPS failed, falling back to HTTP: $url',
                name: 'FeedPage');
            controller.dispose();
            final httpController = VideoPlayerController.networkUrl(
              Uri.parse(url),
              videoPlayerOptions: VideoPlayerOptions(
                mixWithOthers: true,
                allowBackgroundPlayback: false,
              ),
              httpHeaders: {
                'User-Agent':
                    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                'Cache-Control': 'max-age=3600', // 1 hour cache
              },
            );
            await httpController.initialize();
            initialized = true;
            _videoControllers[newsId] = _CachedVideoController(httpController);
            return httpController;
          }
          if (retryCount >= maxRetries) {
            developer.log(
                'Failed to initialize video after $maxRetries attempts: $e',
                name: 'FeedPage');
            throw e;
          }
          developer.log(
              'Retry $retryCount/$maxRetries: Failed to initialize video: $e',
              name: 'FeedPage');
          await Future.delayed(Duration(seconds: 1));
        }
      }

      controller.setLooping(true);
      _videoControllers[newsId] = _CachedVideoController(controller);
      return controller;
    } catch (e, stack) {
      developer.log('Error in _getVideoController',
          error: e, stackTrace: stack, name: 'FeedPage');
      rethrow;
    }
  }

  void _onScroll() {
    if (_pageController.position.pixels >=
        _pageController.position.maxScrollExtent * 0.8) {
      if (ref.read(hasMoreNewsProvider)) {
        ref.read(newsListProvider.notifier).loadMoreNews();
      }
    }
  }

  void _disposeAllControllers() {
    for (var cached in _videoControllers.values) {
      cached.controller.dispose();
    }
    _videoControllers.clear();
    _currentlyPlayingController = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // Pause any playing video before refresh
          if (_currentlyPlayingController != null) {
            await _currentlyPlayingController!.pause();
            _currentlyPlayingController = null;
          }
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
                    CircularProgressIndicator(),
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
              onPageChanged: (index) async {
                await _initializeVideoForIndex(index);
              },
              itemBuilder: (context, index) {
                final newsItem = news[index];
                return _buildNewsPage(
                  newsItem,
                  isLastItem: index == news.length - 1 && !hasMore,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildNewsPage(News news, {bool isLastItem = false}) {
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
                    Image.network(
                      news.media.url,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 300,
                          color: Colors.grey[300],
                          child: Icon(Icons.image,
                              size: 50, color: Colors.grey[400]),
                        );
                      },
                    )
                  else if (news.media.type == 'video')
                    FutureBuilder<VideoPlayerController>(
                      future: _getVideoController(news.media.url, news.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          developer.log('Error in FutureBuilder',
                              error: snapshot.error,
                              stackTrace: snapshot.stackTrace,
                              name: 'FeedPage');
                          return Container(
                            height: 300,
                            color: Colors.grey[300],
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.error_outline,
                                      size: 50, color: Colors.grey[400]),
                                  SizedBox(height: 8),
                                  Text('Error loading video',
                                      style:
                                          TextStyle(color: Colors.grey[600])),
                                  SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        // Remove the existing controller to force a retry
                                        _videoControllers.remove(news.id);
                                      });
                                    },
                                    child: Text('Retry'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return GestureDetector(
                            onTap: () {
                              if (snapshot.data!.value.isPlaying) {
                                snapshot.data!.pause();
                              } else {
                                snapshot.data!.play();
                              }
                              setState(() {});
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 300,
                                  child: AspectRatio(
                                    aspectRatio:
                                        snapshot.data!.value.aspectRatio,
                                    child: VideoPlayer(snapshot.data!),
                                  ),
                                ),
                                if (!snapshot.data!.value.isPlaying)
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.black45,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }
                        return Container(
                          height: 300,
                          color: Colors.black,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Loading video...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
