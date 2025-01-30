import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Return to the previous page (MainPage)
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // White background for the AppBar
        foregroundColor: Colors.black, // Black text/icons in the AppBar
            ),
            body: Column(
        children: [
          Divider(
            color: Color.fromRGBO(117, 117, 117, 1),
            thickness: 0.5,
          ),
          Expanded(child: NotificationList()),
        ],
            ),
          );
        }
      }

      class NotificationList extends StatelessWidget {
        final List<String> notifications = [
          "Reminder: Meeting at 5 PM", // Example notification heading
          "New message received", // Additional notification heading
        ]; // Add another notification heading to the list

        @override
        Widget build(BuildContext context) {
          return ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (context, index) => Divider(
        color: Color.fromRGBO(117, 117, 117, 1),
        thickness: 0.5,
            ),
            itemBuilder: (context, index) {
        return NotificationItem(
          heading: notifications[index],
          content:
              "Lorem ipsum dolor sit amet consectetur. Justo facilisis mattis tincidunt vitae quam quis. Nec nisi duis amet aenean arcu tristique et et eleifend.",
          timeAgo: "3 hours ago",
          textColor: Color(0xFF2F80ED),
        );
            },
          );
        }
      }




class NotificationItem extends StatelessWidget {
  final String heading;
  final String content;
  final String timeAgo;
  final Color textColor; // Add the 'textColor' named parameter

  NotificationItem({
    required this.heading,
    required this.content,
    required this.timeAgo,
    required this.textColor,
  }); // Include the 'textColor' named parameter in the constructor

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notification Heading in bold
          Text(
            heading,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold, // Bold heading
              color: Colors.black, // Black color for heading
            ),
          ),
          SizedBox(height: 8), // Add some space between heading and content

          // Notification Content in light text
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal, // Lighter content text
              color: Colors.grey[600], // Lighter color for content
            ),
          ),
          SizedBox(height: 8), // Add space before the time ago text

          // Time ago text aligned to the bottom-right
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              timeAgo,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF2F80ED), // Blue color for 'time ago'
              ),
            ),
          ),
        ],
      ),
    );
  }
}
