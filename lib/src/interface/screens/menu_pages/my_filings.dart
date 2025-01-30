import 'package:flutter/material.dart';

class MyFilingsPage extends StatefulWidget {
  @override
  _MyFilingsPageState createState() => _MyFilingsPageState();
}

class _MyFilingsPageState extends State<MyFilingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Listener to rebuild when tab changes
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My filings', style: TextStyle(color: Colors.black)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab bar for Ongoing/Previous
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2), // Grey background for the tab bar
                borderRadius: BorderRadius.circular(15), // Fully rounded
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2), // Shadow position
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Sliding button effect
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    left: _tabController.index == 0 ? 0 : MediaQuery.of(context).size.width * 0.44,
                    right: _tabController.index == 1 ? 0 : MediaQuery.of(context).size.width * 0.44,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.44, // Half of the width
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Tab bar text
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicator: const BoxDecoration(
                      color: Colors.transparent, // No default indicator
                    ),
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
                    tabs: const [
                      Tab(text: "Ongoing"),
                      Tab(text: "Previous"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Ongoing Filings Tab
                ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildFilingItem(
                      title: "Income Tax Filing",
                      date: "Thursday, May 25th at 2:30 PM",
                      statusText: "Computing",
                      statusColor: Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    _buildFilingItem(
                      title: "Income Tax Filing",
                      date: "Thursday, May 25th at 2:30 PM",
                        statusText: "Checklist received",
                        statusColor: Colors.green,
                    ),
                  ],
                ),
                // Previous Filings Tab (Empty for now)
                const Center(child: Text("No previous filings", style: TextStyle(color: Colors.grey))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build each filing item
  Widget _buildFilingItem({
    required String title,
    required String date,
    required String statusText,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9D9D9)),
      ),
      child: Row(
        children: [
          // File Icon
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.folder_open, size: 28, color: Colors.black),
          ),
          const SizedBox(width: 12),

          // Filing Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8), // Space between date and status

                // Status below the date
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // Next Arrow
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
