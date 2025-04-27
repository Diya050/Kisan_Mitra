import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List newsData = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  String get _backendBase {
    return 'http://192.168.29.204:3000';
    // // Flutter Web
    // if (kIsWeb) return 'http://localhost:3000';
    // // Android emulator
    // if (Platform.isAndroid && !const bool.fromEnvironment('dart.vm.product')) {
    //   return 'http://10.0.2.2:3000';
    // }
    // // Physical Android device
    // if (Platform.isAndroid) {
    //   return 'http://192.168.29.204:3000'; // ← your PC’s LAN IP
    // }
    // // iOS Simulator or other
    // return 'http://localhost:3000';
  }

  Future<void> fetchNews() async {
    final response = await http.get(Uri.parse('$_backendBase/news'));
    if (response.statusCode == 200) {
      setState(() {
        newsData = json.decode(response.body);
      });
    } else {
      print('Failed to fetch news: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KisanMitra News Portal',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),
      body: newsData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: newsData.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final news = newsData[index];
                final Uri articleUri = Uri.parse(news['link'] ?? '');

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    title: Text(
                      news['title'] ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        news['pubDate'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    trailing: TextButton(
                      child: const Text('Read Full'),
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
                    ),
                  ),
                );
              },
            ),
    );
  }
}
