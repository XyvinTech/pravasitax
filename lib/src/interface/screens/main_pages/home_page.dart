import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pravasitax_flutter/src/interface/screens/chat_nav/chat_page.dart';
import 'package:pravasitax_flutter/src/interface/screens/home_cards/tax_filing_adv.dart';
import 'package:pravasitax_flutter/src/interface/screens/home_cards/tax_tools.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/home_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as developer;
import 'package:pravasitax_flutter/src/interface/screens/common/webview_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    developer.log('Initializing HomePage', name: 'HomePage');
    Future.microtask(() {
      developer.log('Fetching home page data', name: 'HomePage');
      ref.read(homeProvider.notifier).fetchHomePageData();
    });
  }

  void _launchUrl(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: url,
          title: '', // You can customize this title
        ),
      ),
    );
  }

  String _getIconPathForService(String serviceName) {
    // Map service names to icon paths
    final Map<String, String> iconMap = {
      'Tax Filing': 'assets/icons/tax_filing.svg',
      'Wealth Planning': 'assets/icons/wealth.svg',
      'Property Related Services': 'assets/icons/property.svg',
      'PAN Related Services': 'assets/icons/pan.svg',
      // Add more mappings as needed
    };

    return iconMap[serviceName] ??
        'assets/icons/tax_filing.svg'; // Default icon
  }

  @override
  Widget build(BuildContext context) {
    developer.log('Building HomePage', name: 'HomePage');
    final homeState = ref.watch(homeProvider);

    if (homeState.isLoading) {
      developer.log('HomePage is in loading state', name: 'HomePage');
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (homeState.error != null) {
      developer.log('HomePage encountered error: ${homeState.error}',
          name: 'HomePage');
      return Scaffold(
        body: Center(child: Text('Error: ${homeState.error}')),
      );
    }

    final data = homeState.data;
    if (data == null) {
      developer.log('HomePage has no data', name: 'HomePage');
      return const Scaffold(
        body: Center(child: Text('No data available')),
      );
    }

    developer.log('HomePage data loaded successfully', name: 'HomePage');

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Section Banners
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.firstSectionBanners.length,
                  itemBuilder: (context, index) {
                    final banner = data.firstSectionBanners[index];
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      margin: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: banner.url != null
                            ? () => _launchUrl(banner.url!)
                            : null,
                        child: Stack(
                          children: [
                            // Background Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: banner.image,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.error),
                                ),
                              ),
                            ),
                            // Gradient Overlay
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                            // Content
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    banner.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    banner.label,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  if (banner.button != null) ...[
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF9B406),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        banner.button!,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Scenarios Section
              const Text(
                'Common Scenarios',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.scenarios.length,
                itemBuilder: (context, index) {
                  final scenario = data.scenarios[index];
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF040F4F),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Color(0xFFF9B406)),
                      ),
                    ),
                    title: Text(
                      scenario.scenario,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: scenario.url != null
                        ? () => _launchUrl(scenario.url!)
                        : null,
                  );
                },
              ),
              const SizedBox(height: 24),

              // Service Cards
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.6,
                child: PageView.builder(
                  itemCount: (data.serviceList.length / 4).ceil(),
                  itemBuilder: (context, pageIndex) {
                    final startIndex = pageIndex * 4;
                    final endIndex =
                        (startIndex + 4).clamp(0, data.serviceList.length);
                    final pageServices =
                        data.serviceList.sublist(startIndex, endIndex);

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.6,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: pageServices.length,
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final service = pageServices[index];
                        developer.log(
                            'Service ${service.service} image: ${service.image}',
                            name: 'HomePage');
                        return _buildServiceCard(
                          title: service.service,
                          imageUrl: service.image,
                          color: const Color(0xFFDCDCDC),
                          textColor: const Color(0xFF003366),
                          onTap: service.url != null
                              ? () => _launchUrl(service.url!)
                              : null,
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Blogs Section
              const Text(
                'Latest Blogs',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.blogs.length,
                  itemBuilder: (context, index) {
                    final blog = data.blogs[index];
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      margin: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: blog.url != null
                            ? () => _launchUrl(blog.url!)
                            : null,
                        child: Stack(
                          children: [
                            // Background Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: blog.thumbnail ?? '',
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image),
                                ),
                              ),
                            ),
                            // Gradient Overlay
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.8),
                                  ],
                                ),
                              ),
                            ),
                            // Content
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Category and Date Row
                                  Row(
                                    children: [
                                      if (blog.category != null)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF9B406),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            blog.category!,
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      if (blog.category != null)
                                        const SizedBox(width: 8),
                                      if (blog.postedDate != null)
                                        Text(
                                          _formatDate(blog.postedDate!),
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Title
                                  Text(
                                    blog.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  // Description
                                  if (blog.shortDescription != null)
                                    Text(
                                      blog.shortDescription!,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  const SizedBox(height: 12),
                                  // Read More Button
                                  Row(
                                    children: [
                                      Text(
                                        'Read More',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 16,
                                        color: Theme.of(context).primaryColor,
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
                  },
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Tools',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.taxTools.length,
                  itemBuilder: (context, index) {
                    final tool = data.taxTools[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        children: [
                          _buildToolCard(
                            context: context,
                            icon: Icons.calculate,
                            title: '',
                            imageUrl: tool.image,
                            color: const Color(0xFFFFF3F3),
                            onTap: tool.url != null
                                ? () => _launchUrl(tool.url!)
                                : null,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tool.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 10, color: Colors.black87),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Event Section
              if (data.event != null)
                _buildEventCard(
                  context: context,
                  isLive: data.event?.type?.toLowerCase() == 'live',
                  tag: data.event?.type ?? '',
                  date: data.event?.date ?? '',
                  time: data.event?.time ?? '',
                  title: data.event?.title ?? '',
                  description: data.event?.location ?? '',
                  imageUrl:
                      data.event?.banner ?? '', // Changed to use network image
                  price: data.event?.price ?? '',
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => ChatPage()),
      //     );
      //   },
      //   backgroundColor: const Color(0xFF040F4F),
      //   child: const Icon(Icons.chat, color: Color(0xFFF9B406)),
      // ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    String? imageUrl,
    required Color color,
    required Color textColor,
    VoidCallback? onTap,
  }) {
    developer.log('Building service card: $title with image: $imageUrl',
        name: 'ServiceCard');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageUrl != null && imageUrl.isNotEmpty)
              Expanded(
                flex: 4, // Increased flex from 3 to 4 to make card taller
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      developer.log('Error loading image for $title: $error',
                          name: 'ServiceCard');
                      return Icon(
                        Icons.business_center,
                        size: 48,
                        color: textColor,
                      );
                    },
                  ),
                ),
              )
            else
              Expanded(
                flex: 4, // Increased flex from 3 to 4 to make card taller
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Icon(
                    Icons.business_center,
                    size: 48,
                    color: textColor,
                  ),
                ),
              ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    String? imageUrl,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageUrl != null)
              CachedNetworkImage(
                imageUrl: imageUrl,
                width: 36,
                height: 36,
                placeholder: (context, url) => const SizedBox(
                  width: 36,
                  height: 36,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  icon,
                  size: 36,
                  color: Colors.black54,
                ),
              )
            else
              Icon(icon, size: 36, color: Colors.black54),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard({
    required BuildContext context,
    required bool isLive,
    required String tag,
    required String date,
    required String time,
    required String title,
    required String description,
    required String imageUrl,
    required String price,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isLive ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Date and time row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.yellow[800],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  date,
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(time, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Title and description
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),

          // Join Now button
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Join Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildCommonDifficultiesBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Common Difficulties in filing taxes',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Help Section Widget
  Widget _buildHelpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Difficulties in filing taxes?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('Lorem ipsum dolor sit amet consectetur.'),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Contact Us'),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
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
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
