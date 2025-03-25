import 'package:flutter/material.dart';

class SpecificNewsScreen extends StatelessWidget {
  const SpecificNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("News", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {
              // Handle Share Action
            },
            icon: const Icon(Icons.share, color: Colors.green),
            label: const Text("Share", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // News Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/news1.jpg", // Change to actual asset path
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),

              // Title & Date
              const Text(
                "Good news for farmers! NHB is giving subsidy up to 50%, thus take advantage",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                "Aplive | 24-03-2025",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 15),

              // News Content
              const Text(
                "क्या आपको सब्सिडी मिली है?\n\n"
                "नेशनल हॉर्टिकल्चर बोर्ड (NHB) ने किसानों के लिए नई सब्सिडी योजना शुरू की है। "
                "इस योजना के तहत किसानों को 50% तक की सब्सिडी दी जाएगी।",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),

              // Social Sharing Buttons
              Row(
                children: [
                  _buildSocialButton(Icons.chat, "WhatsApp", Colors.green),
                  const SizedBox(width: 10),
                  _buildSocialButton(Icons.facebook, "Facebook", Colors.blue),
                  const SizedBox(width: 10),
                  _buildSocialButton(Icons.more_horiz, "More", Colors.grey),
                ],
              ),
              const SizedBox(height: 20),

              // More News Articles
              const Text(
                "More News Articles",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              _buildNewsTile("assets/news2.jpg",
                  "These varieties of potatoes will give more production...", "08 Oct"),
              _buildNewsTile("assets/news3.jpg",
                  "Now it is easy for the farmers of Rajasthan to take loan and repay...", "02 Apr"),

              // View All News Button
              Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to full news list
                  },
                  child: const Text(
                    "View All News >",
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Social Media Button Widget
  Widget _buildSocialButton(IconData icon, String label, Color color) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white, size: 18),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // News Tile for More Articles
  Widget _buildNewsTile(String imagePath, String title, String date) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(imagePath, width: 80, height: 60, fit: BoxFit.cover),
      ),
      title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(date),
      onTap: () {
        // Navigate to specific news
      },
    );
  }
}
