import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.15.26:3000"; // Change this to your API URL

  static Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse("$baseUrl/data"));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load data");
    }
  }
  static Future<http.Response> registerUser({
    required String username,
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/user/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "phone": phone,
        "password": password,
      }),
    );
    return response;
  }

  static Future<http.Response> loginUser({
    required String username,
    required String password,
  }) async {
    var url = Uri.parse('$baseUrl/api/v1/user/login');
    var body = jsonEncode({
      'username': username,
      'password': password,
    });

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    return response;
  }
}
