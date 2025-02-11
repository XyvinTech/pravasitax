import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pravasitax_flutter/src/data/providers/chat_provider.dart';
import 'package:pravasitax_flutter/src/interface/screens/chat_nav/chat_page.dart';
import 'package:pravasitax_flutter/src/interface/screens/feed_nav/feed_page.dart';
import 'package:pravasitax_flutter/src/interface/screens/forum_nav/forum_user/forum_list.dart';
import 'package:pravasitax_flutter/src/interface/screens/forum_nav/forum_user/forum_page.dart';
import 'package:pravasitax_flutter/src/interface/screens/i_hub_nav/hub_page.dart';
import 'package:pravasitax_flutter/src/interface/screens/main_pages/home_page.dart';
import 'package:pravasitax_flutter/src/interface/screens/main_pages/notification.dart';
import 'package:pravasitax_flutter/src/interface/screens/main_pages/profile_page.dart'; // Import ProfilePage
import 'package:pravasitax_flutter/src/data/services/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pravasitax_flutter/src/data/providers/news_provider.dart';
import 'package:pravasitax_flutter/src/data/providers/auth_provider.dart';
import 'package:pravasitax_flutter/src/data/providers/customer_provider.dart';
import 'package:pravasitax_flutter/src/interface/widgets/loading_indicator.dart';

class MainPage extends ConsumerStatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _selectedIndex = 0;
  String? userToken;
  late List<Widget> _widgetOptions = [];
  late final webSocketClient;
  @override
  void initState() {
    super.initState();
    _loadUserToken();
    _checkNewUser();
  }

  Future<void> _loadUserToken() async {
    final token = await SecureStorageService.getAuthToken();
    final userId = await SecureStorageService.getUserId();
    log('userId : $userId');
    log('token : $token');
    webSocketClient = ref.read(socketIoClientProvider);
    webSocketClient.connect(userId, ref);
    setState(() {
      userToken = token;
      _updateWidgetOptions();
    });
  }

  Future<void> _checkNewUser() async {
    final authState = ref.read(authProvider);
    if (authState.isNewUser && authState.token != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNameUpdateDialog();
      });
    }
  }

  void _showNameUpdateDialog() {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          'Welcome!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please enter your name to continue',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFFF9B406)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter your name')),
                  );
                  return;
                }

                try {
                  final authState = ref.read(authProvider);
                  await ref.read(customerProvider.notifier).updateCustomer(
                        userToken: authState.token!,
                        name: nameController.text.trim(),
                      );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update name: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF9B406),
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Continue',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
        contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 24),
        actionsPadding: EdgeInsets.fromLTRB(24, 0, 24, 24),
      ),
    );
  }

  void _updateWidgetOptions() {
    _widgetOptions = <Widget>[
      HomePage(),
      FeedPage(),
      HubPage(),
      if (userToken != null) ForumPage(userToken: userToken!),
      ChatPage(),
    ];
  }

  void _onItemTapped(int index) {
    // Adjust index based on whether feed is visible
    final hasNews = ref.read(hasNewsProvider).value ?? false;
    if (!hasNews && index > 0) {
      index += 1; // Skip the feed index if news is not available
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  int _getAdjustedIndex(int currentIndex) {
    final hasNews = ref.read(hasNewsProvider).value ?? false;
    if (!hasNews && currentIndex > 0) {
      return currentIndex - 1;
    }
    return currentIndex;
  }

  Widget _buildNavBarIcon(String activeIcon, String inactiveIcon, int index) {
    return SvgPicture.asset(
      _selectedIndex == index ? activeIcon : inactiveIcon,
      height: 24,
      width: 24,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasNewsAsync = ref.watch(hasNewsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/pravasi_logo.png',
              height: 40,
              width: 90,
            ),
            SizedBox(width: 8),
          ],
        ),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.notifications_active_outlined),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => NotificationPage()),
          //     );
          //   },
          // ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    insetPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: ProfilePage(),
                      ),
                    ),
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://example.com/profile_pic.png',
                ),
                radius: 20,
              ),
            ),
          ),
        ],
      ),
      body: _widgetOptions.isNotEmpty
          ? _widgetOptions[_getAdjustedIndex(_selectedIndex)]
          : Center(child: LoadingIndicator()),
      bottomNavigationBar: hasNewsAsync.when(
        data: (hasNews) => BottomNavigationBar(
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: _buildNavBarIcon(
                'assets/icons/home_active.svg',
                'assets/icons/home_inactive.svg',
                0,
              ),
              label: 'Home',
            ),
            if (hasNews)
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: _buildNavBarIcon(
                  'assets/icons/feed_active.svg',
                  'assets/icons/feed_inactive.svg',
                  1,
                ),
                label: 'Feed',
              ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: _buildNavBarIcon(
                'assets/icons/ihub_active.svg',
                'assets/icons/ihub_inactive.svg',
                hasNews ? 2 : 1,
              ),
              label: 'I-Hub',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: _buildNavBarIcon(
                'assets/icons/forum_active.svg',
                'assets/icons/forum_inactive.svg',
                hasNews ? 3 : 2,
              ),
              label: 'Forum',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: _buildNavBarIcon(
                'assets/icons/chat_active.svg',
                'assets/icons/chat_inactive.svg',
                hasNews ? 4 : 3,
              ),
              label: 'Chat',
            ),
          ],
          currentIndex: _getAdjustedIndex(_selectedIndex),
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
        loading: () => BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: _buildNavBarIcon(
                'assets/icons/home_active.svg',
                'assets/icons/home_inactive.svg',
                0,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildNavBarIcon(
                'assets/icons/ihub_active.svg',
                'assets/icons/ihub_inactive.svg',
                1,
              ),
              label: 'I-Hub',
            ),
            BottomNavigationBarItem(
              icon: _buildNavBarIcon(
                'assets/icons/forum_active.svg',
                'assets/icons/forum_inactive.svg',
                2,
              ),
              label: 'Forum',
            ),
            BottomNavigationBarItem(
              icon: _buildNavBarIcon(
                'assets/icons/chat_active.svg',
                'assets/icons/chat_inactive.svg',
                3,
              ),
              label: 'Chat',
            ),
          ],
          currentIndex: _getAdjustedIndex(_selectedIndex),
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
        error: (_, __) => BottomNavigationBar(
          // Same as loading state
          items: [
            BottomNavigationBarItem(
              icon: _buildNavBarIcon(
                'assets/icons/home_active.svg',
                'assets/icons/home_inactive.svg',
                0,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildNavBarIcon(
                'assets/icons/ihub_active.svg',
                'assets/icons/ihub_inactive.svg',
                1,
              ),
              label: 'I-Hub',
            ),
            BottomNavigationBarItem(
              icon: _buildNavBarIcon(
                'assets/icons/forum_active.svg',
                'assets/icons/forum_inactive.svg',
                2,
              ),
              label: 'Forum',
            ),
            BottomNavigationBarItem(
              icon: _buildNavBarIcon(
                'assets/icons/chat_active.svg',
                'assets/icons/chat_inactive.svg',
                3,
              ),
              label: 'Chat',
            ),
          ],
          currentIndex: _getAdjustedIndex(_selectedIndex),
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
