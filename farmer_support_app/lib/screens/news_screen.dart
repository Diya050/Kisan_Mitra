import 'package:farmer_support_app/screens/specific_news_screen.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  NewsScreen({super.key});
  final List<Map<String, dynamic>> articles = [
    {
      "image": "assets/news1.jpg", // Replace with actual image URL
      "title": "Dr. Gurdev Singh Khush Foundation's annual awards ceremony...",
      "date": "20 Mar",
      "unread": true,
    },
    {
      "image": "assets/news2.jpg",
      "title": "He is earning good profit by cultivating marigold flowers...",
      "date": "18 Mar",
      "unread": true,
    },
    {
      "image": "assets/news3.jpg",
      "title": "These 3 machines are essential for livestock farming...",
      "date": "18 Mar",
      "unread": true,
    },
    {
      "image": "assets/news4.jpg",
      "title": "Weather will remain clear today, rain and snowfall expected...",
      "date": "18 Mar",
      "unread": true,
    },
    {
      "image": "assets/news5.jpg",
      "title": "The farmer has been earning good profits by organic farming...",
      "date": "17 Mar",
      "unread": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("News", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {
              // Handle share action
            },
            icon: Icon(Icons.share, color: Colors.green),
            label: Text("Share", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(10),
        itemCount: articles.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final article = articles[index];
          return ListTile(
            leading: Image.asset(article["image"], width: 100, height: 80, fit: BoxFit.cover),
            title: Text(article["title"], maxLines: 2, overflow: TextOverflow.ellipsis),
            subtitle: Text(article["date"]),
            trailing: article["unread"]
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("Unread", style: TextStyle(color: Colors.blue)),
                  )
                : SizedBox(),
            onTap: () {
              // Open article details
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SpecificNewsScreen()));
            },
          );
        },
      ),
    );
  }
}
