// import 'package:farmer_support_app/screens/home_page.dart';
import 'package:farmer_support_app/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  OtpScreenState createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    debugPrint("Building OtpScreen...");

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // Ensure the UI is scrollable
        child: Column(
          children: [
            Image.asset('assets/otp.png', width: double.infinity, height: 250, fit: BoxFit.cover),
            const SizedBox(height: 20),
            const Text("Enter OTP", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter OTP",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(200, 50),
              ),
              onPressed: () {
                debugPrint("Button pressed! OTP: ${_otpController.text}");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => OnboardingScreen()),
                );
              },
              child: const Text("Verify OTP", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                debugPrint("Resend OTP clicked!");
              },
              child: const Text("Resend OTP", style: TextStyle(fontSize: 16, color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}
