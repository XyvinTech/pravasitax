import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsScreenState createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsPage> {
  bool goldPricesUpdates = true;
  bool activityUpdates = false;
  bool landPricesUpdates = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: Text('Notification settings'),
      ),
      body: Container(
        color: Color.fromARGB(255, 248, 248, 248), // Light gray background
        child: Column(
          children: [
            Container(
              color: Colors.grey,
              height: 0.5, // Grey line below app bar
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildNotificationTile(
                    'Show updates on Gold prices',
                    'Lorem ipsum dolor sit amet consectetur. Lorem non tortor diam lorem viverra at nisi purus.',
                    goldPricesUpdates,
                    (value) => setState(() => goldPricesUpdates = value),
                  ),
                  _buildDivider(),
                  _buildNotificationTile(
                    'Show updates on Activity',
                    'Lorem ipsum dolor sit amet consectetur. Lorem non tortor diam lorem viverra at nisi purus.',
                    activityUpdates,
                    (value) => setState(() => activityUpdates = value),
                  ),
                  _buildDivider(),
                  _buildNotificationTile(
                    'Show updates on Land Prices',
                    'Lorem ipsum dolor sit amet consectetur. Lorem non tortor diam lorem viverra at nisi purus.',
                    landPricesUpdates,
                    (value) => setState(() => landPricesUpdates = value),
                  ),
                  SizedBox(height: 25),
                  _buildResetButton(),
                  SizedBox(height: 550),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Rate us on Playstore',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color.fromARGB(255, 130, 130, 130)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        color: Colors.white, // White background
        height: 100.0, // Increased height
        child: _buildSwitchTile(
          title,
          subtitle,
          value,
          onChanged,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 17, color: Colors.grey),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Color(0xFF6750A4),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      color: const Color.fromARGB(255, 190, 190, 190),
      height: 0.5,
      margin: EdgeInsets.symmetric(horizontal: 16.0),
    );
  }

  Widget _buildResetButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(Icons.restore_from_trash, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'Reset all to default',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
