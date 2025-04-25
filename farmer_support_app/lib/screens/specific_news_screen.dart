import 'package:flutter/material.dart';

class SpecificNewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> news =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: Text(news['title'] ?? 'News')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(news['title'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(news['pubDate'] ?? '', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 20),
            Text(news['description'] ?? 'No content available.'),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Read Full Article"),
              onPressed: () {
                // Launch the article link using url_launcher if needed
              },
            ),
          ],
        ),
      ),
    );
  }
}
