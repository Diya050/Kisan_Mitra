// import 'package:farmer_support_app/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import '../screens/language_selection_screen.dart';
class TopNavBar extends StatelessWidget {
  final String language; // "en" or "hi"

  const TopNavBar({super.key, required this.language});
  @override
  Widget build(BuildContext context) {
    final Map<String, String> text = {
      "en": "Welcome to Kisan Mitra",
      "hi": "किसान मित्र में आपका स्वागत है"
    };

    // Debugging: Print selected language
    debugPrint("Language Selected: $language");

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.green,
        boxShadow: [
          BoxShadow(
            color: Colors.white, // ✅ FIXED
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          // Logo and text section in an Expanded to avoid overflow
          Expanded(
            child: Row(
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 40,
                ),
                const SizedBox(width: 10),
                // Ensure text is always visible
                Expanded(
                  child: Text(
                    text[language] ?? "Welcome",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis, // Avoid overflow
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Optional Language Icon (or any other trailing item)
          IconButton(
            icon: Icon(Icons.language, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanguageSelectionScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
