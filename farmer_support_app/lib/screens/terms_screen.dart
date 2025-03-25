import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms and Conditions"),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "1. Introduction",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "By using this application, you agree to the terms and conditions outlined below. "
                "If you do not agree with any part of these terms, please discontinue use immediately.",
              ),
              const SizedBox(height: 20),

              const Text(
                "2. User Responsibilities",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "You are responsible for keeping your login credentials secure. "
                "You must not misuse the services provided by this application.",
              ),
              const SizedBox(height: 20),

              const Text(
                "3. Privacy Policy",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Your personal data is handled in accordance with our Privacy Policy. "
                "We do not sell or share your data with third parties without your consent.",
              ),
              const SizedBox(height: 20),

              const Text(
                "4. Termination of Use",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "We reserve the right to terminate your access to the app at any time if we suspect any misconduct.",
              ),
              const SizedBox(height: 20),

              const Text(
                "5. Changes to Terms",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "We may update these terms periodically. Continued use of the app implies acceptance of the updated terms.",
              ),
              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Accept"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
