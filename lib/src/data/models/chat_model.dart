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
  final String lastMessage;

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
    return Conversation(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      staffs: (json['staffs'] as List?)
              ?.map((staff) => Staff.fromJson(staff))
              .toList() ??
          [],
      customer: json['customer'] ?? '',
      createdAt: json['created_at'] ?? '',
      status: json['status'] ?? 0,
      statusText: json['status_text'] ?? '',
      unreadMessages: json['unread_messages'] ?? 0,
      totalMessages: json['total_messages'] ?? 0,
      lastMessage: json['last_message'] ?? '',
    );
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
      type: json['type'] ?? 
     json['sender_type'] ?? '',
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
