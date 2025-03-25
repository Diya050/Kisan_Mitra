import 'package:flutter/material.dart';

class FaqsScreen extends StatelessWidget {
  const FaqsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQs"),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            FAQItem(
              question: "How can I register on the Kisan Mitra app?",
              answer: "To register, click on the 'Sign Up' button, enter your details, and verify your mobile number. "
                  "Once verified, you can start using the app.",
            ),
            FAQItem(
              question: "Is the app free to use?",
              answer: "Yes, Kisan Mitra is completely free to use. Some premium features may be introduced in the future.",
            ),
            FAQItem(
              question: "How do I get weather updates for my location?",
              answer: "The app automatically detects your location and provides weather updates. You can also set a manual location "
                  "from the settings.",
            ),
            FAQItem(
              question: "How can I contact an agricultural expert?",
              answer: "You can reach out to experts through the 'Ask an Expert' feature in the app. Just submit your query, and an expert will respond.",
            ),
            FAQItem(
              question: "Can I connect with other farmers using this app?",
              answer: "Yes, the app has a community forum where farmers can share experiences, ask questions, and discuss farming techniques.",
            ),
            FAQItem(
              question: "What crops does the app support?",
              answer: "The app provides guides for a wide range of crops, including wheat, rice, maize, vegetables, and fruits.",
            ),
            FAQItem(
              question: "Is my personal data safe?",
              answer: "Yes, we prioritize user data security. Your information is protected and not shared with third parties.",
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(answer),
          ),
        ],
      ),
    );
  }
}
