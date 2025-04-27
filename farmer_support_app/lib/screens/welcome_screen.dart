import 'dart:async';
import 'package:flutter/material.dart';
import 'package:farmer_support_app/screens/login_screen.dart'; // Replace with the actual path of your login screen
import 'package:farmer_support_app/services/notification_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super
        .initState(); // must call super first :contentReference[oaicite:1]{index=1}

    // ONE-TIME welcome notification on splash/OTP
    NotificationService.welcomeNotification(
      id: 0,
      title: 'Welcome to KisanMitra!',
      body: 'Thank you for choosing our app.',
    );

    // Delay for 3 seconds, then navigate to LoginScreen
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color if needed
      body: SafeArea(
        child: Center(
          child: Image.asset(
            "assets/welcome_screen.jpg", // Make sure this matches the file in your assets folder
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
