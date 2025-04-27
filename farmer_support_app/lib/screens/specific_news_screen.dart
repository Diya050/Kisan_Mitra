import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SpecificNewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final news = ModalRoute.of(context)!.settings.arguments as Map;

    final Uri articleUri = Uri.parse(news['link'] ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              news['title'] ?? '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              news['pubDate'] ?? '',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              news['description'] ?? 'No description available.',
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (await canLaunchUrl(articleUri)) {
                    await launchUrl(
                      articleUri,
                      mode: LaunchMode.externalApplication,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Could not open the article'),
                      ),
                    );
                  }
                },
                child: const Text('Read Full Article'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
