import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pravasitax_flutter/src/data/models/event_model.dart';
import 'package:pravasitax_flutter/src/data/providers/articles_provider.dart';
import 'package:pravasitax_flutter/src/data/models/article_model.dart';
import 'package:pravasitax_flutter/src/interface/screens/i_hub_nav/article_detail_page.dart';
import 'package:pravasitax_flutter/src/data/providers/events_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:pravasitax_flutter/src/interface/widgets/loading_indicator.dart';

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

  static const Color primaryColor = Color(0xFFF9B406);
  static const Color secondaryColor = Color(0xFF040F4F);

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
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: TabBar(
              controller: _tabController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: primaryColor,
                  width: 1.5,
                ),
              ),
              labelColor: secondaryColor,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                letterSpacing: 0.5,
                color: Colors.grey[600],
              ),
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.article_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('BLOGS'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('EVENTS'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BlogsSection(scrollController: _scrollController),
          EventsSection(),
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
          ? const Center(child: LoadingIndicator())
          : SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
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
                                padding: const EdgeInsets.only(left: 8),
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
                    loading: () => const SizedBox.shrink(),
                    error: (error, stack) =>
                        const Text('Error loading categories'),
                  ),
                  const SizedBox(height: 16),
                  ...articles.map((article) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildArticleCard(context, article),
                      )),
                  if (hasMore)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: LoadingIndicator(),
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
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFFF9B406).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? const Color(0xFFF9B406) : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? const Color(0xFF040F4F) : Colors.grey[600],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, Article article) {
    return InkWell(
      onTap: article.id != null
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ArticleDetailPage(articleId: article.id),
                ),
              );
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.thumbnail != null)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  article.thumbnail!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9B406).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      article.category.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF040F4F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF040F4F),
                    ),
                  ),
                  if (article.shortDescription != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      article.shortDescription!,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        radius: 16,
                        child: Icon(Icons.person_outline,
                            size: 20, color: Colors.grey[400]),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (article.author != null)
                            Text(
                              article.author!,
                              style: const TextStyle(
                                color: Color(0xFF040F4F),
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          if (article.postedDate != null)
                            Text(
                              '${article.postedDate!.day} ${_getMonthName(article.postedDate!.month)} ${article.postedDate!.year}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Events section

class EventsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          eventsAsync.when(
            data: (events) => Column(
              children: events
                  .map((event) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildEventCard(
                          context,
                          ref,
                          event: event,
                        ),
                      ))
                  .toList(),
            ),
            loading: () => const Center(child: LoadingIndicator()),
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
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailPage(event: event),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                if (event.thumbnail != null)
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      event.thumbnail!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.event_outlined,
                        size: 50, color: Colors.grey[400]),
                  ),
                if (event.status == 'LIVE')
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: event.status == 'LIVE'
                            ? const Color(0xFF040F4F)
                            : event.status == 'PAST'
                                ? Colors.grey[600]
                                : const Color(0xFFF9B406),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        event.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        event.type.toUpperCase(),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9B406).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 14,
                              color: Color(0xFF040F4F),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${event.date.day} ${_getMonthName(event.date.month)} ${event.date.year}',
                              style: const TextStyle(
                                color: Color(0xFF040F4F),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF040F4F).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.access_time_outlined,
                              size: 14,
                              color: Color(0xFF040F4F),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              event.time,
                              style: const TextStyle(
                                color: Color(0xFF040F4F),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    event.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  if (event.speakers.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ...event.speakers.take(3).map((speaker) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: CircleAvatar(
                                radius: 16,
                                backgroundImage: speaker.image != null
                                    ? NetworkImage(speaker.image!)
                                    : null,
                                backgroundColor: Colors.grey[200],
                                child: speaker.image == null
                                    ? Icon(Icons.person_outline,
                                        size: 20, color: Colors.grey[400])
                                    : null,
                              ),
                            )),
                        if (event.speakers.length > 3)
                          CircleAvatar(
                            radius: 16,
                            backgroundColor:
                                const Color(0xFF040F4F).withOpacity(0.1),
                            child: Text(
                              '+${event.speakers.length - 3}',
                              style: const TextStyle(
                                color: Color(0xFF040F4F),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// New screen for EventDetailPage

class EventDetailPage extends ConsumerStatefulWidget {
  final Event event;

  static const Color primaryColor = Color(0xFFF9B406);
  static const Color secondaryColor = Color(0xFF040F4F);

  const EventDetailPage({required this.event});

  @override
  ConsumerState<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends ConsumerState<EventDetailPage> {
  late Event _event;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
  }

  void _showWebViewDialog(BuildContext context, String htmlContent) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      icon: const Icon(Icons.close,
                          color: EventDetailPage.secondaryColor),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    title: const Text(
                      'Event Registration',
                      style: TextStyle(
                        color: EventDetailPage.secondaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    elevation: 0,
                  ),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: EventDetailPage.secondaryColor, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _event.title,
          style: const TextStyle(
            color: EventDetailPage.secondaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!, width: 1),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      if (_event.thumbnail != null)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: Image.network(
                            _event.thumbnail!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                          ),
                          alignment: Alignment.center,
                          child: Icon(Icons.event_outlined,
                              size: 50, color: Colors.grey[400]),
                        ),
                      if (_event.status == 'LIVE')
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _event.status == 'LIVE'
                                  ? EventDetailPage.secondaryColor
                                  : _event.status == 'PAST'
                                      ? Colors.grey[600]
                                      : EventDetailPage.primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _event.status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: EventDetailPage.primaryColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.calendar_today_outlined,
                                      size: 14,
                                      color: EventDetailPage.secondaryColor),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${_event.date.day} ${_getMonthName(_event.date.month)} ${_event.date.year}',
                                    style: const TextStyle(
                                      color: EventDetailPage.secondaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: EventDetailPage.secondaryColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.access_time_outlined,
                                      size: 14,
                                      color: EventDetailPage.secondaryColor),
                                  const SizedBox(width: 6),
                                  Text(
                                    _event.time,
                                    style: const TextStyle(
                                      color: EventDetailPage.secondaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _event.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: EventDetailPage.secondaryColor,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _event.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_event.speakers.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'Speakers',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: EventDetailPage.secondaryColor,
                ),
              ),
              const SizedBox(height: 16),
              ..._event.speakers.map((speaker) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!, width: 1),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: speaker.image != null
                                ? NetworkImage(speaker.image!)
                                : null,
                            backgroundColor: Colors.grey[200],
                            child: speaker.image == null
                                ? Icon(Icons.person_outline,
                                    color: Colors.grey[400], size: 32)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  speaker.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: EventDetailPage.secondaryColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  speaker.role,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (speaker.linkedinUrl != null)
                            IconButton(
                              icon: const Icon(FontAwesomeIcons.linkedin,
                                  color: Color(0xFF0A66C2), size: 24),
                              onPressed: () {
                                // Open LinkedIn URL
                              },
                            ),
                        ],
                      ),
                    ),
                  )),
            ],
            if (_event.venue != null && _event.type != 'online') ...[
              const SizedBox(height: 24),
              const Text(
                'Venue',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: EventDetailPage.secondaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: EventDetailPage.secondaryColor, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _event.venue!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            InkWell(
              onTap: _event.isBooked
                  ? null
                  : () async {
                      try {
                        final int? selectedSeats = await showDialog<int>(
                          context: context,
                          builder: (BuildContext context) {
                            int seats = 1;
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Select Seats',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                EventDetailPage.secondaryColor,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          '${_event.availableSeats} seats available',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.remove_circle_outline,
                                                color: seats > 1
                                                    ? EventDetailPage
                                                        .secondaryColor
                                                    : Colors.grey[400],
                                                size: 32,
                                              ),
                                              onPressed: () {
                                                if (seats > 1) {
                                                  setState(() => seats--);
                                                }
                                              },
                                            ),
                                            Container(
                                              width: 64,
                                              alignment: Alignment.center,
                                              child: Text(
                                                seats.toString(),
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w600,
                                                  color: EventDetailPage
                                                      .secondaryColor,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.add_circle_outline,
                                                color: seats <
                                                        _event.availableSeats
                                                    ? EventDetailPage
                                                        .secondaryColor
                                                    : Colors.grey[400],
                                                size: 32,
                                              ),
                                              onPressed: () {
                                                if (seats <
                                                    _event.availableSeats) {
                                                  setState(() => seats++);
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 24),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 12),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    side: BorderSide(
                                                        color:
                                                            Colors.grey[300]!),
                                                  ),
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 12),
                                                  backgroundColor:
                                                      EventDetailPage
                                                          .primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                onPressed: () => Navigator.pop(
                                                    context, seats),
                                                child: const Text(
                                                  'Confirm',
                                                  style: TextStyle(
                                                    color: EventDetailPage
                                                        .secondaryColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );

                        if (selectedSeats != null) {
                          if (_event.price == 0) {
                            final bookingResult =
                                await ref.read(eventBookingProvider((
                              eventId: _event.id,
                              seats: selectedSeats,
                            )).future);

                            if (bookingResult != null) {
                              if (bookingResult.startsWith('<!DOCTYPE html>')) {
                                _showWebViewDialog(context, bookingResult);
                              } else {
                                // Show success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Successfully registered for the event!'),
                                    backgroundColor: Color(0xFF0F7036),
                                  ),
                                );

                                // Refresh events list
                                ref.refresh(eventsProvider);

                                // Update local event state to show as booked
                                setState(() {
                                  _event = Event(
                                    id: _event.id,
                                    title: _event.title,
                                    description: _event.description,
                                    date: _event.date,
                                    time: _event.time,
                                    type: _event.type,
                                    price: _event.price,
                                    availableSeats: _event.availableSeats,
                                    speakers: _event.speakers,
                                    venue: _event.venue,
                                    thumbnail: _event.thumbnail,
                                    status: _event.status,
                                    isBooked: true,
                                  );
                                });
                              }
                            }
                          } else {
                            final bookingResult =
                                await ref.read(eventBookingProvider((
                              eventId: _event.id,
                              seats: selectedSeats,
                            )).future);

                            if (bookingResult != null) {
                              if (bookingResult.startsWith('<!DOCTYPE html>')) {
                                _showWebViewDialog(context, bookingResult);
                              }
                            }
                          }
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
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _event.isBooked
                      ? Colors.grey[300]
                      : EventDetailPage.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  _event.isBooked
                      ? 'ALREADY BOOKED'
                      : _event.price == 0
                          ? 'REGISTER NOW'
                          : 'BOOK NOW - \$${_event.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: _event.isBooked
                        ? Colors.grey[600]
                        : EventDetailPage.secondaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
