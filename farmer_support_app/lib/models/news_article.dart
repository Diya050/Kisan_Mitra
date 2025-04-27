class NewsArticle {
  final String title;
  final String description;
  final String link;
  final String imageUrl;
  final String pubDate;

  NewsArticle({
    required this.title,
    required this.description,
    required this.link,
    required this.imageUrl,
    required this.pubDate,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      link: json['link'] ?? '',
      imageUrl: json['image_url'] ?? '',
      pubDate: json['pubDate'] ?? '',
    );
  }
}
