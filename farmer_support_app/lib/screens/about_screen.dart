import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset("assets/logo.png", height: 100), // Add your app logo
                    const SizedBox(height: 10),
                    const Text(
                      "Kisan Mitra - Your Smart Farming Companion",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text("Version 1.0.0", style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "About Kisan Mitra",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Kisan Mitra is an innovative application designed to help farmers manage their crops, "
                "access weather forecasts, get expert advice, and stay updated with the latest agricultural news. "
                "Our goal is to empower farmers with the tools they need for smarter farming decisions.",
              ),
              const SizedBox(height: 20),

              const Text(
                "Key Features",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text("✔ Weather forecasts and climate updates"),
              const Text("✔ Crop management and guide"),
              const Text("✔ Agricultural news and government schemes"),
              const Text("✔ Expert plant doctor consultations"),
              const Text("✔ Community support and discussions"),
              const SizedBox(height: 20),

              const Text(
                "Developed By",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "This app was developed by a passionate team dedicated to revolutionizing agriculture through technology. "
                "For feedback, support, or collaborations, feel free to reach out to us!",
              ),
              const SizedBox(height: 30),

              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle contact action
                  },
                  icon: const Icon(Icons.mail),
                  label: const Text("Contact Us"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
