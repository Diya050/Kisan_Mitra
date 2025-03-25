import 'package:flutter/material.dart';
import 'package:farmer_support_app/screens/specific_crop_guide_screen.dart';

class PlantGuideScreen extends StatelessWidget {
  const PlantGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark theme background
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Common Plant Diseases",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search Here",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Disease Categories
            Expanded(
              child: ListView(
                children: [
                  _buildCategory(context, "Whole Plant", [
                    _buildDiseaseCard(context, "Powdery Mildew", "assets/powdery_mildew.jpg"),
                    _buildDiseaseCard(context, "Downy Mildew", "assets/downy_mildew.jpg"),
                  ]),
                  _buildCategory(context, "Leaves", [
                    _buildDiseaseCard(context, "Leaf Spot", "assets/leaf_spot.jpg"),
                    _buildDiseaseCard(context, "Rust Disease", "assets/rust_disease.jpg"),
                  ]),
                  _buildCategory(context, "Stems", [
                    _buildDiseaseCard(context, "Canker Disease", "assets/canker_disease.jpg"),
                    _buildDiseaseCard(context, "Stem Rot", "assets/stem_rot.jpg"),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),

      // Floating Camera Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          debugPrint("Camera Button Clicked!");
        },
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Function to build category section
  Widget _buildCategory(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150, // Fixed height for grid scroll
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: items,
          ),
        ),
      ],
    );
  }

  // Function to build disease card with navigation
  Widget _buildDiseaseCard(BuildContext context, String name, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CropGuideScreen(
              cropName: name,
              imageUrl: imagePath,
              symptoms: "White powdery patches appear on leaves and stems.",
              reasons: "Caused by fungi due to high humidity and poor air circulation.",
              healingMethods: "Use fungicides, improve air circulation, and remove infected parts.",
            ),
          ),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              name,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
