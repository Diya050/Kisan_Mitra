import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FarmerProfileScreen extends StatefulWidget {
  const FarmerProfileScreen({super.key});
  @override
  FarmerProfileScreenState createState() => FarmerProfileScreenState();
}

class FarmerProfileScreenState extends State<FarmerProfileScreen> {
  File? _image;
  final picker = ImagePicker();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  bool isWhatsAppNumber = false;
  String? selectedState;
  String? selectedDistrict;

  Map<String, List<String>> stateDistrictMap = {
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur'],
    'Uttar Pradesh': ['Lucknow', 'Kanpur', 'Varanasi'],
    'Rajasthan': ['Jaipur', 'Udaipur', 'Jodhpur'],
  };

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _saveProfile() {
    // Save data logic
    debugPrint("First Name: ${firstNameController.text}");
    debugPrint("Last Name: ${lastNameController.text}");
    debugPrint("Mobile: ${mobileNumberController.text}");
    debugPrint("State: $selectedState");
    debugPrint("District: $selectedDistrict");
    debugPrint("Is WhatsApp Number: $isWhatsAppNumber");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _image != null ? FileImage(_image!) : AssetImage("assets/default_avatar.png") as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 18,
                        child: Icon(Icons.camera_alt, color: Colors.green),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            
            Text("About Me", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            SizedBox(height: 10),
            _buildTextField("First Name", firstNameController),
            _buildTextField("Last Name", lastNameController),
            
            Text("Mobile Number", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: mobileNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            SizedBox(height: 10),
            
            Text("State", style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: selectedState,
              items: stateDistrictMap.keys.map((String state) {
                return DropdownMenuItem(value: state, child: Text(state));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedState = newValue;
                  selectedDistrict = null;
                });
              },
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(height: 10),

            Text("District", style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: selectedDistrict,
              items: selectedState != null
                  ? stateDistrictMap[selectedState!]!.map((String district) {
                      return DropdownMenuItem(value: district, child: Text(district));
                    }).toList()
                  : [],
              onChanged: (String? newValue) {
                setState(() {
                  selectedDistrict = newValue;
                });
              },
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12)),
                child: Text("Save Profile", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
