import 'package:farmer_support_app/screens/about_screen.dart';
import 'package:farmer_support_app/screens/chatbot_disclaimer_screen.dart';
import 'package:farmer_support_app/screens/contact_us_screen.dart';
import 'package:farmer_support_app/screens/faqs_screen.dart';
import 'package:farmer_support_app/screens/profile_screen.dart';
import 'package:farmer_support_app/screens/schemes_screen.dart';
import 'package:farmer_support_app/screens/terms_screen.dart';
import 'package:farmer_support_app/screens/weather_info_screen.dart';
import 'package:farmer_support_app/screens/your_crops_screen.dart';
import 'package:flutter/material.dart';
import 'package:farmer_support_app/screens/language_selection_screen.dart';
import 'package:farmer_support_app/screens/news_screen.dart';
import 'package:farmer_support_app/screens/plant_guide_screen.dart';
import 'package:farmer_support_app/screens/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true; // Manage toggle state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings", style: TextStyle(color: Colors.white)), backgroundColor: Colors.blue),
      body: ListView(
        children: [
          _buildListTile(Icons.person, "Profile", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => FarmerProfileScreen()));
          }),
          _buildListTile(Icons.language, "Language Selection", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LanguageSelectionScreen()));
          }),
          _buildSwitchTile(Icons.notifications, "Notifications"),
          _buildListTile(Icons.description, "Terms and Conditions", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsScreen()));
          }),
          _buildListTile(Icons.info, "About", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()));
          }),
          _buildListTile(Icons.help, "FAQs", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => FaqsScreen()));
          }),
          _buildListTile(Icons.phone, "Contact Us", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ContactUsScreen()));
          }),
          _buildListTile(Icons.logout, "Logout", () {
            _confirmLogout(context);
          }),

          // Divider for services
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Services", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),

          _buildListTile(Icons.cloud, "Weather", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => WeatherInfoScreen()));
          }),
          _buildListTile(Icons.article, "News", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NewsScreen()));
          }),
          _buildListTile(Icons.account_balance, "Schemes", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SchemesScreen()));
          }),
          _buildListTile(Icons.menu_book, "Plant Guide", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PlantGuideScreen()));
          }),
          _buildListTile(Icons.grass, "Your Crops", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CropSelectionScreen()));
          }),
          _buildListTile(Icons.healing, "Plant Doctor", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatbotWelcomeScreen()));
          }),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: onTap,
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
    );
  }

  Widget _buildSwitchTile(IconData icon, String title) {
    return SwitchListTile(
      secondary: Icon(icon, color: Colors.blue),
      title: Text(title),
      value: notificationsEnabled,
      onChanged: (bool value) {
        setState(() {
          notificationsEnabled = value;
        });
      },
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()), // Redirect to login
              );
            },
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}


