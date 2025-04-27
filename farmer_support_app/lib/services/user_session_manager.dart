import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserSessionManager {
  // Keys for SharedPreferences
  static const String KEY_USER_ID = 'user_id';
  static const String KEY_USERNAME = 'username';
  static const String KEY_PROFILE_IMAGE = 'profile_image';
  static const String KEY_IS_LOGGED_IN = 'is_logged_in';
  static const String KEY_USER_DATA = 'user_data'; // For storing complete user object

  // Save user session after login/signup
  static Future<void> saveUserSession(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save individual fields
    await prefs.setString(KEY_USER_ID, userData['id'] ?? '');
    await prefs.setString(KEY_USERNAME, userData['username'] ?? '');
    await prefs.setString(KEY_PROFILE_IMAGE, userData['profileImage'] ?? '');
    await prefs.setBool(KEY_IS_LOGGED_IN, true);
    
    // Save complete user data as JSON string
    await prefs.setString(KEY_USER_DATA, jsonEncode(userData));
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KEY_IS_LOGGED_IN) ?? false;
  }

  // Get current user ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_USER_ID);
  }

  // Get username
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_USERNAME);
  }

  // Get full user data
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(KEY_USER_DATA);
    
    if (userDataString == null) return null;
    
    try {
      return jsonDecode(userDataString) as Map<String, dynamic>;
    } catch (e) {
      print('Error parsing user data: $e');
      return null;
    }
  }

  // Clear session on logout
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}