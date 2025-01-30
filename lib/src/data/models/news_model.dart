class News {
  final String id;
  final String title;
  final String content;
  final NewsMedia media;
  final String createdAt;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.media,
    required this.createdAt,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      media: NewsMedia.fromJson(json['media'] ?? {}),
      createdAt: json['created_at'] ?? '',
    );
  }
}

class NewsMedia {
  final String type;
  final String url;

  NewsMedia({
    required this.type,
    required this.url,
  });

  factory NewsMedia.fromJson(Map<String, dynamic> json) {
    return NewsMedia(
      type: json['type'] ?? 'image',
      url: json['url'] ?? '',
    );
  }
}
