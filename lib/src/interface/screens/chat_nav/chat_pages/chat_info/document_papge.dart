import 'package:flutter/material.dart';

class ChatDocumentsPage extends StatelessWidget {
  final String conversationId;

  const ChatDocumentsPage({
    Key? key,
    required this.conversationId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ListView.builder(
        itemCount: 5, 
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                    width: .5, color: const Color.fromARGB(255, 227, 224, 224)),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red,
                ),
                title: Text('Document ${index + 1}'),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    // Handle download action
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
