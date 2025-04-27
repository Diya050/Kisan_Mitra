import 'package:farmer_support_app/services/user_session_manager.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FarmerProfileScreen extends StatefulWidget {
  const FarmerProfileScreen({super.key});
  @override
  FarmerProfileScreenState createState() => FarmerProfileScreenState();
}

class FarmerProfileScreenState extends State<FarmerProfileScreen> {
  File? _image;
  String? profileImageUrl;
  final picker = ImagePicker();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  bool isWhatsAppNumber = false;
  String? selectedState;
  String? selectedDistrict;

  Map<String, List<String>> stateDistrictMap = {
    'Andhra Pradesh': ['Visakhapatnam', 'Vijayawada', 'Guntur', 'Nellore', 'Kurnool'],
    'Arunachal Pradesh': ['Itanagar', 'Tawang', 'Ziro', 'Pasighat'],
    'Assam': ['Guwahati', 'Dibrugarh', 'Silchar', 'Jorhat'],
    'Bihar': ['Patna', 'Gaya', 'Muzaffarpur', 'Bhagalpur'],
    'Chhattisgarh': ['Raipur', 'Bilaspur', 'Durg', 'Korba'],
    'Goa': ['Panaji', 'Margao', 'Vasco da Gama', 'Mapusa'],
    'Gujarat': ['Ahmedabad', 'Surat', 'Vadodara', 'Rajkot', 'Bhavnagar'],
    'Haryana': ['Gurugram', 'Faridabad', 'Panipat', 'Ambala', 'Karnal'],
    'Himachal Pradesh': ['Shimla', 'Manali', 'Dharamshala', 'Solan'],
    'Jharkhand': ['Ranchi', 'Jamshedpur', 'Dhanbad', 'Bokaro'],
    'Karnataka': ['Bengaluru', 'Mysuru', 'Mangalore', 'Hubli', 'Belgaum'],
    'Kerala': ['Thiruvananthapuram', 'Kochi', 'Kozhikode', 'Thrissur'],
    'Madhya Pradesh': ['Bhopal', 'Indore', 'Gwalior', 'Jabalpur'],
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Nashik', 'Aurangabad'],
    'Manipur': ['Imphal', 'Bishnupur', 'Thoubal', 'Churachandpur'],
    'Meghalaya': ['Shillong', 'Tura', 'Jowai', 'Baghmara'],
    'Mizoram': ['Aizawl', 'Lunglei', 'Champhai', 'Serchhip'],
    'Nagaland': ['Kohima', 'Dimapur', 'Mokokchung', 'Wokha'],
    'Odisha': ['Bhubaneswar', 'Cuttack', 'Rourkela', 'Sambalpur'],
    'Punjab': ['Ludhiana', 'Amritsar', 'Jalandhar', 'Patiala'],
    'Rajasthan': ['Jaipur', 'Udaipur', 'Jodhpur', 'Kota', 'Ajmer'],
    'Sikkim': ['Gangtok', 'Namchi', 'Geyzing', 'Mangan'],
    'Tamil Nadu': ['Chennai', 'Coimbatore', 'Madurai', 'Tiruchirappalli', 'Salem'],
    'Telangana': ['Hyderabad', 'Warangal', 'Nizamabad', 'Karimnagar'],
    'Tripura': ['Agartala', 'Udaipur', 'Dharmanagar', 'Kailashahar'],
    'Uttar Pradesh': ['Lucknow', 'Kanpur', 'Varanasi', 'Agra', 'Allahabad'],
    'Uttarakhand': ['Dehradun', 'Haridwar', 'Nainital', 'Haldwani'],
    'West Bengal': ['Kolkata', 'Howrah', 'Durgapur', 'Siliguri'],
    'Andaman and Nicobar Islands': ['Port Blair'],
    'Chandigarh': ['Chandigarh'],
    'Dadra and Nagar Haveli and Daman and Diu': ['Daman', 'Diu', 'Silvassa'],
    'Delhi': ['New Delhi', 'North Delhi', 'South Delhi', 'West Delhi', 'East Delhi'],
    'Jammu and Kashmir': ['Srinagar', 'Jammu', 'Anantnag', 'Baramulla'],
    'Ladakh': ['Leh', 'Kargil'],
    'Lakshadweep': ['Kavaratti'],
    'Puducherry': ['Puducherry', 'Karaikal', 'Mahe', 'Yanam'],
  };

  @override
  void initState() {
    super.initState();
    fetchUserProfile(); // Fetch user profile data on screen load
  }

  Future<void> fetchUserProfile() async {
    try {
      final userId = await UserSessionManager.getUserId();
      if (userId == null) {
        debugPrint("User ID not found");
        return;
      }

      var uri = Uri.parse('http://192.168.1.79:3000/api/v1/user/$userId'); // replace with your real URL
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        
        setState(() {
          firstNameController.text = data['firstName'] ?? '';
          lastNameController.text = data['lastName'] ?? '';
          mobileNumberController.text = data['mobileNumber'] ?? '';
          selectedState = data['state'];
          selectedDistrict = data['district'];
          isWhatsAppNumber = data['isWhatsAppNumber'] ?? false;
          profileImageUrl = data['profileImage'];
          // If you have profileImage URL, you can download it and set _image
          // _image = File(....); // Optional based on your backend response
        });
      } else {
        debugPrint("Failed to fetch profile. Status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    }
  }

Future<void> _pickImage() async {
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    setState(() {
      _image = File(pickedFile.path);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Image selected successfully")),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("No image selected")),
    );
  }
}

void _saveProfile() async {
  try {
    final userId = await UserSessionManager.getUserId();
    if (userId == null) {
      debugPrint("User ID not found");
      return;
    }

    var uri = Uri.parse('http://192.168.1.79:3000/api/v1/user/$userId');
    var request = http.MultipartRequest('PUT', uri);

    request.fields['firstName'] = firstNameController.text;
    request.fields['lastName'] = lastNameController.text;
    request.fields['mobileNumber'] = mobileNumberController.text;
    request.fields['state'] = selectedState ?? '';
    request.fields['district'] = selectedDistrict ?? '';
    request.fields['isWhatsAppNumber'] = isWhatsAppNumber.toString();

    if (_image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'profileImage',
          _image!.path,
        ),
      );
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      debugPrint("Profile updated successfully");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile updated successfully")),
      );
    } else {
      debugPrint("Failed to update profile. Status code: ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update profile")),
      );
    }
  } catch (e) {
    debugPrint("Error updating profile: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error updating profile")),
    );
  }
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
                    backgroundImage: _image != null 
                        ? FileImage(_image!) 
                        : (profileImageUrl != null && profileImageUrl!.isNotEmpty
                            ? NetworkImage(profileImageUrl!)
                            : null),
                    child: (profileImageUrl == null || profileImageUrl!.isEmpty) && _image == null
                        ? Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
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
              isExpanded: true,
              items: stateDistrictMap.keys.map((String state) {
                return DropdownMenuItem(
                  value: state, 
                  child: Text(
                    state,
                    overflow: TextOverflow.ellipsis, // Shows ellipsis (...) if text is too long
                    style: TextStyle(fontSize: 14), // Smaller font size
                  )
                );
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
