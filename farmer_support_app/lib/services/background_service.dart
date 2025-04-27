import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';
import 'package:flutter/material.dart';

class BackgroundService {
  @pragma('vm:entry-point')
  static Future<void> checkWeatherAndNotify() async {
    // Ensure initialization in the background isolate
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload(); // Sync preferences

    // Retrieve saved weather cards from SharedPreferences
    // background_service.dart
    final savedCards = prefs.getStringList('savedWeatherDataList') ?? [];

    // Keywords to trigger notifications
    const targetKeywords = ['clear sky', 'rain', 'storm'];

    // Iterate over the saved cards and check for target weather conditions
    for (int i = 0; i < savedCards.length; i++) {
      final data = jsonDecode(savedCards[i]) as Map<String, dynamic>;
      final description = (data['description']?.toString() ?? '').toLowerCase();

      // Check if description contains any of the target keywords
      if (targetKeywords.any((kw) => description.contains(kw))) {
        // Send a notification if condition matches
        NotificationService.showImmediateNotification(
          id: i,
          title: 'Weather Alert: $description',
          body: 'A saved forecast matches: $description',
        );
      }
    }
  }
}
