// services/news_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsService {
  static Future<List<Article>> fetchNews() async {
    final response = await http.get(Uri.parse('http://192.168.15.26:3000/news'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
