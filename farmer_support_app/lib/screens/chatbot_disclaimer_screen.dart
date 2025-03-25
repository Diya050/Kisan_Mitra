import 'package:flutter/material.dart';
import 'package:farmer_support_app/screens/chat_screen.dart';

class ChatbotWelcomeScreen extends StatelessWidget {
  const ChatbotWelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    "🌱 Welcome to the Kisan Mitra \n   digital assistant! 🌱",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              
              _buildSection(
                title: "Limitations",
                icon: Icons.info_outline,
                text:
                    "Answers are given as a guide but do not replace individual discussion with an advisor.",
              ),

              SizedBox(height: 20),

              _buildSection(
                title: "Privacy",
                icon: Icons.lock_outline,
                text:
                    "Conversations will be stored to further improve the service. Your data will not be passed to third parties.",
              ),

              SizedBox(height: 10),

              _buildSection(
                title: "",
                icon: Icons.shield_outlined,
                text:
                    "This service builds on ChatGPT API from OpenAI. By using this service, OpenAI’s provisions as stipulated apply.",
              ),

              Spacer(),

              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      // Navigate to chatbot screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen()),
                      );
                    },
                    child: Text(
                      "Start Chatting",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required IconData icon, required String text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 22, color: Colors.black54),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
