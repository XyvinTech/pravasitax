import 'package:flutter/material.dart';
import 'package:pravasitax_flutter/mainPage_consultant.dart';
import 'package:pravasitax_flutter/src/interface/screens/main_pages/home_consultant.dart'; // Import the target page
import 'package:pravasitax_flutter/src/interface/screens/login_pages/login_front.dart'; // Import the login page
import 'package:pravasitax_flutter/src/interface/screens/forum_nav/forum_consultant/forum_page.dart'; // Import the forum consultant page
import 'package:pravasitax_flutter/src/interface/screens/main_pages/profile_consultant.dart'; // Import the profile consultant page
import 'package:pravasitax_flutter/src/interface/screens/community_consultant/community_screen.dart'; // Import the community screen

class DebugPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DEBUG SESSION',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: List.generate(7, (index) {
                  return _buildGridTile(context, index);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridTile(BuildContext context, int index) {
    // Define colors for the tiles
    List<Color> tileColors = [
      Colors.orange.shade100,
      Colors.green.shade100,
      Colors.blue.shade100,
      Colors.lightGreen.shade100,
      Colors.blue.shade50,
      Colors.purple.shade100,
      Colors.grey.shade300,
    ];

    // Define icons for the tiles
    List<IconData> tileIcons = [
      Icons.coffee, // Replace with the actual icons you're using
      Icons.wallet_travel, // Replace with the actual icons you're using
      Icons.receipt, // Replace with the actual icons you're using
      Icons.search, // Replace with the actual icons you're using
      Icons.dashboard, // Replace with the actual icons you're using
      Icons.person, // Replace with the actual icons you're using
      Icons.call, // Replace with the actual icons you're using
    ];

    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeConsultantPage()),
          );
        } else if (index == 1) {
          // Assuming the wallet icon is at index 1
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CommunityScreenPage()),
          );
        } else if (index == 4) {
          // Assuming the dashboard icon is at index 4
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileConsultantPage()),
          );
        } else if (index == 5) {
          // Assuming the person icon is at index 5
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginFrontPage()),
          );
        } else if (index == 6) {
          // Assuming the call icon is at index 6
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainPageConsultantPage()),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: tileColors[index],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Icon(
            tileIcons[index],
            size: 40,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
