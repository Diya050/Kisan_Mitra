import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:farmer_support_app/screens/chat_history.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {"sender": "bot", "text": "Hello! How can I help you today?"},
  ];

  late stt.SpeechToText _speech;
  bool _isListening = false;
  final String _queryApiUrl = 'http://192.168.15.26:5000/query'; // Replace with your Flask API URL (including port)

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => debugPrint("Speech status: $status"),
      onError: (error) => debugPrint("Speech error: $error"),
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _controller.text = result.recognizedWords;
          });
        },
      );
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  Future<void> _sendQuery(String query) async {
    setState(() {
      _messages.add({"sender": "user", "text": query});
      _controller.clear();
    });

    final Map<String, dynamic> requestBody = {
      "query": query,
      "profile": {
        "name": "Existing User", // Replace with actual user data
        "location": "Ludhiana", // Replace with actual user data
        "soil_type": "Loamy", // Replace with actual user data
        "soil_ph": "6.5", // Replace with actual user data
        "farming_preference": "Organic", // Replace with actual user data
      },
    };

    try {
      final response = await http.post(
        Uri.parse(_queryApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      dynamic decodedResponse; // Define decodedResponse outside the if block

      if (response.statusCode == 200) {
        decodedResponse = jsonDecode(response.body);
        setState(() {
          _messages.add({"sender": "bot", "text": decodedResponse['response'] ?? 'No response received.'});
        });
      } else {
        decodedResponse = jsonDecode(response.body); // Decode even for error responses
        setState(() {
          _messages.add({"sender": "bot", "text": "Error: ${decodedResponse['error'] ?? 'Something went wrong.'}"});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({"sender": "bot", "text": "Failed to connect to the server."});
      });
      debugPrint('Error sending query: $e');
    }
  }

  void _sendMessage() {
    String messageText = _controller.text.trim();
    if (messageText.isNotEmpty) {
      _sendQuery(messageText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kisan Mitra Chat"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatHistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message["sender"] == "user";
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.lightGreen[200] : Colors.blueGrey[100],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      message["text"]!,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Ask a question",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isListening ? Icons.mic_off : Icons.mic,
                    color: _isListening ? Colors.red : Colors.blue,
                  ),
                  onPressed: _isListening ? _stopListening : _startListening,
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}