import 'package:flutter/material.dart';
import '../widgets/custom_navbar.dart';
import '../widgets/top_navbar.dart'; // Import the TopNavBar
// import 'package:farmer_support_app/screens/settings_screen.dart';
import 'package:farmer_support_app/screens/plant_guide_screen.dart';
// import 'package:farmer_support_app/screens/specific_crop_guide_screen.dart';
import 'package:farmer_support_app/screens/chatbot_disclaimer_screen.dart';
import 'package:farmer_support_app/screens/news_screen.dart';

class HomePage extends StatefulWidget {
  final String language; // Accept language as a parameter

  const HomePage({super.key, this.language = "en"}); // Default: English

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text("Home")),
    ChatbotWelcomeScreen(),
    // const Center(child: Text("Plant Doctor")),
    // CropGuideScreen(cropName: 'potato', imageUrl: 'rust_disease.jpg', symptoms: "abc", reasons: "def", healingMethods: "ghi"),
    const Center(child: Text("Placeholder")), // Placeholder for Floating Button
    // const Center(child: Text("Plant's Diseases")),
    PlantGuideScreen(),// Crop Guide (index 6)
    // const Center(child: Text("Settings")),
    // WeatherScreen(),     // Weather (index 3)
    // NewsSchemesScreen(), // News & Schemes (index 4)
    // ReminderScreen(),    // Reminder (index 5)
    // SettingsScreen(),    // Settings (index 7)
    NewsScreen(),
  ];

  void _onItemTapped(int index) {
    if (index != 2) { // Skip the floating button
      setState(() {
        _selectedIndex = index;
      });
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize( // Add the top navbar here
        preferredSize: Size.fromHeight(60), // Adjust height
        child: TopNavBar(language: "en"), // Change "hi" for Hindi
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("Camera Clicked");
        },
        backgroundColor: Colors.teal,
        elevation: 10,
        child: Icon(Icons.camera_alt, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
