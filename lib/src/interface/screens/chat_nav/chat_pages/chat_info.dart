import 'package:flutter/material.dart';
import 'package:pravasitax_flutter/src/interface/screens/chat_nav/chat_pages/chat_info/document_papge.dart';
import 'package:pravasitax_flutter/src/interface/screens/chat_nav/chat_pages/chat_info/services_page.dart';

class ChatInfo extends StatelessWidget {
  final String conversationId;
  final String title;
  final String imageUrl;

  const ChatInfo({
    Key? key,
    required this.conversationId,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.phone, color: Colors.black),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: const Color(0xFFF9B406).withOpacity(.53),
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
              Tab(text: 'Service Details'),
              Tab(text: 'Documents'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ServiceDetailsPage(conversationId: conversationId),
            ChatDocumentsPage(conversationId: conversationId),
          ],
        ),
      ),
    );
  }
}
