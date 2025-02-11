import 'package:flutter/material.dart';
import 'package:pravasitax_flutter/src/interface/screens/chat_nav/chat_pages/enquires_tab.dart';
import 'package:pravasitax_flutter/src/interface/screens/chat_nav/chat_pages/services_tab.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48), // Adjusts TabBar height
          child: Container(
            color: Colors.white,
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Color(0xFFF9B406).withOpacity(.53),
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
              tabs: const [
                Tab(text: 'ENQUIRIES'),
                Tab(text: 'SERVICES'),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            EnquiriesTab(),
            ServicesTab(),
          ],
        ),
      ),
    );
  }
}
