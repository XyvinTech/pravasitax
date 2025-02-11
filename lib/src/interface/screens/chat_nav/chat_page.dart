import 'package:flutter/material.dart';
import 'package:pravasitax_flutter/src/interface/screens/chat_nav/chat_pages/enquires_tab.dart';
import 'package:pravasitax_flutter/src/interface/screens/chat_nav/chat_pages/services_tab.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  static const Color primaryColor = Color(0xFFF8B50C);
  static const Color secondaryColor = Color(0xFF05104F);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                indicatorSize: TabBarIndicatorSize.tab,
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
                        Icon(Icons.question_answer_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('ENQUIRIES'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.miscellaneous_services_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('SERVICES'),
                      ],
                    ),
                  ),
                ],
              ),
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
