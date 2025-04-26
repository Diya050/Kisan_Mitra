import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'news_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  @override
  _HomeDashboardScreenState createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  late Future<List<NewsArticle>> _newsFuture;
  String? _savedLocation;
  Map<String, dynamic>? _weatherData;

  @override
  void initState() {
    super.initState();
    _newsFuture = fetchLatestNews();
    loadSavedWeather(); // ← load on startup
  }

  // ← NEW: fetch from your backend
  Future<void> fetchWeather(String location) async {
    final resp = await http.get(Uri.parse('http://localhost:3000/weather?location=$location'));
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      setState(() {
        _weatherData = data;
        _savedLocation = location;
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('savedLocation', location);
      await prefs.setString('savedWeatherData', json.encode(data));
    } else {
      throw Exception('Weather fetch failed (${resp.statusCode})');
    }
  }

  // ← NEW: restore last-saved
  Future<void> loadSavedWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final loc = prefs.getString('savedLocation');
    final jsonStr = prefs.getString('savedWeatherData');
    if (loc != null && jsonStr != null) {
      setState(() {
        _savedLocation = loc;
        _weatherData = json.decode(jsonStr);
      });
    }
  }

  // ← NEW: clear card
  Future<void> deleteWeather() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedLocation');
    await prefs.remove('savedWeatherData');
    setState(() {
      _savedLocation = null;
      _weatherData = null;
    });
  }

  // ← NEW: prompt once
  Future<void> promptForLocation() async {
  final TextEditingController _locationController = TextEditingController();

  String? location = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Enter Location'),
      content: TextField(
        controller: _locationController,
        autofocus: true,
        decoration: InputDecoration(hintText: 'City Name or Zip Code'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_locationController.text);
          },
          child: Text('OK'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
      ],
    ),
  );

  if (location != null && location.isNotEmpty) {
    await fetchWeather(location);
  }
}


  Future<List<NewsArticle>> fetchLatestNews() async {
    try {
      // Replace <user-ip> with your backend server's IP or domain
      final response = await http.get(Uri.parse('http://localhost:3000/news'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        // Parse JSON into list of NewsArticle
        List<NewsArticle> articles = jsonData
            .map((data) => NewsArticle.fromJson(data))
            .toList();
        // Optionally sort by date descending to get latest articles first
        articles.sort((a, b) => b.pubDate.compareTo(a.pubDate));
        // Return only the latest two articles
        return articles.take(5).toList();
      } else {
        throw Exception('Failed to load news (Status code: ${response.statusCode})');
      }
    } catch (e) {
      // Handle any errors that might occur during the HTTP call
      throw Exception('Failed to fetch news: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ← NEW: Weather Card / Button above News
            if (_weatherData != null) ...[
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  leading: Icon(Icons.wb_sunny, color: Colors.orange),
                  title: Text(_weatherData!['location'] ?? 'Unknown'),
                  subtitle: Text(
                    'Temp: ${_weatherData!['temperature']}°C\n'
                    '${_weatherData!['description']}'
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: deleteWeather,
                  ),
                ),
              ),
            ] else ...[
              ElevatedButton.icon(
                onPressed: promptForLocation,
                icon: Icon(Icons.add_location),
                label: Text('Add Weather Info'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
            SizedBox(height: 16),

            // FutureBuilder to handle asynchronous fetch of news articles
            FutureBuilder<List<NewsArticle>>(
              future: _newsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While loading data, show a progress indicator
                  return Container(
                    height: 220,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                    return Container(
                        height: 220,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: Colors.red, size: 48),
                            SizedBox(height: 8),
                            Text(
                              'Failed to load news!',
                              style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              snapshot.error.toString(), // <-- show error message
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // Handle the case where no news is available
                  return Text('No news available');
                }
                // When data is fetched successfully, display the articles
                final articles = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                    // Title row with button on the right
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Latest News',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to the full news list screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => NewsScreen()),
                            );
                          },
                          child: Text('View All News', style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF006400),
                          ),),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          final article = articles[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: InkWell(
                              onTap: () async {
                                final url = Uri.parse(article.link);
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url, mode: LaunchMode.externalApplication);
                                } else {
                                  // Show error if the URL can't be launched
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Could not open the article')),
                                  );
                                }
                              },
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Container(
                                  width: 200,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Article image (use placeholder if imageUrl is null or empty)
                                      article.imageUrl != null && article.imageUrl!.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8),
                                              ),
                                              child: Image.network(
                                                article.imageUrl!,
                                                height: 120,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  // In case the image fails to load, show a placeholder
                                                  return Container(
                                                    height: 120,
                                                    color: Colors.grey[300],
                                                    child: Container(
                                                      width: 200,
                                                      height: 150,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius: BorderRadius.circular(8),
                                                        border: Border.all(color: Colors.grey, width: 1),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(
                                                            Icons.image_not_supported,
                                                            size: 60,
                                                            color: Colors.grey[600],
                                                          ),
                                                          const SizedBox(height: 8),
                                                          Text(
                                                            "No Image Available",
                                                            style: TextStyle(
                                                              color: Colors.grey[600],
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : Container(
                                              height: 120,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  topRight: Radius.circular(8),
                                                ),
                                              ),
                                              child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              article.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              article.getFormattedDate(),
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// A model class for the news article
class NewsArticle {
  final String articleId;
  final String title;
  final String description;
  final String link;
  final DateTime pubDate;
  final String? imageUrl;

  NewsArticle({
    required this.articleId,
    required this.title,
    required this.description,
    required this.link,
    required this.pubDate,
    this.imageUrl,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
  return NewsArticle(
    articleId: (json['article_id'] ?? '').toString(),
    title: (json['title'] ?? '') as String,
    description: (json['description'] ?? '') as String,
    link: (json['link'] ?? '') as String,
    pubDate: DateTime.parse(json['pubDate'] as String),
    imageUrl: (json['image_url'] == null || (json['image_url'] as String).isEmpty)
        ? null
        : json['image_url'] as String,
  );
}



  String getFormattedDate() {
    // Format the date as 'DD-MM-YYYY' or any preferred format
    return "${pubDate.day.toString().padLeft(2, '0')}"
           "-${pubDate.month.toString().padLeft(2, '0')}"
           "-${pubDate.year}";
  }
}
