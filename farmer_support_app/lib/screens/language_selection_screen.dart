import 'package:flutter/material.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  LanguageSelectionScreenState createState() => LanguageSelectionScreenState();
}
class LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String selectedLanguage = "en"; // Default selection is English

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Logo
            Image.asset(
              'assets/logo.png', // Make sure this asset exists
              height: 80,
            ),
            const SizedBox(height: 10),
            
            // App Name
            const Text(
              "Kisan Mitra",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),

            // Welcome Message
            const Text(
              "Welcome to Kisan Mitra",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),

            // Language Selection Title
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Choose your Language",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Language Selection List
            languageOption("ह", "हिन्दी", "hi"),
            const SizedBox(height: 15),
            languageOption("E", "English", "en"),
          ],
        ),
      ),
    );
  }

  Widget languageOption(String icon, String name, String value) {
    bool isSelected = selectedLanguage == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green, width: 1.5),
        ),
        child: Row(
          children: [
            // Circular Icon
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  icon,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Language Name
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.green,
                ),
              ),
            ),

            // Selection Indicator
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
