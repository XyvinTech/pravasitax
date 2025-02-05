import 'dart:developer' as developer;

class Staff {
  final String name;
  final String id;

  final String avatar;

  Staff({
    required this.name,
    required this.id,
    required this.avatar,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }
}

class LastMessage {
  final String? message;
  final String? createdAt;
  final String? sender;

  LastMessage({this.message, this.createdAt, this.sender});

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      message: json['message'] as String?,
      createdAt: json['created_at'] as String?,
      sender: json['sender'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'created_at': createdAt,
      'sender': sender,
    };
  }
}

class Conversation {
  final String id;
  final String title;
  final String type;
  final List<Staff> staffs;
  final String customer;
  final String createdAt;
  final int status;
  final String statusText;
  final int unreadMessages;
  final int totalMessages;
  final LastMessage? lastMessage;

  Conversation({
    required this.id,
    required this.title,
    required this.type,
    required this.staffs,
    required this.customer,
    required this.createdAt,
    required this.status,
    required this.statusText,
    required this.unreadMessages,
    required this.totalMessages,
    required this.lastMessage,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    try {
      // Validate required fields
      if (json['_id'] == null) throw Exception('Conversation ID is required');
      if (json['title'] == null)
        throw Exception('Conversation title is required');
      if (json['type'] == null)
        throw Exception('Conversation type is required');

      // Parse staff array with validation
      List<Staff> staffList = [];
      if (json['staffs'] != null) {
        if (json['staffs'] is! List) {
          throw Exception('Invalid staffs format: expected array');
        }
        staffList = (json['staffs'] as List).map((staff) {
          if (staff is! Map<String, dynamic>) {
            throw Exception('Invalid staff format: expected object');
          }
          return Staff.fromJson(staff);
        }).toList();
      }

      return Conversation(
        id: json['_id'].toString(),
        title: json['title'].toString(),
        type: json['type'].toString(),
        staffs: staffList,
        customer: json['customer']?.toString() ?? '',
        createdAt: json['created_at']?.toString() ?? '',
        status: json['status'] is int ? json['status'] : 0,
        statusText: json['status_text']?.toString() ?? '',
        unreadMessages:
            json['unread_messages'] is int ? json['unread_messages'] : 0,
        totalMessages:
            json['total_messages'] is int ? json['total_messages'] : 0,
        lastMessage: json['last_message'] != null && json['last_message'] is Map
            ? LastMessage.fromJson(json['last_message'])
            : null,
      );
    } catch (e, stack) {
      developer.log(
        'Error parsing conversation',
        error: e,
        stackTrace: stack,
        name: 'ConversationModel',
      );
      rethrow;
    }
  }

  // Add debug method
  Map<String, dynamic> toDebugMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'staffCount': staffs.length,
      'customer': customer,
      'createdAt': createdAt,
      'status': status,
      'statusText': statusText,
      'unreadMessages': unreadMessages,
      'totalMessages': totalMessages,
      'hasLastMessage': lastMessage != null,
    };
  }
}

class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final String type;
  final DateTime createdAt;
  final bool isDelivered;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.isDelivered,
    required this.isRead,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    DateTime parseCustomDate(String dateStr) {
      try {
        // First try parsing as ISO format
        return DateTime.parse(dateStr);
      } catch (e) {
        // If that fails, parse custom format "dd MMM yy, HH:mm"
        final parts = dateStr.split(', ');
        final dateParts = parts[0].split(' ');
        final timeParts = parts[1].split(':');

        final day = int.parse(dateParts[0]);
        final month = _getMonthNumber(dateParts[1]);
        final year = 2000 + int.parse(dateParts[2]); // Convert '24' to '2024'
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);

        return DateTime(year, month, day, hour, minute);
      }
    }

    return MessageModel(
      id: json['_id'] ?? '',
      conversationId: json['conversation_id'] ?? '',
      senderId: json['sender'] ?? '',
      content: json['message'] ?? json['content'] ?? '',
      type: json['type'] ?? json['sender_type'] ?? '',
      createdAt: parseCustomDate(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      isDelivered: (json['delivered'] as List?)?.isNotEmpty ?? false,
      isRead: (json['read'] as List?)?.isNotEmpty ?? false,
    );
  }

  static int _getMonthNumber(String month) {
    const months = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12
    };
    return months[month] ?? 1;
  }
}
