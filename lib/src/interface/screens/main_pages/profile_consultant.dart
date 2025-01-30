import 'package:flutter/material.dart';

class ProfileConsultantPage extends StatefulWidget {
  @override
  _ProfileConsultantPageState createState() => _ProfileConsultantPageState();
}

class _ProfileConsultantPageState extends State<ProfileConsultantPage> {
  String _selectedSection = 'DOCUMENTS';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildContactInfo(),
            _buildSectionToggle(),
            Expanded(child: _buildSectionContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Handle back navigation
            },
          ),
          SizedBox(width: 16),
          Text(
            'Profile',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            'Aéline Wolf',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('Event Manager', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 16),
          _buildInfoBox(Icons.phone, '9845622333'),
          SizedBox(height: 8),
          _buildInfoBox(Icons.email, 'aelinewolf2339@gmail.com'),
        ],
      ),
    );
  }

  Widget _buildInfoBox(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          SizedBox(width: 16),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildSectionToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['DOCUMENTS', 'MESSAGES', 'FILINGS'].map((section) {
        return InkWell(
          onTap: () => setState(() => _selectedSection = section),
          child: Column(
            children: [
              Text(
                section,
                style: TextStyle(
                  fontWeight: _selectedSection == section
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color:
                      _selectedSection == section ? Colors.blue : Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Container(
                height: 2,
                width: 40,
                color: _selectedSection == section ? Colors.blue : Colors.transparent,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionContent() {
    switch (_selectedSection) {
      case 'DOCUMENTS':
        return _buildDocumentsSection();
      case 'MESSAGES':
        return _buildMessagesSection();
      case 'FILINGS':
        return _buildFilingsSection();
      default:
        return Container();
    }
  }

  Widget _buildDocumentsSection() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.picture_as_pdf, color: Colors.red),
          title: Text('Volutpat sed tortoris'),
          trailing: Icon(Icons.download),
        );
      },
    );
  }

  Widget _buildMessagesSection() {
    return ListView(
      children: [
        _buildMessageTile('Our professional will be getting in touch with you soon', '11:45'),
        _buildMessageTile('Our professional will be getting in touch with you soon', '11:45'),
        _buildMessageTile('Lorem ipsum dolor sit amet consectetur. Vel tortor faucibus massa sem ut rhoncus.', '11:43'),
      ],
    );
  }

  Widget _buildMessageTile(String message, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message),
          SizedBox(height: 4),
          Text(time, style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFilingsSection() {
    return ListView(
      children: [
        _buildFilingTile('Income Tax Filing', 'Thursday, May 25th at 2:10 PM', 'ongoing'),
        _buildFilingTile('Income Tax Filing', 'Thursday, May 25th at 2:10 PM', 'completed'),
      ],
    );
  }

  Widget _buildFilingTile(String title, String date, String status) {
    return ListTile(
      leading: Icon(Icons.description),
      title: Text(title),
      subtitle: Text(date),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: status == 'ongoing' ? Colors.orange : Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          status,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}