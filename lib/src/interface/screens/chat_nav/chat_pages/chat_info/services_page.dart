import 'package:flutter/material.dart';

class ServiceDetailsPage extends StatelessWidget {
  final String conversationId;

  const ServiceDetailsPage({
    Key? key,
    required this.conversationId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Service Details Content',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
