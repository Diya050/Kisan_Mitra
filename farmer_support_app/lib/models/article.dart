// models/article.dart
class Article {
  final String? title;
  final String? description;
  final String? link;
  final String? imageUrl;
  final String? pubDate;

  Article({this.title, this.description, this.link, this.imageUrl, this.pubDate});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      description: json['description'],
      link: json['link'],
      imageUrl: json['image_url'],
      pubDate: json['pubDate'],
    );
  }
}
