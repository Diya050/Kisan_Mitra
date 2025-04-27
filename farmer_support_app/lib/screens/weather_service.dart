import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String _openCageApiKey = dotenv.env['OPENCAGE_API_KEY'] ?? '';

  // Step 1: Get latitude and longitude from user location
  Future<Map<String, dynamic>?> getCoordinates(String locationName) async {
    final url = Uri.parse('https://api.opencagedata.com/geocode/v1/json?q=$locationName&key=$_openCageApiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'].isNotEmpty) {
        final geometry = data['results'][0]['geometry'];
        return {
          'latitude': geometry['lat'],
          'longitude': geometry['lng'],
        };
      }
    }
    return null;
  }

  // Step 2: Get weather from Open-Meteo
  Future<Map<String, dynamic>?> getWeather(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['current_weather'];
    }
    return null;
  }
}
