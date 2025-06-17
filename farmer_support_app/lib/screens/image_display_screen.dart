import 'dart:io';
import 'package:farmer_support_app/services/user_session_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImageDisplayScreen extends StatefulWidget {
  final File image;

  const ImageDisplayScreen({super.key, required this.image});

  @override
  State<ImageDisplayScreen> createState() => _ImageDisplayScreenState();
}

class _ImageDisplayScreenState extends State<ImageDisplayScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _predictionResult;
  String? _errorMessage;

  Future<void> _sendImageForPrediction(File imageFile, Map<String, String> userProfile) async {
    setState(() {
      _isLoading = true;
      _predictionResult = null;
      _errorMessage = null;
    });

    try {
      var uri = Uri.parse('http://192.168.15.26:5000/predict'); // Replace with your API endpoint
      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      // Add user profile data as fields in the request
      userProfile.forEach((key, value) {
        request.fields[key] = value;
      });

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(responseBody);
        setState(() {
          _predictionResult = decodedResponse;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to predict. Status code: ${response.statusCode}\nBody: $responseBody';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error sending image: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Diagnosis'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text('Error: $_errorMessage'))
                : _predictionResult == null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoBanner(),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              widget.image,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              // Fetch user profile here
                              final userId = await UserSessionManager.getUserId();
                              if (userId != null) {
                                final userProfile = await _fetchUserProfileData(userId);
                                if (userProfile.isNotEmpty) {
                                  await _sendImageForPrediction(widget.image, userProfile);
                                } else {
                                  setState(() {
                                    _errorMessage = 'Could not fetch user profile.';
                                  });
                                }
                              } else {
                                setState(() {
                                  _errorMessage = 'User ID not found.';
                                });
                              }
                            },
                            child: const Text('Analyze Image'),
                          ),
                        ],
                      )
                    : _buildPredictionResult(),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info, color: Colors.blue),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Please check if the below disease matches the damage on your crop',
              style: TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionResult() {
    final leafStatus = _predictionResult!['leaf_status'];

    if (leafStatus == 'Non-Leaf') {
      return Center(
        child: Text(_predictionResult!['message'] ?? 'Not a leaf.'),
      );
    }

    final predictedDisease = _predictionResult!['predicted_disease'];
    final baseRecommendation = _predictionResult!['base_recommendation'];
    final personalizedRecommendation = _predictionResult!['personalized_recommendation'];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoBanner(),
          const SizedBox(height: 16),
          Text(
            predictedDisease ?? 'Unknown Disease',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (baseRecommendation != null) ...[
            _buildDetailItem(Icons.medical_services, 'Symptoms', baseRecommendation['symptoms']),
            _buildDetailItem(Icons.warning, 'Causes', baseRecommendation['causes']),
            _buildDetailItem(Icons.healing, 'Recommended Treatment', baseRecommendation['recommended_treatment']),
            _buildDetailItem(Icons.security, 'Preventive Measures', baseRecommendation['prevention']),
            _buildDetailItem(Icons.eco, 'Organic Treatment', baseRecommendation['organic_treatment']),
            _buildDetailItem(Icons.alt_route, 'Alternative Prevention', baseRecommendation['alternative_prevention']),
            if (baseRecommendation['procedure_video'] != null)
              _buildLinkItem(Icons.play_circle_outline, 'Procedure Video', baseRecommendation['procedure_video']),
            if (baseRecommendation['disease_image'] != null)
              _buildImagePreview(baseRecommendation['disease_image']),
            const SizedBox(height: 16),
          ],
          const Text(
            'Personalized Recommendation:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(personalizedRecommendation ?? 'No personalized recommendation available.'),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(value ?? 'Not available'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkItem(IconData icon, String title, String? url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () {
          // Implement logic to open the URL (e.g., using url_launcher)
          print('Opening URL: $url');
        },
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(width: 4),
            Text(url ?? 'Not available', style: const TextStyle(color: Colors.blue)),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Disease Image:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Image.network(
            imageUrl,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Text('Failed to load disease image.');
            },
          ),
        ],
      ),
    );
  }

  // Placeholder for fetching user profile data
  Future<Map<String, String>> _fetchUserProfileData(String userId) async {
    // *** IMPORTANT: Replace this with your actual user profile fetching logic ***
    // This should call your backend API to get the user's details.
    // For now, we'll return some dummy data.
    // You'll likely use the http package here as well.

    // Example using the provided fetchUserProfile function (you might need to adapt it)
    try {
      var uri = Uri.parse('http://192.168.15.26:3000/api/v1/user/$userId');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return {
          'name': '${data['firstName']} ${data['lastName']}',
          'location': data['location'] ?? '', // Or combine city and state
          'soil_type': data['soilType'] ?? '',
          'soil_ph': data['soilPhLevel']?.toString() ?? '',
          'farming_preference': data['farmingPreference'] ?? '',
          'farm_size': data['farmSize'] ?? '',
        };
      } else {
        print("Failed to fetch profile for prediction: ${response.statusCode}");
        return {};
      }
    } catch (e) {
      print("Error fetching profile for prediction: $e");
      return {};
    }
  }
}