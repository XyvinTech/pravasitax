class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String time;
  final String type;
  final double price;
  final int availableSeats;
  final List<Speaker> speakers;
  final String? venue;
  final String? thumbnail;
  final String _status;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.type,
    required this.price,
    required this.availableSeats,
    required this.speakers,
    this.venue,
    this.thumbnail,
    required String status,
  }) : _status = status;

  // Computed property to determine actual status based on date
  String get status {
    final now = DateTime.now();
    final eventDate = DateTime(date.year, date.month, date.day);
    final today = DateTime(now.year, now.month, now.day);

    if (eventDate.isBefore(today)) {
      return 'PAST';
    } else if (eventDate.isAtSameMomentAs(today)) {
      return 'LIVE';
    } else {
      return 'UPCOMING';
    }
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    // Parse price from various formats
    double parsePrice(dynamic price) {
      if (price == null || price == 'Free Session' || price == 'Free') {
        return 0.0;
      }
      if (price is num) {
        return price.toDouble();
      }
      if (price is String) {
        // Remove currency symbols and try to parse
        final cleanPrice = price.replaceAll(RegExp(r'[^\d.]'), '');
        if (cleanPrice.isEmpty) return 0.0;
        return double.tryParse(cleanPrice) ?? 0.0;
      }
      return 0.0;
    }

    return Event(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? json['short_description'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      time: json['time'] ?? '',
      type: json['type']?.toString().toLowerCase() ?? 'online',
      price: parsePrice(json['price']),
      availableSeats: json['available_seats'] ?? 1,
      speakers: (json['speakers'] as List?)
              ?.map((speaker) => Speaker.fromJson(speaker))
              .toList() ??
          [],
      venue: json['venue'] ?? json['location'],
      thumbnail: json['thumbnail'] ?? json['banner'],
      status: json['status'] ?? 'UPCOMING',
    );
  }
}

class Speaker {
  final String name;
  final String role;
  final String? image;
  final String? linkedinUrl;

  Speaker({
    required this.name,
    required this.role,
    this.image,
    this.linkedinUrl,
  });

  factory Speaker.fromJson(Map<String, dynamic> json) {
    return Speaker(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      image: json['image'],
      linkedinUrl: json['linkedin_url'],
    );
  }
}
