import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pravasitax_flutter/mainpage.dart';
import 'package:pravasitax_flutter/src/data/providers/chat_provider.dart';
import 'package:pravasitax_flutter/src/interface/screens/chat_nav/chat_page.dart';
import 'package:pravasitax_flutter/src/interface/screens/feed_nav/feed_page.dart';
import 'package:pravasitax_flutter/src/interface/screens/forum_nav/forum_consultant/forum_page.dart';
import 'package:pravasitax_flutter/src/interface/screens/forum_nav/forum_user/forum_list.dart';
import 'package:pravasitax_flutter/src/interface/screens/forum_nav/forum_user/forum_page.dart';
import 'package:pravasitax_flutter/src/interface/screens/i_hub_nav/hub_page.dart';
import 'package:pravasitax_flutter/src/interface/screens/main_pages/home_page.dart';
import 'package:pravasitax_flutter/src/interface/screens/main_pages/notification.dart';
import 'package:pravasitax_flutter/src/interface/screens/main_pages/profile_page.dart'; // Import ProfilePage
import 'package:pravasitax_flutter/src/data/services/secure_storage_service.dart';
import 'package:pravasitax_flutter/src/interface/widgets/loading_indicator.dart';

class MainPageConsultantPage extends ConsumerStatefulWidget {
  @override
  _MainPageConsultantState createState() => _MainPageConsultantState();
}

class _MainPageConsultantState extends ConsumerState<MainPageConsultantPage> {
  int _selectedIndex = 0;
  String? userToken;
  late final webSocketClient;
  List<Widget> _widgetOptions = [
    HomePage(), // Home Page
    FeedPage(), // Feed Page
    HubPage(), // I-Hub Page
    Container(), // Placeholder for Forum Page
    ChatPage(), // Chat Page
  ];

  @override
  void initState() {
    super.initState();
    _loadUserToken();
  }

  Future<void> _loadUserToken() async {
    final token = await SecureStorageService.getAuthToken();
    final userId = await SecureStorageService.getUserId();
    webSocketClient = ref.read(socketIoClientProvider);
    webSocketClient.connect(userId, ref);
    setState(() {
      userToken = token;
      // Update Forum page with actual token
      if (userToken != null) {
        _widgetOptions[3] = ForumPageConsultant(userToken: userToken!);
      }
    });
  }

  // Method to update the selected index when an item is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Helper method to dynamically build the navigation icons
  Widget _buildNavBarIcon(String activeIcon, String inactiveIcon, int index) {
    return SvgPicture.asset(
      _selectedIndex == index ? activeIcon : inactiveIcon,
      height: 24,
      width: 24,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/pravasi_logo.png', // Pravasi Tax logo
              height: 40, // Adjusted size
              width: 90,
            ),
            SizedBox(width: 8),
          ],
        ),
        actions: [
          // IconButton(
          //   icon:
          //       Icon(Icons.notifications_active_outlined), // Notification icon
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
                backgroundColor: Colors.grey[200],
                child: Icon(
                  Icons.person_outline_rounded,
                  color: Colors.grey[600],
                ),
                radius: 20,
              ),
            ),
          ),
        ],
      ),
      body: _widgetOptions.isNotEmpty
          ? _widgetOptions[_selectedIndex]
          : Center(child: LoadingIndicator()),
      bottomNavigationBar: BottomNavigationBar(
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
              'assets/icons/feed_active.svg',
              'assets/icons/feed_inactive.svg',
              1,
            ),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: _buildNavBarIcon(
              'assets/icons/chklist_active.svg',
              'assets/icons/chklist_inactive.svg',
              2,
            ),
            label: 'I-Hub',
          ),
          BottomNavigationBarItem(
            icon: _buildNavBarIcon(
              'assets/icons/chat_active_consultant.svg',
              'assets/icons/chat_inactive_consultant.svg',
              3,
            ),
            label: 'Forum',
          ),
          BottomNavigationBarItem(
            icon: _buildNavBarIcon(
              'assets/icons/people_active.svg',
              'assets/icons/people_inactive.svg',
              4,
            ),
            label: 'Chat',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
