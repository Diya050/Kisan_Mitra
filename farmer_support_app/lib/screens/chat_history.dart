import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: ChatHistoryScreen(),
  ));
}

class ChatHistoryScreen extends StatelessWidget {
  ChatHistoryScreen({super.key});
  
  final List<String> chatItems = List.generate(5, (index) => "Chat ${index + 1}");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Chat History"),
        backgroundColor: Colors.white,
        elevation: 1, // Slight shadow effect
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        iconTheme: IconThemeData(color: Colors.black), // Back arrow color
      ),
      body: Column(
        children: [
          Divider(height: 1, color: Colors.grey), // Horizontal divider
          Expanded(
            child: ListView.builder(
              itemCount: chatItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(chatItems[index]),
                  onTap: () {}, // Handle tap action if needed
                  tileColor: Colors.white,
                  shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
