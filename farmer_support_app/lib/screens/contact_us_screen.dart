import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
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
                "Get in Touch",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Have a question or need support? Feel free to reach out to us!",
              ),
              const SizedBox(height: 20),

              // Name Field
              const Text("Your Name", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your name",
                ),
              ),
              const SizedBox(height: 15),

              // Email Field
              const Text("Your Email", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your email",
                ),
              ),
              const SizedBox(height: 15),

              // Message Field
              const Text("Your Message", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Type your message here...",
                ),
              ),
              const SizedBox(height: 20),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle form submission
                  },
                  child: const Text("Send Message"),
                ),
              ),

              const SizedBox(height: 30),

              const Divider(),

              // Contact Details
              const SizedBox(height: 10),
              const Text(
                "Other Ways to Reach Us",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              Row(
                children: const [
                  Icon(Icons.email, color: Colors.green),
                  SizedBox(width: 10),
                  Text("support@Kisan Mitra.com"),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                children: const [
                  Icon(Icons.phone, color: Colors.green),
                  SizedBox(width: 10),
                  Text("+91 98765 43210"),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                children: const [
                  Icon(Icons.location_on, color: Colors.green),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text("Kisan Mitra Developers GNE, Ludhiana"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
