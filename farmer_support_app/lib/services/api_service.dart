import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:3000"; // Change this to your API URL

  static Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse("$baseUrl/data"));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load data");
    }
  }
}
