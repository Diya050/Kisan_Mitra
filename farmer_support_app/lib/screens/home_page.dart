import 'package:farmer_support_app/screens/home_dashboard_screen.dart';
import 'package:farmer_support_app/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../widgets/custom_navbar.dart';
import '../widgets/top_navbar.dart';
// import 'package:farmer_support_app/screens/plant_guide_screen.dart';
import 'package:farmer_support_app/screens/chatbot_disclaimer_screen.dart';
import 'package:farmer_support_app/screens/news_screen.dart';
import 'package:farmer_support_app/screens/image_display_screen.dart';

class HomePage extends StatefulWidget {
  final String language;

  const HomePage({super.key, this.language = "en"});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  File? _image;

  final List<Widget> _pages = [
    HomeDashboardScreen(),
    ChatbotWelcomeScreen(),
    const Center(child: Text("Placeholder")),
    NewsScreen(),
    SettingsScreen()
  ];

  void _onItemTapped(int index) {
    if (index != 2) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      if (!mounted) return;

      setState(() {
        _image = File(pickedFile.path);
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageDisplayScreen(image: _image!),
        ),
      );
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: TopNavBar(language: "en"),
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: CustomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showImagePickerOptions,
          backgroundColor: Colors.green,
          elevation: 10,
          child: Icon(Icons.camera_alt, size: 32, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}