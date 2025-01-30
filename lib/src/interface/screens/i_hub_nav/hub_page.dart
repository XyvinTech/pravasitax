import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pravasitax_flutter/src/data/providers/articles_provider.dart';
import 'package:pravasitax_flutter/src/data/models/article_model.dart';
import 'package:pravasitax_flutter/src/interface/screens/i_hub_nav/article_detail_page.dart';
import 'package:pravasitax_flutter/src/data/providers/events_provider.dart';
import 'package:pravasitax_flutter/src/data/models/event_model.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';

// Add this utility function at the top of the file, outside any class
String _getMonthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return months[month - 1];
}

class HubPage extends ConsumerStatefulWidget {
  @override
  _HubPageState createState() => _HubPageState();
}

class _HubPageState extends ConsumerState<HubPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(articlesListProvider.notifier).loadMoreArticles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFFF9B406),
              indicatorWeight: 3,
              labelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              tabs: [
                Tab(text: 'BLOGS'),
                Tab(text: 'EVENTS'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                BlogsSection(scrollController: _scrollController),
                EventsSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BlogsSection extends ConsumerWidget {
  final ScrollController scrollController;

  const BlogsSection({required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articles = ref.watch(articlesListProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final hasMore = ref.watch(hasMoreArticlesProvider);
    final isLoading = articles.isEmpty && categoriesAsync is AsyncLoading;

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(articlesListProvider.notifier).refresh();
      },
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  categoriesAsync.when(
                    data: (categories) => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildTagButton(
                            'All',
                            isActive: selectedCategory == null,
                            onTap: () {
                              ref
                                  .read(selectedCategoryProvider.notifier)
                                  .state = null;
                              ref.read(articlesListProvider.notifier).refresh();
                            },
                          ),
                          ...categories.map((category) => Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: _buildTagButton(
                                  category.category,
                                  isActive:
                                      selectedCategory == category.category,
                                  onTap: () {
                                    ref
                                        .read(selectedCategoryProvider.notifier)
                                        .state = category.category;
                                    ref
                                        .read(articlesListProvider.notifier)
                                        .refresh();
                                  },
                                ),
                              )),
                        ],
                      ),
                    ),
                    loading: () => const SizedBox
                        .shrink(), // Hide loading indicator for categories
                    error: (error, stack) => Text('Error loading categories'),
                  ),
                  SizedBox(height: 16),
                  ...articles.map((article) => Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: _buildArticleCard(context, article),
                      )),
                  if (hasMore)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildTagButton(String text,
      {bool isActive = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? Color(0x66A9F3C7) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? Colors.transparent : Colors.grey,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Color(0xFF0F7036) : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, Article article) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (article.thumbnail != null)
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(article.thumbnail!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: Color(0xFF66A9F3C7),
          child: Text(
            article.category.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF0F7036),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          article.title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (article.shortDescription != null) ...[
          SizedBox(height: 4),
          Text(
            article.shortDescription!,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
        SizedBox(height: 8),
        Row(
          children: [
            CircleAvatar(backgroundColor: Colors.grey, radius: 15),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (article.author != null)
                  Text(article.author!, style: TextStyle(color: Colors.black)),
                if (article.postedDate != null)
                  Text(
                    '${article.postedDate!.day} ${_getMonthName(article.postedDate!.month)} ${article.postedDate!.year}',
                    style: TextStyle(color: Colors.black),
                  ),
              ],
            ),
          ],
        ),
        SizedBox(height: 8),
        if (article.id != null)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF9B406),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ArticleDetailPage(articleId: article.id),
                ),
              );
            },
            child: Text('Read more', style: TextStyle(color: Colors.black)),
          ),
      ],
    );
  }
}

// Events section

class EventsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search Events',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFD4D4D4), width: 0.5),
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.search),
            ),
          ),
          SizedBox(height: 16),
          eventsAsync.when(
            data: (events) => Column(
              children: events
                  .map((event) => Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: _buildEventCard(
                          context,
                          ref,
                          event: event,
                        ),
                      ))
                  .toList(),
            ),
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Error loading events: $error'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(
    BuildContext context,
    WidgetRef ref, {
    required Event event,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            if (event.thumbnail != null)
              Image.network(
                event.thumbnail!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 200,
                color: Colors.grey,
                alignment: Alignment.center,
                child: Icon(Icons.play_circle_outline,
                    size: 50, color: Colors.white),
              ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: event.status == 'LIVE'
                      ? Color(0xFF0F7036)
                      : Color(0xFF1266B9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  event.status,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Text(
              event.type.toUpperCase(),
              style: TextStyle(color: Colors.grey, fontSize: 10),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F0A9),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 12, color: Color(0xFF700F0F)),
                        SizedBox(width: 4),
                        Text(
                          '${event.date.day} ${_getMonthName(event.date.month)} ${event.date.year}',
                          style: TextStyle(
                            color: Color(0xFF700F0F),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(0xFF1266B9),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, size: 12, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          event.time,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          event.title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          event.description,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFF9B406),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetailPage(event: event),
              ),
            );
          },
          child: Text('View more', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}

// New screen for EventDetailPage

class EventDetailPage extends ConsumerWidget {
  final Event event;

  EventDetailPage({required this.event});

  void _showWebViewDialog(BuildContext context, String htmlContent) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text(
                    'Event Registration',
                    style: TextStyle(color: Colors.black),
                  ),
                  elevation: 0,
                ),
                Expanded(
                  child: WebViewWidget(
                    controller: WebViewController()
                      ..setJavaScriptMode(JavaScriptMode.unrestricted)
                      ..loadHtmlString(htmlContent),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(event.title),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                if (event.thumbnail != null)
                  Image.network(
                    event.thumbnail!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                else
                  Container(
                    height: 200,
                    color: Colors.grey,
                    alignment: Alignment.center,
                    child: Icon(Icons.play_circle_outline,
                        size: 50, color: Colors.white),
                  ),
                if (event.status == 'LIVE')
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              event.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  '${event.date.day} ${_getMonthName(event.date.month)} ${event.date.year}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  event.time,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: 1,
              color: Colors.grey[300],
            ),
            SizedBox(height: 16),
            Text(
              event.description,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            if (event.speakers.isNotEmpty) ...[
              SizedBox(height: 16),
              Text(
                'Speakers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ...event.speakers.map((speaker) => Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: _buildSpeakerTile(speaker),
                  )),
            ],
            if (event.venue != null && event.type != 'online') ...[
              SizedBox(height: 24),
              Text(
                'Venue',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Container(
                height: 150,
                color: Colors.grey[300],
                alignment: Alignment.center,
                child: Text(event.venue!),
              ),
            ],
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF9B406),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  try {
                    if (event.price == 0) {
                      // Free event
                      final bookingResult =
                          await ref.read(eventBookingProvider((
                        eventId: event.id,
                        seats: 1,
                      )).future);

                      if (bookingResult != null &&
                          bookingResult.startsWith('<!DOCTYPE html>')) {
                        _showWebViewDialog(context, bookingResult);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Successfully registered for the event!'),
                          ),
                        );
                      }
                    } else {
                      // Show dialog for paid events
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Book Event'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  'Price per seat: \$${event.price.toStringAsFixed(2)}'),
                              if (event.type == 'offline')
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Number of seats',
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    // Handle seats input
                                  },
                                ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context); // Close the dialog
                                try {
                                  final bookingResult =
                                      await ref.read(eventBookingProvider((
                                    eventId: event.id,
                                    seats: 1,
                                  )).future);

                                  if (bookingResult != null) {
                                    if (bookingResult
                                        .startsWith('<!DOCTYPE html>')) {
                                      _showWebViewDialog(
                                          context, bookingResult);
                                    } else {
                                      // Handle payment URL if needed
                                    }
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error booking event: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: Text('Proceed to Payment'),
                            ),
                          ],
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text(
                  event.price == 0
                      ? 'REGISTER EVENT'
                      : 'BOOK NOW - \$${event.price.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeakerTile(Speaker speaker) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage:
              speaker.image != null ? NetworkImage(speaker.image!) : null,
          child: speaker.image == null
              ? Icon(Icons.person, color: Colors.white, size: 30)
              : null,
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              speaker.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              speaker.role,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        if (speaker.linkedinUrl != null) ...[
          Spacer(),
          IconButton(
            icon: Icon(FontAwesomeIcons.linkedin,
                color: Color(0xFF0A66C2), size: 30),
            onPressed: () {
              // Open LinkedIn URL
            },
          ),
        ],
      ],
    );
  }
}
