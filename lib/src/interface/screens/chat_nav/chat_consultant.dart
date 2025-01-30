import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Divider(
            color: Color.fromARGB(255, 17, 16, 16),
            thickness: 0.2,
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Color.fromARGB(255, 17, 16, 16),
                thickness: 0.2,
              ),
              itemCount: 3, // Replace with the actual number of chats
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatScreen()),
                    );
                  },
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/profile_picture.png'),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sender Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Last message',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(8),
                          child: Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFCD29),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  NetworkImage('https://example.com/profile_image.png'),
              radius: 20,
            ),
            SizedBox(width: 10),
            Text(
              'B.S Joshi',
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: const Color.fromARGB(255, 0, 0, 0)),
            onPressed: () {
              // Handle call button press
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Yesterday',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Sender Message
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFDE79F),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Hi',
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '3:00 PM',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Receiver Message
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi',
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '3:10 PM',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Sender Message with post link (styled like the image)
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7, // Limit to 70% of the screen width
                    decoration: BoxDecoration(
                      color: Color(0xFFFDE79F),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'My comment',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Handle view post action
                              },
                              child: Text(
                                'view post',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF040F4F),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(thickness: 1, color: Colors.black12),
                        SizedBox(height: 4),
                        Text(
                          'Yes, I totally agree with this post we as NRIs are really concerned about our taxes in future year...!!!',
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: 8),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            '3:00',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Input field
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, -2),
                  blurRadius: 4,
                ),
              ],
              borderRadius: BorderRadius.zero, // Set to zero for sharp corners
            ),
            child: Row(
              children: [
                // Rectangular box for TextField and Pin Icon
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFA9A9A9)), // Black border outline
                      borderRadius: BorderRadius.circular(4), // Slightly rounded edges
                    ),
                    child: Row(
                      children: [
                        // Expanded TextField inside the box
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextField(
                              style: TextStyle(
                              color: Color(0xFFB4B4B4),
                              ),
                              decoration: InputDecoration(
                              hintText: 'Type your message here',
                              border: InputBorder.none,
                              ),
                            ),
                            ),
                          ),
            
                        // Attach file icon inside the box
                        IconButton(
                          icon: Icon(Icons.attach_file, color: Color(0xFFB4B4B4)),
                          onPressed: () {
                            // Handle attach action
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 5), // Gap between input box and send button

                // Send button with yellow background
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFDBA2F), // Yellow background for send button
                    borderRadius: BorderRadius.circular(4), // Matching rounded edges
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      // Handle send action
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
