import 'package:flutter/material.dart';

class MyPostsPage extends StatelessWidget {
  const MyPostsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('My posts'),
      ),
      body: ListView(
        children: [
          _buildPostItem(
            username: 'Fungsuk Wangdu',
            timeAgo: 'Just now',
            content: 'Lorem ipsum dolor sit amet, consectetur. Est scelerisque nunc mauris libero. Sit risus non quam posuere nulla. Tellus nulla nunc lorem consequat dictumst feugiat. Volutpate mattis faucibus dictumst at.',
            commentsCount: 2,
          ),
          SizedBox(height: 16),
          _buildPostItem(
            username: 'Fungsuk Wangdu',
            timeAgo: '3 days ago',
            content: 'Lorem ipsum dolor sit amet, consectetur. Est scelerisque nunc mauris libero. Sit risus non quam posuere nulla. Tellus nulla nunc lorem consequat dictumst feugiat. Volutpate mattis faucibus dictumst at.',
            commentsCount: 0,
          ),
          SizedBox(height: 16),
          _buildPostItem(
            username: 'Fungsuk Wangdu',
            timeAgo: '1 week ago',
            content: 'Lorem ipsum dolor sit amet, consectetur. Est scelerisque nunc mauris libero. Sit risus non quam posuere nulla. Tellus nulla nunc lorem consequat dictumst feugiat.',
            commentsCount: 5,
          ),
        ],
      ),
    );
  }

  Widget _buildPostItem({
    required String username,
    required String timeAgo,
    required String content,
    required int commentsCount,
  }) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: 20,
            ),
            title: Row(
              children: [
                Text(
                  username,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Spacer(),
                Text(
                  'Just Now',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            subtitle: Text(timeAgo, style: TextStyle(color: Colors.grey[600])),
          ),
          Container(
            height: 200,
            color: Colors.grey[300],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(content),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
            child: Text(
              '$commentsCount comments',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}