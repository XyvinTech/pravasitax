import 'package:flutter/material.dart';

class CommunityScreenPage extends StatefulWidget {
  @override
  _CommunityScreenPageState createState() => _CommunityScreenPageState();
}

class _CommunityScreenPageState extends State<CommunityScreenPage> {
  bool _showGroup = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PravasiTax', style: TextStyle(color: Colors.orange)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, color: Colors.grey[600]),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          _buildToggleBar(),
          Expanded(
            child: _showGroup ? _buildGroupView() : _buildChatView(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildToggleBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton('GROUP', _showGroup),
          ),
          Expanded(
            child: _buildToggleButton('CHAT', !_showGroup),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _showGroup = text == 'GROUP';
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildGroupView() {
    return ListView(
      children: [
        _buildGroupSection('Communities by Pravasi', [
          _buildGroupItem('Communities by Pravasi', null),
          _buildGroupItem('Group 1', '20 members'),
          _buildGroupItem('Group 2', '11 members'),
          _buildGroupItem('Group 3', '20 members'),
          _buildAddButton('Add Group'),
        ]),
        _buildGroupSection('Announcements by Pravasi', [
          _buildAnnouncementItem('Announcement 1'),
          _buildAnnouncementItem('Announcement 2'),
          _buildAddButton('Add Announcements'),
        ]),
      ],
    );
  }

  Widget _buildGroupSection(String title, List<Widget> items) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildGroupItem(String name, String? members) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        child: Icon(Icons.group, color: Colors.grey[600]),
      ),
      title: Text(name),
      trailing: members != null ? Text(members) : null,
    );
  }

  Widget _buildAnnouncementItem(String title) {
    return ListTile(
      leading: Icon(Icons.announcement, color: Colors.orange),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 12,
          ),
          SizedBox(width: 4),
          CircleAvatar(
            backgroundColor: Colors.green,
            radius: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(String text) {
    return ListTile(
      leading: Icon(Icons.add, color: Colors.blue),
      title: Text(text, style: TextStyle(color: Colors.blue)),
    );
  }

  Widget _buildChatView() {
    return ListView(
      children: [
        _buildChatItem('Consultant x', 'Hii, How are you'),
        _buildChatItem('Consultant y', 'Hii, How are you'),
        _buildChatItem('User 1', 'Hii, How are you'),
        _buildChatItem('Céline Wolf', 'Hii, How are you'),
      ],
    );
  }

  Widget _buildChatItem(String name, String message) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        child: Icon(Icons.person, color: Colors.grey[600]),
      ),
      title: Text(name),
      subtitle: Text(message),
      trailing: CircleAvatar(
        backgroundColor: Colors.red,
        radius: 10,
        child: Text('2', style: TextStyle(color: Colors.white, fontSize: 12)),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 4,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feed'),
        BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Checklists'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Community'),
      ],
    );
  }
}