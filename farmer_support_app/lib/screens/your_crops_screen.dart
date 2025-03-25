import 'package:flutter/material.dart';

class CropSelectionScreen extends StatefulWidget {
  const CropSelectionScreen({super.key});
  @override
  CropSelectionScreenState createState() => CropSelectionScreenState();
}

class CropSelectionScreenState extends State<CropSelectionScreen> {
  List<Map<String, String>> allCrops = [
    {"name": "Tomato", "image": "assets/crops/tomato.jpg"},
    {"name": "Red Chilli", "image": "assets/crops/red_chilli.jpg"},
    {"name": "Green Chilli", "image": "assets/crops/green_chilli.jpg"},
    {"name": "Maize", "image": "assets/crops/maize.jpg"},
    {"name": "Onion", "image": "assets/crops/onion.jpg"},
    {"name": "Okra", "image": "assets/crops/okra.jpg"},
    {"name": "Brinjal", "image": "assets/crops/brinjal.jpg"},
    {"name": "Cabbage", "image": "assets/crops/cabbage.jpg"},
    {"name": "Muskmelon", "image": "assets/crops/muskmelon.jpg"},
    {"name": "Carrot", "image": "assets/crops/carrot.jpg"},
    {"name": "Cotton", "image": "assets/crops/cotton.jpg"},
    {"name": "Beans", "image": "assets/crops/beans.jpg"},
    {"name": "Barley", "image": "assets/crops/barley.jpg"},
    {"name": "Capsicum", "image": "assets/crops/capsicum.jpg"},
    {"name": "Potato", "image": "assets/crops/potato.jpg"},
    {"name": "Paddy", "image": "assets/crops/paddy.jpg"},
  ];

  List<Map<String, String>> selectedCrops = [];

  void toggleSelection(Map<String, String> crop) {
    setState(() {
      if (selectedCrops.contains(crop)) {
        selectedCrops.remove(crop);
      } else {
        selectedCrops.add(crop);
      }
    });
  }

  void saveSelection() {
    // You can save the selection to a database or navigate to another screen
    debugPrint("Selected Crops: ${selectedCrops.map((c) => c['name']).toList()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose a Crop"),
        backgroundColor: Colors.green,
        actions: [
          TextButton(
            onPressed: saveSelection,
            child: Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your Crops", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
            selectedCrops.isEmpty
                ? Text("No Crops Selected", style: TextStyle(color: Colors.grey))
                : GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: selectedCrops.length,
                    itemBuilder: (context, index) {
                      return CropItem(
                        crop: selectedCrops[index],
                        isSelected: true,
                        onTap: () => toggleSelection(selectedCrops[index]),
                      );
                    },
                  ),
            SizedBox(height: 10),
            Text("Other Crops", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.8,
                ),
                itemCount: allCrops.length,
                itemBuilder: (context, index) {
                  return CropItem(
                    crop: allCrops[index],
                    isSelected: selectedCrops.contains(allCrops[index]),
                    onTap: () => toggleSelection(allCrops[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CropItem extends StatelessWidget {
  final Map<String, String> crop;
  final bool isSelected;
  final VoidCallback onTap;

  const CropItem({super.key, required this.crop, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.green.withValues(alpha: 0.3) : Colors.grey[200],
            ),
            padding: EdgeInsets.all(10),
            child: Image.asset(crop["image"]!, height: 40, width: 40),
          ),
          Text(crop["name"]!, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
