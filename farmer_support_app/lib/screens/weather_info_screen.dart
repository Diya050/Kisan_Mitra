import 'package:flutter/material.dart';

class WeatherInfoScreen extends StatelessWidget {
  WeatherInfoScreen({super.key});
  final Map<String, dynamic> currentWeather = {
    "location": "Ludhiana (West), LUDHIANA, PU...",
    "date": "Today, 23 March",
    "temperature": "31°",
    "condition": "Sunny",
    "highLow": "32°/16°",
    "wind": "10 kmph",
    "humidity": "25%",
    "rainChance": "2%",
  };

  final List<Map<String, String>> hourlyForecast = [
    {"time": "2 PM", "temp": "31°", "icon": "☀️"},
    {"time": "3 PM", "temp": "32°", "icon": "☀️"},
    {"time": "4 PM", "temp": "32°", "icon": "☀️"},
    {"time": "5 PM", "temp": "31°", "icon": "🌅"},
  ];

  final List<Map<String, String>> weeklyForecast = [
    {"day": "Tomorrow", "date": "24/03", "rain": "2%", "highLow": "34°/17°"},
    {"day": "Tuesday", "date": "25/03", "rain": "1%", "highLow": "35°/20°"},
    {"day": "Wednesday", "date": "26/03", "rain": "No Rain", "highLow": "36°/20°"},
    {"day": "Thursday", "date": "27/03", "rain": "No Rain", "highLow": "35°/16°"},
    {"day": "Friday", "date": "28/03", "rain": "No Rain", "highLow": "31°/14°"},
    {"day": "Saturday", "date": "29/03", "rain": "No Rain", "highLow": "31°/14°"},
    {"day": "Sunday", "date": "30/03", "rain": "No Rain", "highLow": "33°/15°"},
    {"day": "Monday", "date": "31/03", "rain": "No Rain", "highLow": "35°/16°"},
    {"day": "Tuesday", "date": "01/04", "rain": "No Rain", "highLow": "35°/17°"},
    {"day": "Wednesday", "date": "02/04", "rain": "No Rain", "highLow": "36°/18°"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather"),
        actions: [IconButton(icon: Icon(Icons.share), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location & Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      currentWeather["location"],
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Icon(Icons.edit, size: 18, color: Colors.green),
                ],
              ),
              SizedBox(height: 8),
              Text(
                currentWeather["date"],
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              SizedBox(height: 16),

              // Current Weather
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentWeather["temperature"],
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentWeather["condition"],
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        currentWeather["highLow"],
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Weather details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _weatherInfoBox(Icons.cloud, "Rain", currentWeather["rainChance"]),
                  _weatherInfoBox(Icons.air, "Wind", currentWeather["wind"]),
                  _weatherInfoBox(Icons.water_drop, "Humidity", currentWeather["humidity"]),
                ],
              ),

              SizedBox(height: 16),

              // Hourly Forecast
              Text("Time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: hourlyForecast.map((hour) {
                  return Column(
                    children: [
                      Text(hour["time"] ?? "", style: TextStyle(fontSize: 14, color: Colors.grey)),
                      Text(hour["icon"] ?? "", style: TextStyle(fontSize: 20)),
                      Text(hour["temp"] ?? "", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  );
                }).toList(),
              ),

              SizedBox(height: 16),

              // Rain Alert
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "2% chance of rain in the next 24 hours",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Weekly Forecast
              Text("Day", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Column(
                children: weeklyForecast.map((day) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${day["day"]} ${day["date"]}", style: TextStyle(fontSize: 14)),
                        Text(day["rain"] ?? "", style: TextStyle(fontSize: 14, color: Colors.grey)),
                        Text(day["highLow"] ?? "", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for weather details (Rain, Wind, Humidity)
  Widget _weatherInfoBox(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 28),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
